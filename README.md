# show-dont-tell

A Claude Code skill: `/show-dont-tell [what to draw]` turns the current discussion (or a named part of it) into a mermaid diagram, saves it as a markdown note, renders a PDF, and opens it.

With no argument it distills the discussion, asking first if there's more than one plausible thread.

## Install

```bash
ln -s "$PWD/show-dont-tell" ~/.claude/skills/show-dont-tell
npm i -g @mermaid-js/mermaid-cli   # optional; otherwise rendered via npx (slow first run)
```

## Configure

Notes go to `$SHOW_DONT_TELL_DIR`, or `./diagrams` in the working directory if unset. To send them to an Obsidian vault (which renders mermaid natively), add to `~/.claude/settings.json`:

```json
"env": { "SHOW_DONT_TELL_DIR": "/path/to/vault/show-dont-tell" }
```

The note is the durable artifact. The PDF is a throwaway preview rendered to Claude's session scratchpad (or `$TMPDIR/show-dont-tell/`); ask to keep it and it goes in a `pdf/` subfolder next to the note instead.
