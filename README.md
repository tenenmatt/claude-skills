# claude-skills

Skills for [Claude Code](https://claude.com/claude-code).

| Skill | What it does |
|---|---|
| [show-dont-tell](show-dont-tell/) | `/show-dont-tell [what to draw]` turns the current discussion into a mermaid diagram, saved as a markdown note and rendered to PDF. |

## Install

Symlink a skill's directory into `~/.claude/skills/`, from the repo root:

```bash
ln -s "$PWD/<skill>" ~/.claude/skills/<skill>
```

Each skill's README covers any dependencies and configuration.
