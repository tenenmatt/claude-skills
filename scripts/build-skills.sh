#!/usr/bin/env bash
# Validate and zip every skill in this repo (any top-level directory with a SKILL.md).
#
# Usage: scripts/build-skills.sh [out-dir]      (default: dist/)
#
# Output: <out-dir>/<skill>.zip for each skill, plus <out-dir>/SHA256SUMS.
# Each zip holds a single <skill>/ folder, ready to upload under Customize -> Skills.
#
# Zips are deterministic: same tree in, same bytes out. File times are set to
# SOURCE_DATE_EPOCH (default: the last commit's time), entries are sorted, and
# permissions are normalized. Symlinks are replaced by the files they point to.
set -euo pipefail

repo="$(cd "$(dirname "$0")/.." && pwd)"
out="${1:-$repo/dist}"
mkdir -p "$out"
out="$(cd "$out" && pwd)"

epoch="${SOURCE_DATE_EPOCH:-$(git -C "$repo" log -1 --format=%ct 2>/dev/null || echo 315532800)}"
stamp="$(TZ=UTC date -d "@$epoch" +%Y%m%d%H%M.%S 2>/dev/null || TZ=UTC date -r "$epoch" +%Y%m%d%H%M.%S)"

stage="$(mktemp -d)"
trap 'rm -rf "$stage"' EXIT

fail=0
skills=()
for dir in "$repo"/*/; do
  dir="${dir%/}"
  [[ -f "$dir/SKILL.md" ]] || continue
  name="$(basename "$dir")"
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
  cp -RL "$repo/$name" "$stage/$name"
  find "$stage/$name" \( -name .DS_Store -o -name '*~' \) -delete
  find "$stage/$name" -type d -exec chmod 755 {} +
  find "$stage/$name" -type f -exec chmod 644 {} +
  find "$stage/$name" -type f -path '*/scripts/*' -exec chmod 755 {} +
  find "$stage/$name" -exec env TZ=UTC touch -h -t "$stamp" {} +
  (cd "$stage" && find "$name" -print | LC_ALL=C sort | TZ=UTC zip -q -X -@ "$out/$name.zip")
  echo "built $name.zip"
done

(cd "$out" && sha256sum -- *.zip > SHA256SUMS 2>/dev/null || shasum -a 256 -- *.zip > SHA256SUMS)
cat "$out/SHA256SUMS"
