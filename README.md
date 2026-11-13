# claude-skills

Skills for Claude — the Claude app and [Claude Code](https://claude.com/claude-code).

| Skill | What it does |
|---|---|
| [show-dont-tell](show-dont-tell/) | `/show-dont-tell [what to draw]` turns the current discussion into a mermaid diagram — inline in the Claude app; saved as a markdown note and rendered to PDF in Claude Code. |

## Install

Claude app: zip the skill's directory and upload it under Customize → Skills (see the skill's README about not also symlinking it).

Claude Code: symlink a skill's directory into `~/.claude/skills/`, from the repo root:

```bash
ln -s "$PWD/<skill>" ~/.claude/skills/<skill>
```

Each skill's README covers any dependencies and configuration.
