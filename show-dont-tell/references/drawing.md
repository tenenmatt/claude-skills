# Drawing the diagram

Which mermaid type to use and how to keep it readable — for invoked and proactive diagrams alike.

## Pick the diagram type from the shape of the content

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

## Draw it so it reads at a glance

These principles apply to every type; the table maps them onto each type's own constructs.

- **Keep it small.** Roughly 20–25 elements. If it needs more, make an overview diagram plus one detail diagram per dense region (separate notes), and say so.
- **Overviews show the backbone, not every link.** Collapse each region into one element and keep only the main connections between regions. Cross-links make long crossing edges that no layout direction fixes, so leave them to the detail notes. If both TD and LR look bad, cut links before fiddling with direction.
- **Use real names.** The conversation's actual functions, files, services and terms. Keep labels short.
- **Put the "why" on the connections**, not crammed into the elements.
- **Group** by component or phase when it clarifies. But if the diagram tells a story in time order (a session recap, an investigation), grouping by kind pulls elements out of order and tangles the edges. Keep time order and show the kind with `classDef` colors instead, and give the color key in the caption (the note's, or one line under an inline diagram), since mermaid has no legend.
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
