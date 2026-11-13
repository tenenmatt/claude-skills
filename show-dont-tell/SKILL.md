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

## 1. Decide what to draw — or ask

- **With an argument:** draw that, grounded in what this conversation has actually covered (code read, decisions made, concepts discussed). If the argument doesn't map onto anything in the conversation, or could mean several different things, ask — don't guess.
- **Without an argument:** distill the discussion. If it has one dominant thread, proceed and state the scope in one line ("Drawing: how the retry logic interacts with the queue, as a flowchart"). If there are several plausible threads, ask with AskUserQuestion (or in plain text if that tool isn't available), offering each thread as an option.
- The user may say not to open or save the result ("don't open it", "no pdf", "just show me"); honor that.

## 2. Pick the diagram type from the shape of the content

| Content | Mermaid type |
|---|---|
| Distilled discussion, a topic broken into subtopics (a tree) | `mindmap` |
| Concepts that relate in a web (cross-links, not a tree) | `flowchart` with labeled edges |
| Execution / control flow, decisions, pipelines | `flowchart TD` (or `LR` for linear pipelines) |
| Interactions between actors/services over time | `sequenceDiagram` |
| Lifecycle, modes, transitions | `stateDiagram-v2` |
| Data model, entities and relationships | `erDiagram` / `classDiagram` |
| Events over time | `timeline` |
| Recap of the session itself (what happened, what led to what) | `flowchart TD` in time order, colored by kind (see Group below) |

Mindmaps cannot express cross-links; if relationships *between* branches matter, use a flowchart.

## 3. Draw it so it reads at a glance

These principles apply to every type; the table maps them onto each type's own constructs.

- **Keep it small.** Roughly 20–25 elements. If it needs more, make an overview diagram plus one detail diagram per dense region (separate notes), and say so.
- **Overviews show the backbone, not every link.** Collapse each region into one element and keep only the main connections between regions. Cross-links make long crossing edges that no layout direction fixes, so leave them to the detail notes. If both TD and LR look bad, cut links before fiddling with direction.
- **Use real names.** The conversation's actual functions, files, services and terms. Keep labels short.
- **Put the "why" on the connections**, not crammed into the elements.
- **Group** by component or phase when it clarifies. But if the diagram tells a story in time order (a session recap, an investigation), grouping by kind pulls elements out of order and tangles the edges. Keep time order and show the kind with `classDef` colors instead, and give the color key in the note's caption, since mermaid has no legend.
- **Every element earns its place.** This is a distillation, not a transcript.

| Type | Elements (count these) | Connections / the "why" | Grouping & annotation |
|---|---|---|---|
| `flowchart` | nodes | edge labels `A -- reason --> B` | `subgraph` |
| `sequenceDiagram` | participants (≤ ~7) and messages | message text | `box` around participants; `alt`/`opt`/`loop`/`par` blocks; `Note over` |
| `stateDiagram-v2` | states | transition labels | composite states; `note` |
| `mindmap` | nodes (depth ≤ 3–4) | — (tree only) | branch structure itself |
| `erDiagram` / `classDiagram` | entities / classes (show only relevant fields) | relationship labels, cardinality | `namespace` (class) |
| `timeline` | events | — | `section` |

Special characters:

- In node labels, quote anything with punctuation: `A["parse(input); retry"]`.
- In sequence-diagram message and note text, quoting doesn't help, and a bare `;` ends the statement and breaks the render. Write it as `#59;` (renders as `;`), or rephrase with a comma or dash.


## 4. Deliver it

Choose by what this session can actually do, not by product name:

- **You can render visuals inline in the conversation** (an inline SVG/HTML widget tool — e.g. the Claude app on web, desktop or mobile) **and have no shell in the user's working directory:** follow **Inline** below.
- **You have a shell in the user's working directory** (Claude Code): follow `references/claude-code.md` — save the note, render a PDF, check it, open it.
- **Neither:** give the mermaid source in a fenced ` ```mermaid ` block and say in one line that it renders in Obsidian, GitHub, or mermaid.live.

### Inline

The point here is that the picture sits next to the discussion it illustrates.

1. Write the mermaid source first, exactly as you would for the note — the same diagram types and rules from steps 2–3 apply.
2. Render it with the inline-visual tool, as HTML that loads mermaid from a CDN the tool allows and renders that source. Follow the tool's own guidance for loading libraries, theming (light and dark) and fonts; read that guidance first if the tool asks you to. Don't hand-redraw the diagram as custom SVG: keeping it mermaid keeps it consistent with Claude Code and lets the source be saved as a note unchanged.
3. Check it. If it renders an error or is unreadable (overlapping labels, far too wide to read at chat width), fix the source — direction, grouping, splitting into overview + detail — and render again. Chat width is narrow, so prefer `TD` over `LR` unless the content is a short linear pipeline.
4. Iterating in the same conversation ("collapse the auth part", "make it LR") means re-rendering the revised diagram, not explaining the change.

Don't write files unless asked. Then offer once, in one line, to keep it:

- If a folder on the user's computer is connected (e.g. their Obsidian vault), offer to save it there as a note in the format below.
- Otherwise offer the mermaid source as a `.md` file in that format, which they can drop into their vault.

Finish with at most one line on what was drawn. Don't re-explain the diagram in prose — that's the point.

### Note format

Used whenever the diagram is saved, in any environment. Name it `YYYY-MM-DD <Short Title>.md`:

````markdown
---
tags: [diagram, show-dont-tell]
cssclasses: [show-dont-tell]
created: YYYY-MM-DD
---
<One or two sentences: what this shows and what prompted it.>

```mermaid
...
```
````

When iterating on a diagram already saved in this conversation, overwrite the same note rather than creating a new one.
