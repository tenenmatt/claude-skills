# Rendering inline (Claude app)

The point is that the picture sits next to the discussion it illustrates.

1. Write the mermaid source first, following `drawing.md`, exactly as you would for a saved note.
2. Render it with the inline-visual tool, as HTML that loads mermaid from a CDN the tool allows and renders that source. Follow the tool's own guidance for loading libraries, theming (light and dark) and fonts; read that guidance first if the tool asks you to. Don't hand-redraw the diagram as custom SVG: keeping it mermaid keeps it consistent with Claude Code and lets the source be saved as a note unchanged.
3. Check it. If it renders an error or is unreadable (overlapping labels, far too wide to read at chat width), fix the source — direction, grouping, splitting into overview + detail — and render again. Chat width is narrow, so prefer `TD` over `LR` unless the content is a short linear pipeline.
4. Iterating in the same conversation ("collapse the auth part", "make it LR") means re-rendering the revised diagram, not explaining the change.

Colors that hold up in both light and dark mode:

- mermaid's `classDef` colors are fixed strings, so pick the light or dark set in the script (from the page's theme) and interpolate them into the source before rendering.
- `timeline` sections take their colors from the theme variables `cScale0…n` and `cScaleLabel0…n`; set those the same way.
- In a `timeline`, `:` separates a period from its events, so write clock times as `11.26`, not `11:26`.

Saving: don't write files unless asked. If asked, use `note-format.md` — into a connected folder on the user's computer (e.g. their Obsidian vault) if there is one, otherwise as a `.md` file sent to the user.
