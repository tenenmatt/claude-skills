# Drawing proactively (Claude app only)

SKILL.md has already established that this session renders visuals inline and has no shell in the user's working directory. If not, stop: don't draw unasked.

## When to draw

Draw when all of these hold:

- **The structure is the hard part.** The discussion involves several parts that relate — a flow, a system, a lifecycle, a decision with branches, a web of concepts — and the text is making the user hold that structure in their head.
- **It's been building.** Several exchanges into the topic, or one long explanation; not the first answer to a simple question.
- **The user is trying to understand**, not just get a deliverable, a fact, or a draft.
- **It adds something.** A diagram of the same thread drawn earlier doesn't count again unless the structure has changed meaningfully.

Don't draw for short factual answers, writing or editing tasks, code the user asked for, emotional or personal conversations, or when the user is clearly moving fast.

## How often

- Default: at most one unprompted diagram per thread of discussion, and rarely more than two or three in a conversation.
- The user's preferences (personal preferences in their settings, or saved preferences) override the default — e.g. "Proactive diagrams: off", "rare", "often", "only for architecture". "Off" means never draw unasked; `/show-dont-tell` still works.
- If the user says anything like "fewer diagrams", "stop drawing", or "no more pictures", stop drawing unasked for the rest of the conversation. Don't argue or ask why.

## How to present it

1. Keep it on the small end of `drawing.md` — the backbone, not every detail.
2. Render it as `inline.md` describes.
3. Place it where it helps within your reply, introduced by one short sentence ("Here's how those pieces fit together."). The reply still answers the user's message in full; the diagram reinforces it and doesn't replace it.
4. Don't offer to save it unprompted. If the user asks to keep it, use `note-format.md` as `inline.md` describes.
