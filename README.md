# claude-skills

Skills for Claude — the Claude app and [Claude Code](https://claude.com/claude-code).

| Skill | What it does |
|---|---|
| [show-dont-tell](show-dont-tell/) | `/show-dont-tell [what to draw]` turns the current discussion into a mermaid diagram — inline in the Claude app (also proactively, if you like); saved as a markdown note and rendered to PDF in Claude Code. |

## Install

### Claude app (recommended)

Download the skill's zip from the [latest release](https://github.com/tenenmatt/claude-skills/releases/latest) and upload it under **Customize → Skills**. Each skill has a stable link:

```
https://github.com/tenenmatt/claude-skills/releases/latest/download/<skill>.zip
```

Skills on your Claude account also sync (one way) into Claude Code when you're signed in with the same account, so this covers Code too, with nothing to install on a new machine. To update a skill, download the new zip and upload it again.

### Claude Code only

If you don't use the app, symlink a skill's directory into `~/.claude/skills/` from the repo root. Don't do this as well as uploading, or Code loads two copies.

```bash
ln -s "$PWD/<skill>" ~/.claude/skills/<skill>
```

Each skill's README covers any dependencies and configuration.

## Building

Every push to `main` validates each skill (any top-level folder with a `SKILL.md`), zips it, and republishes the [`latest` release](https://github.com/tenenmatt/claude-skills/releases/latest). The release notes name the commit it was built from, and `SHA256SUMS` lists each zip's checksum. Pull requests get the same zips as a downloadable artifact on their workflow run, so you can try a change before merging. Those zips aren't published.

To build locally:

```bash
scripts/build-skills.sh        # writes dist/<skill>.zip and dist/SHA256SUMS
```

The zips are deterministic: the same tree always produces the same bytes, so a changed checksum means the contents changed. Validation checks the frontmatter against the app's upload rules: `name` matches the folder, is lowercase-and-hyphens, at most 64 characters, and avoids the reserved words; `description` is present, at most 1,024 characters, and has no XML tags.
