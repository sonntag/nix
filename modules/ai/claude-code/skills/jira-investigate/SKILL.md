---
name: jira-investigate
description: Investigate an Amperity Jira ticket end-to-end — pull the ticket, check related code, check Honeycomb for alerting, propose a plan or draft a fix. Invoke when the user references an AI-XXXX ticket, a Jira URL like amperity.atlassian.net/browse/..., or asks to "investigate" or "fix" a ticket.
---

# Jira Investigation (Amperity)

Drive a full investigation that combines Jira, Honeycomb, the relevant repo, and (when appropriate) Google Drive AAR docs. The output is either a plan (for ambiguous tickets) or a draft PR (for concrete bug fixes).

## Workflow

1. **Fetch the ticket**: `mcp__claude_ai_Atlassian__getJiraIssue` with the ticket key (e.g., `AI-1514`). The Amperity AI project key is `AI`.
2. **Read carefully**: capture the symptom, the reporter's hypothesis (if any), linked tickets, and any attached AAR / Google Doc links. Use `WebFetch` for `docs.google.com` AAR links.
3. **Decide intent**:
   - Concrete bug or task with a clear ask → investigate and draft a fix.
   - Vague or open-ended ("see if there's any work needed") → investigate and produce a plan; do not modify code without confirming.
4. **Find the code**. Use the repo at `cwd`, or ask which repo if it's unclear. Common repos: `amperity-mcp`, `app`, `sidekick`, `foundations-api`.
5. **Check Honeycomb when relevant**: if the ticket is about reliability, errors, missing data, or alerting, invoke the `honeycomb-investigate` workflow. Confirm whether the service is currently alerted on this failure mode using `get_triggers` / `get_slos`.
6. **Propose a plan** before editing code. List the changes and any new triggers/SLOs needed. Wait for confirmation.

## Atlassian MCP tools

- `getJiraIssue` — start here; pulls description, comments, links, status.
- `searchJiraIssuesUsingJql` — find related tickets (e.g., `project = AI AND text ~ "<symptom>"`).
- `getTransitionsForJiraIssue` + `transitionJiraIssue` — move the ticket when closing it out.
- `addCommentToJiraIssue` — post the PR link or investigation summary back to the ticket when done.

## When the fix is concrete: draft PR convention

- Open the PR as a **draft** (`gh pr create --draft`). The user wants to review before requesting reviewers.
- PR title should reference the ticket key (e.g., `AI-1514: ...`).
- Push a single well-scoped commit; do not bundle unrelated cleanup.

## When the gap is monitoring

- Don't suggest "make the error message more user-friendly" as the fix for missing alerting — the user wants to be paged.
- Propose a Honeycomb trigger scoped precisely. Past feedback: triggers must be scoped to the specific failure mode (e.g., `feature-id`), not the whole service.
- Confirm before calling any tool that creates a trigger.

## Closing the loop

After the fix lands:
- Comment on the Jira ticket with the PR link and a one-line summary of what changed.
- Offer to transition the ticket (don't transition unprompted).
