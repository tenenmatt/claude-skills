# show-dont-tell-auto

The proactive companion to [show-dont-tell](../show-dont-tell/). In the Claude app, it draws an inline mermaid diagram on its own when a longer discussion gets to a point where a picture would reinforce the text. In Claude Code it does nothing: there, `/show-dont-tell` stays command-only.

It shares its drawing rules with `show-dont-tell`: `references/` here holds symlinks into `../show-dont-tell/references/`, so the rules live in one place.

## Install

Claude app: zip and upload under Customize → Skills. `zip -r` follows the symlinks and stores the real files; don't pass `-y`.

```bash
cd /path/to/claude-skills && zip -r show-dont-tell-auto.zip show-dont-tell-auto
```

## Configure (no PR needed)

- **On/off:** toggle the skill under Customize → Skills.
- **How often:** add a line to your personal preferences in Claude's settings, e.g. `Proactive diagrams: rare` (or `often`, or `only for architecture and flows`). The skill follows it over its default of about one diagram per thread.
- **In the moment:** say "fewer diagrams" or "stop drawing" and it stops for the rest of that conversation.
