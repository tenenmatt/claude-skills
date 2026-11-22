#!/usr/bin/env bash
# Validate and zip every skill in this repo (any top-level directory with a SKILL.md).
#
# Usage: scripts/build-skills.sh [out-dir]      (default: dist/)
#
# Output: <out-dir>/<skill>.zip for each skill, plus <out-dir>/SHA256SUMS.
# Each zip holds a single <skill>/ folder, ready to upload under Customize -> Skills.
#
# Only files tracked by git go in, so a local build matches CI. Symlinks are
# stored as the files they point to.
#
# Zips are deterministic: same files in, same bytes out. Each skill's file times
# are set to the last commit that touched that skill's folder, so a commit that
# doesn't touch a skill leaves its zip byte-identical. Set SOURCE_DATE_EPOCH to
# override the time for every skill. Entries are sorted and permissions
# normalized. Needs full git history (a shallow clone gives every skill HEAD's time).
set -euo pipefail

repo="$(cd "$(dirname "$0")/.." && pwd)"
out="${1:-$repo/dist}"
mkdir -p "$out"
out="$(cd "$out" && pwd)"

if [[ -z "${SOURCE_DATE_EPOCH:-}" && "$(git -C "$repo" rev-parse --is-shallow-repository)" == true ]]; then
  echo "build-skills: warning: shallow clone, so per-skill times may be wrong (fetch full history)" >&2
fi

# Last commit time for a skill folder; 1980-01-01 (the earliest zip time) if it has none.
skill_epoch() {
  local t
  t="$(git -C "$repo" log -1 --format=%ct -- "$1")"
  echo "${t:-315532800}"
}

# Epoch seconds -> touch -t stamp, in UTC (GNU date, then BSD/macOS date).
to_stamp() {
  TZ=UTC date -d "@$1" +%Y%m%d%H%M.%S 2>/dev/null || TZ=UTC date -r "$1" +%Y%m%d%H%M.%S
}

stage="$(mktemp -d)"
trap 'rm -rf "$stage"' EXIT

fail=0
skills=()
for dir in "$repo"/*/; do
  dir="${dir%/}"
  name="$(basename "$dir")"
  git -C "$repo" ls-files --error-unmatch -- "$name/SKILL.md" >/dev/null 2>&1 || continue
  if python3 "$repo/scripts/validate-skill.py" "$dir"; then
    skills+=("$name")
  else
    fail=1
  fi
done

if (( fail )); then
  echo "build-skills: validation failed; nothing built" >&2
  exit 1
fi
if (( ${#skills[@]} == 0 )); then
  echo "build-skills: no skills found" >&2
  exit 1
fi

rm -f "$out"/*.zip "$out/SHA256SUMS"
for name in "${skills[@]}"; do
  while IFS= read -r -d '' f; do
    [[ -e "$repo/$f" ]] || continue   # tracked but deleted in the working tree
    mkdir -p "$stage/$(dirname "$f")"
    cp -RL "$repo/$f" "$stage/$f"
  done < <(git -C "$repo" ls-files -z -- "$name")
  stamp="$(to_stamp "${SOURCE_DATE_EPOCH:-$(skill_epoch "$name")}")"
  find "$stage/$name" -type d -exec chmod 755 {} +
  find "$stage/$name" -type f -exec chmod 644 {} +
  find "$stage/$name" -type f -path '*/scripts/*' -exec chmod 755 {} +
  find "$stage/$name" -exec env TZ=UTC touch -h -t "$stamp" {} +
  (cd "$stage" && find "$name" -print | LC_ALL=C sort | TZ=UTC zip -q -X -@ "$out/$name.zip")
  echo "built $name.zip"
done

if command -v sha256sum >/dev/null; then
  (cd "$out" && sha256sum -- *.zip > SHA256SUMS)
else
  (cd "$out" && shasum -a 256 -- *.zip > SHA256SUMS)
fi
cat "$out/SHA256SUMS"
