---
name: show-dont-tell-auto
description: In the Claude app (not Claude Code), proactively draw an inline mermaid diagram when a longer discussion reaches a point where a picture would reinforce the text — a flow or pipeline, how parts of a system interact, a lifecycle, a set of related concepts, or a recap after a long stretch. Not for quick Q&A, writing tasks, or personal conversations.
---

# Show, don't tell — proactively

The companion to `/show-dont-tell`: the same diagrams, but drawn without being asked, at the points in a conversation where a picture would help the user hold the discussion in their head. The user turns this behavior on and off by enabling or disabling this skill.

## Only in the app

Use this only if you can render visuals inline in the conversation **and** have no shell in the user's working directory. In Claude Code, do nothing: there the user runs `/show-dont-tell` when they want a diagram.

## When to draw

Draw when all of these hold:

- **The structure is the hard part.** The discussion involves several parts that relate — a flow, a system, a lifecycle, a decision with branches, a web of concepts — and the text is making the user hold that structure in their head.
- **It's been building.** Several exchanges into the topic, or one long explanation; not the first answer to a simple question.
- **The user is trying to understand**, not just get a deliverable, a fact, or a draft.
- **It adds something.** A diagram of the same thread drawn earlier doesn't count again unless the structure has changed meaningfully.

Don't draw for short factual answers, writing or editing tasks, code the user asked for, emotional or personal conversations, or when the user is clearly moving fast.

## How often

- Default: at most one unprompted diagram per thread of discussion, and rarely more than two or three in a conversation.
- If the user's preferences (personal preferences in their settings, or saved preferences) say how often they want proactive diagrams — e.g. "proactive diagrams: off", "rare", "often", "only for architecture" — that overrides the default.
- If the user says anything like "fewer diagrams", "stop drawing", or "no more pictures", stop for the rest of the conversation. Don't argue or ask why.
- If the user runs `/show-dont-tell`, that skill handles it; this one's budget doesn't apply.

## How to draw

1. Pick the type and draw it by `references/drawing.md`. Keep proactive diagrams on the small end — an overview of the backbone, not every detail.
2. Render it as `references/inline.md` describes.
3. Place it where it helps within your reply, introduced by one short sentence ("Here's how those pieces fit together."). The reply still answers the user's message in full; the diagram reinforces it and doesn't replace the answer.
4. Don't offer to save it unprompted. If the user asks to keep it, use `references/note-format.md` as `inline.md` describes.
