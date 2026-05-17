---
name: pr-fix
description: Address review feedback and resolve merge conflicts on the user's own open PRs. Invoke when the user says "fix feedback on PR X", "address comments on PR X", or "fix merge conflicts on PR X". Different from the `review` skill, which reviews someone else's PR.
---

# PR Fix

Walk the user through addressing review comments and resolving merge conflicts on their own open PRs.

## Fetching all the relevant comments

The user has been bitten by missing inline review comments before. **`gh pr view --comments` returns only top-level review comments — it does NOT include inline line comments.** Always fetch both:

```bash
# Top-level metadata
gh pr view <N> --json title,state,mergeable,mergeStateStatus,headRefName,baseRefName,body

# Top-level review comments
gh pr view <N> --comments --json reviews,comments

# Inline line comments (THE IMPORTANT ONE)
gh api repos/<owner>/<repo>/pulls/<N>/comments
```

Pretty-print inline comments so each can be triaged individually:

```bash
gh api repos/<owner>/<repo>/pulls/<N>/comments | python3 -c "
import json, sys
for c in json.load(sys.stdin):
    print(f'---\nID: {c[\"id\"]}\nAuthor: {c[\"user\"][\"login\"]}\nFile: {c[\"path\"]}:{c.get(\"line\") or c.get(\"original_line\")}\nBody: {c[\"body\"]}\n')
"
```

## Per-comment workflow

For each comment, present:
- Author + file:line
- The comment body verbatim
- A short recommendation: "Apply", "Skip", or "Apply with modification (...)"

Then **wait for the user to pick** which comments to apply. The user often says things like "Yeah apply 7 and skip 6." Do not apply comments wholesale.

After applying, reply to each addressed inline comment:

```bash
gh api repos/<owner>/<repo>/pulls/<N>/comments/<comment-id>/replies -f body="Done in <commit-sha>"
```

## Merge conflicts: ALWAYS merge, never rebase

The user's convention is merge commits, not rebases:

```bash
git fetch origin
git checkout <branch>
git status
git merge origin/main --no-commit --no-ff
# inspect conflicts
git diff --conflict=diff3 <file>
# resolve
git add <files>
git commit -m "Merge main into <branch>

Resolve conflicts in <files> (<one-line summary>)."
git push origin <branch>
```

Most conflicts in Amperity Python repos are `pyproject.toml` / `uv.lock` version bumps; resolve by keeping the higher version and running `uv lock`.

## Pushing

Push immediately after fixing — don't wait for re-review. Then verify the PR is mergeable:

```bash
gh pr view <N> --json mergeStateStatus,mergeable
```

## Commit messages

Use HEREDOC for multi-line commit messages. New commits, never `--amend` (the user prefers stacking commits so reviewers can see what changed).

## Reporting back

After all comments are addressed and the merge is clean, report:
- Which comments were applied vs skipped (and why for skipped)
- New `mergeStateStatus`
- Link to the PR
