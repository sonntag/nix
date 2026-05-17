---
name: honeycomb-investigate
description: Investigate traces, spans, and metrics in Honeycomb for Amperity services. Invoke when the user asks "why am I not seeing X in honeycomb", asks to add/find span attributes, references a Honeycomb trace ID, or asks about alerting/SLOs for an Amperity service.
---

# Honeycomb Investigation (Amperity)

Use the Honeycomb MCP to investigate observability questions about Amperity services. The Honeycomb MCP requires column validation before queries — invalid columns cause hard failures.

## Required workflow (do not skip steps)

1. **`get_workspace_context`** — confirm team, environments, default datasets. Always do this first.
2. **`find_columns`** or **`get_dataset_columns`** — validate every attribute name before you reference it in a query. Span attribute names in Amperity are inconsistent (some `mcp.*`, some `amperity.*`, some `ken.trace/*`); never assume.
3. **`run_query`** with validated columns. Use breakdowns + filters; common ops are `=`, `starts-with`, `exists`, `does-not-exist`, `contains`.
4. **`get_trace`** to drill into a specific `trace_id` returned by the query.
5. **`get_triggers`** / **`get_slos`** when the question is about alerting.

## Amperity environments and datasets

- Environments: `non-prod`, `prod`.
- Datasets seen most often: `amperity-mcp`, `sidekick`, `foundations-api`, `amperity.foundations-api`.
- `service.name` determines which dataset a span lands in. Cross-dataset traces stitch via shared `trace_id`.

## Span attributes the user typically cares about

MCP layer:
- `mcp.tool.name` — which MCP tool was called.
- `mcp.client.name` — which client (Claude.ai, Claude Code, etc.).
- `amperity.principal_email`, `amperity.tier`, `amperity.tier.redirect_host`, `amperity.tier.client_id`, `amperity.tier.is_employee`.
- `amperity.auth.tenant/id`, `amperity.api.request/uri`.

Ken (Clojure) tracing:
- `ken.trace/trace-id`, `ken.trace/span-id`, `ken.trace/parent-id`, `ken.event/label`.

OTel standard:
- `trace.trace_id`, `trace.span_id`, `trace.parent_id`.

Sidekick:
- `amperity.sidekick.message/total-tokens`, `amperity.sidekick.message/prompt-tokens`, `amperity.sidekick.message/completion-tokens`.
- `amperity.sidekick.session/id`, `amperity.sidekick.task/id`.

## Tracing library conventions

- Amperity Clojure services use **`ken`** (`~/Development/amperity/ken`), a tracing library that emits W3C-compatible `traceparent` headers (`00-{32hex}-{16hex}-{2hex}`).
- The Python MCP server uses OTel: `opentelemetry-api/sdk/exporter-otlp-proto-http >= 1.27.0`, `BatchSpanProcessor`, `propagate.inject(headers)` for outbound calls.
- Honeycomb endpoint: `https://api.honeycomb.io/v1/traces` with `x-honeycomb-team` header. API key: `vault read -field=api-key secret/terraform/honeycomb/non-prod`.

## Common query patterns

- "Which clients are calling tool X?" → filter `name starts-with "mcp.tool"` + breakdown by `mcp.client.name`.
- "Are spans missing attribute X?" → COUNT with filter `X does-not-exist` then breakdown by `service.name` or `name`.
- "What's the tokens-per-second?" → HEATMAP or AVG on `amperity.sidekick.message/total-tokens` over `duration_ms`.
- Use `time_range` in seconds (e.g., `86400` for last 24h) — not strings.

## When proposing new instrumentation

- Match existing naming conventions in the service: `amperity.<domain>.<noun>/<field>` for ken, `<namespace>.<noun>.<field>` for OTel-style.
- Confirm the attribute will appear on the relevant span layer (tool-call span vs. session span vs. request span). Many "missing attribute" investigations are actually "set on the wrong span".

## When proposing new triggers

- Scope filters precisely. The user has called out triggers being too broad before ("that CDA trigger is not scoped to feature-id"). Confirm scope before creating.
- Don't suggest "make it more user-friendly" as a fix for missing alerting — the user wants to be paged when something breaks, not just see a nicer error.
- Confirm with the user before calling any tool that creates/modifies triggers, boards, or SLOs.
