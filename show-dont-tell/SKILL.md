---
name: show-dont-tell
description: Turn the current discussion (or a named aspect of it) into a mermaid diagram — drawn inline in the Claude app, or saved as a markdown note and rendered to PDF in Claude Code. Use when the user runs /show-dont-tell or asks for a diagram of the discussion. Also use proactively, but only where diagrams render inline in the conversation (the Claude app, not Claude Code), when a longer discussion reaches a point where a picture would reinforce the text — a flow or pipeline, how parts of a system interact, a lifecycle, a set of related concepts, or a recap after a long stretch. Not for quick Q&A, writing tasks, or personal conversations.
argument-hint: "[what to draw, e.g. 'the current execution flow']"
---

# Show, don't tell

A picture instead of a wall of text. Request: `$ARGUMENTS`

(If that reads literally as `$ARGUMENTS`, this environment doesn't substitute it: the request is whatever the user wrote alongside the invocation, possibly nothing.)

## 0. Invoked or proactive?

- **Invoked** — the user ran `/show-dont-tell` or asked for a diagram: follow steps 1–4.
- **Proactive** — you're drawing on your own initiative. **Only if you can render visuals inline in the conversation and have no shell in the user's working directory.** In Claude Code, don't draw proactively at all: delivery there writes files into the project and opens a PDF, which nobody should get unasked; the user runs `/show-dont-tell` when they want one. Where proactive drawing is allowed, read `references/proactive.md` for when and how often, then follow steps 2–3 and render inline.

Steps 1–3 decide and draw the diagram and apply everywhere. Step 4 delivers it, and differs by environment.

## 1. Decide what to draw — or ask

- **With an argument:** draw that, grounded in what this conversation has actually covered (code read, decisions made, concepts discussed). If the argument doesn't map onto anything in the conversation, or could mean several different things, ask — don't guess.
- **Without an argument:** distill the discussion. If it has one dominant thread, proceed and state the scope in one line ("Drawing: how the retry logic interacts with the queue, as a flowchart"). If there are several plausible threads, ask with AskUserQuestion (or in plain text if that tool isn't available), offering each thread as an option.
- The user may say not to open or save the result ("don't open it", "no pdf", "just show me"); honor that.

## 2–3. Pick the type and draw it

Read `references/drawing.md` and follow it: it maps the content to a mermaid type and sets the readability rules.

## 4. Deliver it

Choose by what this session can actually do, not by product name:

- **You can render visuals inline in the conversation** (an inline SVG/HTML widget tool — e.g. the Claude app on web, desktop or mobile) **and have no shell in the user's working directory:** render it as `references/inline.md` describes. Then offer once, in one line, to keep it as a note (`references/note-format.md`) — saved to a connected folder on the user's computer if there is one, otherwise as a `.md` file. Finish with at most one line on what was drawn.
- **You have a shell in the user's working directory** (Claude Code): follow `references/claude-code.md` — save the note, render a PDF, check it, open it.
- **Neither:** give the mermaid source in a fenced ` ```mermaid ` block and say in one line that it renders in Obsidian, GitHub, or mermaid.live.

Don't re-explain the diagram in prose — that's the point.
