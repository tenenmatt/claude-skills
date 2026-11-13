# Delivering in Claude Code

Save the diagram as a note, render a disposable PDF preview, check it, open it.

## Save the note

Resolve the output directory:

```bash
echo "${SHOW_DONT_TELL_DIR:-$PWD/diagrams}"
```

Write `<dir>/YYYY-MM-DD <Short Title>.md` (create the directory if needed) in the format from `note-format.md`.

## Render, check, open

The note is the durable artifact; the PDF is a disposable preview. Render it somewhere ephemeral, not next to the note:

- your session scratchpad directory, if the system prompt gives you one;
- otherwise `${TMPDIR:-/tmp}/show-dont-tell/`.

Only if the user asks to keep the PDF, render it to `<dir>/pdf/` instead.

```bash
mkdir -p "<pdf dir>"
"${CLAUDE_SKILL_DIR}/scripts/render.sh" "<note>.md" "<pdf dir>/<same name>.pdf"
```

- On a syntax error, fix the mermaid and re-render. Don't hand over a broken diagram.
- Read the PDF to check it is legible (no overlapping labels, not absurdly wide). If it's poor, adjust direction/grouping/splitting and re-render.
- Then `open` the PDF (unless told not to).

Finish with one line: what was drawn and the note's path. Don't re-explain the diagram in prose — that's the point.
