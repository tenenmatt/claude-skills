# show-dont-tell

`/show-dont-tell [what to draw]` turns the current discussion (or a named part of it) into a mermaid diagram.

- **In the Claude app** (web, desktop, mobile): draws it inline in the conversation, next to the discussion it illustrates, and offers to save it as a note.
- **In Claude Code:** saves it as a markdown note, renders a PDF, and opens it.

For diagrams drawn without the command, see [show-dont-tell-auto](../show-dont-tell-auto/).

Deciding what to draw and how to keep it readable is shared; only delivery differs. Delivery is chosen by what the session can do (inline visuals vs. a shell in your working directory), with the Code steps in `references/claude-code.md`.

With no argument it distills the discussion, asking first if there's more than one plausible thread.

## Install

### Claude app

Zip the skill folder and upload it under Customize → Skills:

```bash
cd /path/to/claude-skills && zip -r show-dont-tell.zip show-dont-tell
```

Skills on your Claude account also sync (one way) into Claude Code when you're signed in with the same account. So if you upload it, **remove the `~/.claude/skills` symlink below**, or Code will load two copies. The repo stays the source of truth: re-zip and re-upload after changes.

### Claude Code only

From the repo root:

```bash
ln -s "$PWD/show-dont-tell" ~/.claude/skills/show-dont-tell
npm i -g @mermaid-js/mermaid-cli   # optional; otherwise rendered via npx (slow first run)
```

## Configure

Notes go to `$SHOW_DONT_TELL_DIR`, or `./diagrams` in the working directory if unset. To send them to an Obsidian vault (which renders mermaid natively), add to `~/.claude/settings.json`:

```json
"env": { "SHOW_DONT_TELL_DIR": "/path/to/vault/show-dont-tell" }
```

### Obsidian: full-width diagrams

Obsidian's readable line length clips wide diagrams. Notes carry `cssclasses: [show-dont-tell]`; copy `obsidian/show-dont-tell.css` to `<vault>/.obsidian/snippets/` and enable it (Settings → Appearance → CSS snippets) so those diagrams use the full pane width and scale to fit. Other notes are unaffected.

### PDFs

The note is the durable artifact. The PDF is a throwaway preview rendered to Claude's session scratchpad (or `$TMPDIR/show-dont-tell/`); ask to keep it and it goes in a `pdf/` subfolder next to the note instead.
