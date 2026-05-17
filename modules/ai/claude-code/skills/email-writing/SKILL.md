---
name: email-writing
description: Draft, polish, or revise emails and short-form professional messages (Slack, LinkedIn DMs, etc.) in the user's voice. Invoke when the user asks to write, proofread, revise, or improve a message they're sending to another person.
---

# Email writing in the user's voice

Use this skill any time the output is a message a human will receive: emails, replies, LinkedIn DMs, Slack messages to people outside the immediate working channel. Do not use it for internal commit messages, PR descriptions, or documentation.

## Hard rules

These are non-negotiable. Violating them is the most common feedback the user gives.

1. **No em-dashes.** Ever. Use a comma, a semicolon, a colon, parentheses, or a new sentence instead. Also avoid en-dashes (–) used as em-dash substitutes. Hyphens in compound words are fine.
2. **No AI-tells.** Don't open with "I hope this email finds you well." Don't write "I wanted to reach out." Don't end with "Please don't hesitate to..." Don't say "delve," "leverage," "robust," "seamless," or "synergy."
3. **Contractions on.** "I'm", "I've", "you're", "we'll", "don't". Not "I am," "you are," "do not" — unless emphasizing.
4. **Be specific.** Reference the actual thing: the position title, the conversation topic, the date, the name. Vague openers ("regarding our previous discussion") feel canned.

## Voice

- Direct and warm. Friendly without being effusive.
- Short sentences mixed with medium ones. Avoid long compound sentences with multiple clauses.
- Lead with context, then the ask. Not the reverse.
- Soften asks gently when appropriate: "I was wondering if...", "Would it be possible to...", "Let me know if...". Don't pile softeners; one is enough.
- Sign-offs: "Thanks," / "Best," / "Cheers,". No "Warm regards" or "Sincerely."

## Greetings

Match the relationship and channel:
- Formal or first-contact email: `Hi <First>,` (note the comma, not an exclamation).
- Known contact, friendly: `Hey <First>,` or `Hey <First>!`.
- Single-letter abbreviation is fine if the user uses one for that person: `Hi V,`.
- No greeting at all is acceptable in a continuing thread reply.

## Structure for a typical reply or outreach

1. **Anchor** (1 sentence): what prompted this message. "Thanks for sending that over." / "I saw your note about X." / "I came across some openings at <company>."
2. **Substance** (1–3 sentences): the actual content — context, the ask, or the answer.
3. **Soft close** (optional, 1 sentence): availability, next step, or thanks.
4. **Sign-off + name.**

Keep most messages under 120 words unless the content genuinely needs more.

## When the user pastes existing text

If the user pastes a draft and asks for proofreading or revision:
- Preserve their voice. Don't rewrite from scratch unless asked.
- Fix em-dashes, typos, and awkward phrasing.
- Point out anything that reads as off-tone (too stiff, too casual, ambiguous ask).
- Offer 1–2 alternatives for any section you significantly changed, so the user can pick.
- If the draft cuts off mid-sentence, finish the thought in the user's voice rather than inventing a new direction.

## When asked to write from scratch

- Ask for missing inputs only if essential: the recipient (name + relationship), the goal of the message, any specific points to include. Don't interrogate — one round of clarifying questions max.
- Present the draft in a fenced block so it's easy to copy. No preamble like "Here's a draft:" — just the draft.
- After the draft, mention any choices you made that the user might want to change (greeting style, level of formality, included/excluded details).

## Output format

Default to a copy-pasteable block. Subject line on its own first line if relevant:

```
Subject: <line>

<body>

<sign-off>,
<name>
```

If the user is replying in an existing thread, omit the subject line.
