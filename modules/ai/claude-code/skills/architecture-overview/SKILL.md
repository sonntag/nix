---
name: architecture-overview
description: Generate a high-level architectural overview of a repo, service, or subsystem. Invoke when the user asks to "read through this project and give an architectural overview", asks "how does X work", or asks to map one architecture to another. Output is HTML, not markdown.
---

# Architecture Overview

Produce a high-level architectural overview that a teammate can read cold. The overview is for sharing, so the final artifact is an **HTML file**, not markdown.

## Workflow

1. **Orient first**: read the top-level `README`, `CLAUDE.md`, `pyproject.toml` / `deps.edn` / `package.json`, and the top-level directory layout. Identify the language, framework, and deployment shape (service, library, CLI, monorepo subdir).
2. **Find the entrypoint(s)** and trace the request/data flow once end-to-end before writing anything. Don't summarize directories — summarize *behavior*.
3. **Ask the user up front** which axes they care about (e.g., request flow, persistence, deployment, auth). Default coverage if they don't specify: entrypoints, request flow, persistence, deployment, key abstractions, layering rules.
4. **Use `Agent` subtasks for parallel exploration** of independent areas (e.g., one subagent for the data layer, one for the API layer). Don't use `codebase-memory-mcp.get_architecture` here — past sessions show the user wants Claude to actually read the code.
5. **Confirm before writing the file**: present the outline first. The user often has specific follow-up questions that should shape the doc.

## Output format: HTML

Always produce HTML, not markdown. The user prefers HTML for sharing and consumption.

- **Location**: `<repo>/docs/architecture.html` by default, unless the user specifies otherwise.
- **Style**: light mode, single self-contained `.html` file with inline `<style>`. No external CSS/JS dependencies.
- **Typography**: system font stack, comfortable line height (~1.6), readable max-width (~860px), generous headings.
- **Diagrams**: prefer **inline SVG** for non-trivial flows. Mermaid is acceptable for simple call graphs but the user has stated SVG is "significantly better" for anything with multiple components. Embed Mermaid via the CDN script only when SVG would be overkill.
- **Tables**: use HTML `<table>` for comparing modes/deployments/options. The user reaches for tables for these comparisons.
- **Code**: use `<pre><code>` blocks for directory trees, request examples, and short snippets.

## Sections (default skeleton)

```
<h1>{Service} Architecture</h1>
<section> Summary — what this is, who calls it, what it depends on (3-5 sentences).
<section> Deployment modes — table if there are multiple (e.g., stdio vs HTTP MCP).
<section> Request flow — inline SVG diagram, then a numbered list walking through one canonical request.
<section> Key components — one subsection per component with responsibility + key files.
<section> Persistence / state — what's stored where, what's ephemeral, where caches live.
<section> Layering rules / invariants — what must not depend on what; called out clearly.
<section> Open questions / known limitations — surfaced from CLAUDE.md, TODOs, or things you couldn't determine.
```

Adjust to fit the actual system. Don't pad sections that don't apply.

## House style

- Be specific. Name the file (`src/handlers/foo.py`), the function (`dispatch_request`), the port (`8080`). Vague overviews are not useful.
- Call out invariants as their own bullets — these are what readers need most.
- When something can't be determined from the code, say so explicitly rather than guessing.
- Length: detailed but scannable. Headings, tables, and bullets over walls of prose.

## After writing

Offer to walk through it with the user, and expect specific follow-up questions ("how does the dispatcher know which pod to route to?", "where does the session cache live?"). Update the HTML in place via `Edit` rather than rewriting.
