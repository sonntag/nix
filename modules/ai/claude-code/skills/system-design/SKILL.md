---
name: system-design
description: Produce a system design document for a proposed architecture, evaluation of alternatives, or a major refactor — with diagrams, tradeoffs, and worked examples. Invoke when the user asks to "design a system", "evaluate options for X", "propose an architecture", or "compare X vs Y". Output is HTML, not markdown.
---

# System Design

Produce a shareable system design document. These are written for an audience that may not know the underlying tools (e.g., "make it as obvious as possible for people who aren't familiar with LangSmith"), so clarity beats density.

## Output format: HTML

Always produce HTML, not markdown. The user shares these with teammates via Slack / Google Drive and prefers HTML for consumption.

- **Self-contained `.html` file** with inline `<style>` — no external CSS/JS dependencies.
- **Light mode.** The user has explicitly called this out.
- **System font stack**, ~860px max-width, ~1.6 line-height, generous headings.
- Save under the repo or worktree the design pertains to, e.g., `<repo>/<design-name>.html`. Confirm the filename before creating.

## Diagrams: inline SVG, not Mermaid

Past feedback is unambiguous: "the SVG version is significantly better. Let's keep that and get rid of the mermaid version."

- **Architectural diagrams: inline SVG.** Hand-draw the boxes and arrows in SVG. Use clean rectangles, consistent stroke widths, and a small legend if needed.
- **Per-example flow diagrams: also SVG**, one per worked example.
- Mermaid is only acceptable for trivial single-arrow flows or sequence diagrams where SVG would be overkill.
- All diagrams must be readable in light mode (no dark backgrounds, sufficient contrast).

## Required sections

```
<h1>{Design name}</h1>

<section> Summary
  Two or three sentences: what is being proposed, why now, what the recommendation is.

<section> Context
  The problem, the constraints, what exists today. Audience-aware: define any tool/framework
  names the audience may not know.

<section> Proposed architecture
  Inline SVG diagram. Then a list explaining each labeled component.

<section> Benefits and tradeoffs per component
  For each component in the diagram: what it gives us, what it costs us. Per-component, not
  one big lump.

<section> Worked examples
  3-4 concrete examples showing how existing or future features map to the architecture. Each
  example gets its own SVG flow diagram + a short narrative. Examples should be specific to
  the user's domain (e.g., "Segment AI Assistant chat", "follow-you-in-the-app deep agent",
  "field description agent", "agent-based workflow tasks").

<section> Alternatives considered
  Each alternative gets: one-paragraph description + a comparison row in a table (latency,
  complexity, observability, vendor lock-in, ...). The user reads these to decide tradeoffs,
  so they have to be specific.

<section> Open questions
  Things that need a decision before this can move forward.
```

Drop or merge sections that don't apply to a specific design. Don't pad.

## Workflow

1. Ask the user about scope, audience, and constraints before writing. Don't assume.
2. Sketch the diagram and the section outline first. Show the outline before producing the full HTML.
3. Produce the full HTML in one shot once the outline is approved.
4. Iterate via `Edit` on the HTML file based on user critiques — don't rewrite from scratch. Past sessions show the user refines designs incrementally: simplifying arrows, fixing wrong component connections, adding missing services.

## House style

- Audience-aware: define jargon, explain frameworks (LangChain, Deep Agents, Anthropic Agent SDK) when introduced.
- Concrete over abstract: name the services, the queues, the libraries.
- When proposing multiple options, give a clear recommendation in the summary. Don't equivocate.
- Worked examples are not optional — they are the most important section for adoption.

## Sharing

When the user asks for a sharing link, the HTML can be uploaded to Google Drive (manually or via MCP) — confirm the upload path before doing it.
