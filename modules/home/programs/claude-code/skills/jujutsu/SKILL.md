---
name: jujutsu
description: Use Jujutsu (jj) version control system for commits, rebasing, and history management
---

# Jujutsu (jj) Version Control

You are helping the user with Jujutsu (jj), a Git-compatible version control system. Use jj commands instead of git commands when working in repositories that use jj.

## Key Concepts

- **Working copy is a commit**: In jj, your working directory is always a commit. Changes are automatically tracked.
- **No staging area**: There's no `git add`. All changes in the working copy are part of the current commit.
- **Revsets**: jj uses a powerful revision selection language (like `@` for current, `@-` for parent, `root()..@` for all ancestors).
- **Operation log**: Every operation is recorded and can be undone with `jj undo`.

## Common Revset Symbols

- `@` - The current working copy commit
- `@-` - Parent of the current commit
- `@--` - Grandparent of the current commit
- `trunk()` - The main/master branch (remote tracking branch)
- `heads(trunk()..@)` - All head commits between trunk and current

## Essential Commands

### Status and Information
```bash
jj status          # Show working copy status (alias: jj st)
jj log             # Show commit history
jj diff            # Show changes in working copy
jj diff -r @-      # Show changes in parent commit
jj show            # Show current commit details
```

### Creating and Modifying Commits
```bash
jj new             # Create a new empty commit on top of current
jj new -m "msg"    # Create new commit with description
jj commit -m "msg" # Snapshot working copy and create new commit (alias: jj ci)
jj describe -m "msg"  # Set/change commit message for current commit
jj describe -r @- -m "msg"  # Change message of parent commit
```

### Working with Bookmarks (Branches)
```bash
jj bookmark list              # List all bookmarks
jj bookmark create <name>     # Create bookmark at current commit
jj bookmark set <name>        # Move bookmark to current commit
jj bookmark delete <name>     # Delete a bookmark
jj git push                   # Push to remote
jj git fetch                  # Fetch from remote
```

### Navigating History
```bash
jj edit @-         # Edit the parent commit (make it the working copy)
jj edit <rev>      # Edit any commit
jj new <rev>       # Create new commit on top of specified revision
```

### Rebasing and Squashing
```bash
jj rebase -d <destination>  # Rebase current commit onto destination
jj rebase -s <source> -d <dest>  # Rebase source and descendants onto dest
jj squash          # Squash current commit into parent
jj squash -r <rev> # Squash specified commit into its parent
jj squash --into <rev>  # Squash current into specified commit
```

### Splitting and Combining
```bash
jj split           # Interactively split current commit into multiple
jj fold            # Combine commits
```

### Undoing and Fixing Mistakes
```bash
jj undo            # Undo the last operation
jj op log          # Show operation history
jj op restore <op-id>  # Restore to a previous operation state
```

### Git Interop
```bash
jj git init        # Initialize jj in an existing Git repo
jj git push        # Push branches to Git remote
jj git fetch       # Fetch from Git remote
jj git clone <url> # Clone a Git repository
```

## Common Workflows

### Initializing from an Existing Git Repo
```bash
jj git init                              # Initialize jj in the existing git repo
jj bookmark track main --remote=origin   # Track the main branch from origin
```
This imports existing git history and sets up `trunk()` to point to your main branch.

### Starting New Work
```bash
jj new trunk() -m "feat: add new feature"
# Make changes...
jj bookmark create feature-branch
jj git push
```

### Amending Current Work
Changes are automatically included in the current commit. To update the message:
```bash
jj describe -m "updated message"
```

### Rebasing onto Latest Main
```bash
jj git fetch
jj rebase -d trunk()
```

### Interactive Commit Splitting
```bash
jj split  # Opens interactive mode to select changes for each commit
```

## Workspaces

Workspaces allow multiple working copies of the same repository, enabling parallel work on different changes without stashing or switching.

### Workspace Commands
```bash
jj workspace list              # List all workspaces
jj workspace add <path>        # Create a new workspace at path
jj workspace add <path> -r <rev>  # Create workspace starting at specific revision
jj workspace forget <name>     # Remove workspace from tracking (keeps files)
jj workspace root              # Show root directory of current workspace
```

### Workspace Workflow
```bash
# Create a workspace for a separate feature
jj workspace add ../my-repo-feature2

# Each workspace has its own working copy (@)
# but shares the same commit history

# In the new workspace, start work on a different commit
cd ../my-repo-feature2
jj new trunk() -m "feat: second feature"

# Changes in one workspace are immediately visible to others
# (they share the same repo)
```

### Workspace Notes
- Each workspace has its own `@` (working copy commit)
- All workspaces share the same commit graph and operation log
- Useful for: code review, parallel features, testing changes, comparing implementations
- Workspace names default to directory name

## Best Practices

### Atomic Commits per Task
Before starting each major task, create a new commit with a description of what will change:
```bash
jj new -m "feat: add user authentication"
# Do the work...
```
This creates clean separation between changes, making it easy to:
- Undo individual changes with `jj abandon`
- Review what changed for each task with `jj diff -r <rev>`
- Reorder or squash changes later

### Use Workspaces for Major Features
For substantial features, create a dedicated workspace:
```bash
jj workspace add ../my-repo-auth-feature
cd ../my-repo-auth-feature
jj new trunk() -m "feat: implement auth system"
```
This keeps feature work isolated and lets you switch contexts without losing state.

### Leverage the Operation Log
Every jj operation is recorded. When something goes wrong:
```bash
jj op log          # See what happened
jj undo            # Undo the last operation
jj op restore <id> # Jump back to any previous state
```
This is more powerful than git reflog—you can undo rebases, squashes, and other complex operations.

### Keep Commits Small, Split When Needed
If a commit grows too large, split it after the fact:
```bash
jj split           # Interactively split current commit
jj split -r @-     # Split a previous commit
```

### Rebase Frequently
Keep your work current with trunk to minimize merge conflicts:
```bash
jj git fetch
jj rebase -d trunk()
```

### Use Revsets for Precision
Instead of counting parents (`@--`), use descriptive revsets:
```bash
jj log -r "trunk()..@"           # All commits since trunk
jj rebase -s "description(feat)" -d trunk()  # Rebase by message
```

## Important Notes

- Always use `jj` commands, not `git` commands, in jj repositories
- The `.jj` directory indicates a jj repository
- jj repositories can coexist with `.git` for Git compatibility
- Use `jj git push` instead of `git push`
