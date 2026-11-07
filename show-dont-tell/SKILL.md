---
name: show-dont-tell
description: Turn the current discussion (or a named aspect of it) into a mermaid diagram, saved as a markdown note and rendered to PDF. Use only when the user invokes /show-dont-tell.
argument-hint: "[what to draw, e.g. 'the current execution flow']"
disable-model-invocation: true
---

# Show, don't tell

The user wants a picture instead of a wall of text. Request: `$ARGUMENTS`

## 1. Decide what to draw — or ask

- **With an argument:** draw that, grounded in what this conversation has actually covered (code read, decisions made, concepts discussed). If the argument doesn't map onto anything in the conversation, or could mean several different things, ask — don't guess.
- **Without an argument:** distill the discussion. If it has one dominant thread, proceed and state the scope in one line ("Drawing: how the retry logic interacts with the queue, as a flowchart"). If there are several plausible threads, ask with AskUserQuestion, offering each thread as an option.
- The user may say not to open the result ("don't open it", "no pdf"); honor that.

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

Mindmaps cannot express cross-links; if relationships *between* branches matter, use a flowchart.

## 3. Draw it so it reads at a glance

These principles apply to every type; the table maps them onto each type's own constructs.

- **Keep it small.** Roughly 20–25 elements. If it needs more, make an overview diagram plus one detail diagram per dense region (separate notes), and say so.
- **Use real names.** The conversation's actual functions, files, services and terms. Keep labels short.
- **Put the "why" on the connections**, not crammed into the elements.
- **Group** by component or phase when it clarifies.
- **Every element earns its place.** This is a distillation, not a transcript.

| Type | Elements (count these) | Connections / the "why" | Grouping & annotation |
|---|---|---|---|
| `flowchart` | nodes | edge labels `A -- reason --> B` | `subgraph` |
| `sequenceDiagram` | participants (≤ ~7) and messages | message text | `box` around participants; `alt`/`opt`/`loop`/`par` blocks; `Note over` |
| `stateDiagram-v2` | states | transition labels | composite states; `note` |
| `mindmap` | nodes (depth ≤ 3–4) | — (tree only) | branch structure itself |
| `erDiagram` / `classDiagram` | entities / classes (show only relevant fields) | relationship labels, cardinality | `namespace` (class) |
| `timeline` | events | — | `section` |

Quote labels containing special characters: `A["parse(input)"]`.

## 4. Save it

Resolve the output directory:

```bash
echo "${SHOW_DONT_TELL_DIR:-$PWD/diagrams}"
```

Write `<dir>/YYYY-MM-DD <Short Title>.md` (create the directory if needed) as:

````markdown
---
tags: [diagram, show-dont-tell]
source: <working directory>
created: YYYY-MM-DD
---
<One or two sentences: what this shows and what prompted it.>

```mermaid
...
```
````

When iterating on a diagram from this conversation ("collapse the auth part", "make it LR"), overwrite the same note rather than creating a new one.

## 5. Render, check, open

The note is the durable artifact; the PDF is a disposable preview. Render it somewhere ephemeral, not next to the note:

- your session scratchpad directory, if the system prompt gives you one;
- otherwise `${TMPDIR:-/tmp}/show-dont-tell/`.

Only if the user asks to keep the PDF, render it to `<dir>/pdf/` instead.

```bash
mkdir -p "<pdf dir>"
"${CLAUDE_SKILL_DIR}/scripts/render.sh" "<note>.md" "<pdf dir>/<same name>.pdf"
```

- On a syntax error, fix the mermaid and re-render. Don't hand over a broken diagram.
- Read the PDF to check it is legible (no overlapping labels, not absurdly wide). If it's poor, adjust direction/grouping/splitting and re-render.
- Then `open` the PDF (unless told not to).

Finish with one line: what was drawn and the note's path. Don't re-explain the diagram in prose — that's the point.
