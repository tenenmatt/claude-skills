#!/usr/bin/env bash
# Render the first ```mermaid block of a markdown note (or a raw .mmd file) to PDF.
# Usage: render.sh <note.md|diagram.mmd> <out.pdf>
set -euo pipefail

src="$1"
out="$2"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

if [[ "$src" == *.md ]]; then
  awk '/^```mermaid/{f=1; next} /^```/{if (f) exit} f' "$src" > "$tmp/diagram.mmd"
else
  cp "$src" "$tmp/diagram.mmd"
fi

if [[ ! -s "$tmp/diagram.mmd" ]]; then
  echo "render.sh: no mermaid content found in $src" >&2
  exit 1
fi

if command -v mmdc >/dev/null 2>&1; then
  mmdc=(mmdc)
else
  mmdc=(npx -y -p @mermaid-js/mermaid-cli mmdc)
fi

"${mmdc[@]}" -i "$tmp/diagram.mmd" -o "$out" -q
echo "$out"
