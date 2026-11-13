---
name: show-dont-tell
description: Turn the current discussion (or a named aspect of it) into a mermaid diagram — drawn inline in a chat conversation, or saved as a markdown note and rendered to PDF in Claude Code. Use only when the user invokes /show-dont-tell.
argument-hint: "[what to draw, e.g. 'the current execution flow']"
disable-model-invocation: true
---

# Show, don't tell

The user wants a picture instead of a wall of text. Request: `$ARGUMENTS`

(If that reads literally as `$ARGUMENTS`, this environment doesn't substitute it: the request is whatever the user wrote alongside the invocation, possibly nothing.)

Steps 1–3 decide and draw the diagram and apply everywhere. Step 4 delivers it, and differs by environment.

For proactive diagrams without the command, see the companion skill `show-dont-tell-auto`; this one runs only when invoked.

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
