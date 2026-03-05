---
name: using-github-cli
description: Use when performing GitHub operations like creating PRs, managing releases, or interacting with GitHub Actions from the command line
---

# Using the GitHub CLI

## Overview

The GitHub CLI (`gh`) is the standard tool for interacting with GitHub from the terminal. It handles authentication automatically, outputs structured data, and replaces the need for raw `curl` calls to the GitHub API.

**Core principle:** Use `gh` for all GitHub operations. Never use `curl` with GitHub API endpoints when `gh` is available — it handles auth, pagination, and error handling for you.

**When to use `gh` vs `git`:**
- `git` — local operations: commits, branches, push, pull, rebase
- `gh` — GitHub-specific operations: PRs, releases, actions, API calls

## Quick Reference

| Task | Command |
|------|---------|
| Create PR | `gh pr create --title "..." --body "..."` |
| List PRs | `gh pr list` |
| View PR | `gh pr view <number>` |
| Checkout PR | `gh pr checkout <number>` |
| Merge PR | `gh pr merge <number>` |
| Review PR | `gh pr review <number>` |
| View PR diff | `gh pr diff <number>` |
| View PR checks | `gh pr checks <number>` |
| Close PR | `gh pr close <number>` |
| Comment on PR | `gh pr comment <number> --body "..."` |
| Create release | `gh release create <tag>` |
| List releases | `gh release list` |
| View release | `gh release view <tag>` |
| Download release | `gh release download <tag>` |
| Delete release | `gh release delete <tag>` |
| List workflow runs | `gh run list` |
| View run details | `gh run view <run-id>` |
| Watch run live | `gh run watch <run-id>` |
| List workflows | `gh workflow list` |
| Trigger workflow | `gh workflow run <workflow>` |
| Call any API | `gh api <endpoint>` |

## Pull Requests

### Creating PRs

```bash
# Basic PR
gh pr create --title "Add user auth" --body "Implements JWT-based authentication"

# Draft PR with specific base branch
gh pr create --title "WIP: refactor" --body "..." --base develop --draft

# PR with labels and reviewers
gh pr create --title "Fix login bug" --body "..." --label bug --reviewer octocat

# Multi-line body using HEREDOC
gh pr create --title "Add feature X" --body "$(cat <<'EOF'
## Summary
- Added new endpoint for user preferences
- Updated database schema

## Testing
- Unit tests added
- Manual testing on staging
EOF
)"
```

**Key flags:**
| Flag | Purpose |
|------|---------|
| `--title` | PR title (required unless interactive) |
| `--body` | PR description |
| `--base` | Target branch (default: repo default branch) |
| `--draft` | Create as draft PR |
| `--label` | Add labels (repeatable) |
| `--reviewer` | Request reviewers (repeatable) |
| `--assignee` | Assign users (repeatable) |
| `--milestone` | Set milestone |
| `--fill` | Auto-fill title and body from commits |
| `--web` | Open in browser after creating |

### Listing and Viewing PRs

```bash
# List open PRs
gh pr list

# List PRs with filters
gh pr list --state merged --author @me --limit 10
gh pr list --label "bug" --base main

# View PR details
gh pr view 123
gh pr view 123 --json title,body,reviews,statusCheckRollup

# View PR diff
gh pr diff 123

# View PR comments
gh api repos/{owner}/{repo}/pulls/123/comments
```

### Checking Out and Reviewing PRs

```bash
# Check out a PR locally
gh pr checkout 123

# Leave an approval
gh pr review 123 --approve --body "LGTM"

# Request changes
gh pr review 123 --request-changes --body "Please fix the error handling"

# Leave a comment review (no approval/rejection)
gh pr review 123 --comment --body "Looks good overall, minor suggestions inline"
```

### Merging PRs

```bash
# Merge with merge commit (default)
gh pr merge 123

# Squash merge
gh pr merge 123 --squash

# Rebase merge
gh pr merge 123 --rebase

# Auto-merge when checks pass
gh pr merge 123 --auto --squash

# Merge and delete branch
gh pr merge 123 --squash --delete-branch
```

**Key flags:**
| Flag | Purpose |
|------|---------|
| `--squash` | Squash and merge |
| `--rebase` | Rebase and merge |
| `--auto` | Enable auto-merge (merges when checks pass) |
| `--delete-branch` | Delete branch after merge |
| `--subject` | Custom merge commit subject |
| `--body` | Custom merge commit body |

### PR Checks and CI Status

```bash
# View all checks on a PR
gh pr checks 123

# Wait for checks to complete
gh pr checks 123 --watch

# Get check status as JSON
gh pr checks 123 --json name,state,conclusion
```

### Closing and Commenting

```bash
# Close a PR without merging
gh pr close 123

# Close with a comment
gh pr close 123 --comment "Superseded by #456"

# Add a comment to a PR
gh pr comment 123 --body "Updated the migration script"
```

## Releases

### Creating Releases

```bash
# Create release from existing tag
gh release create v1.2.0

# Create release with title and notes
gh release create v1.2.0 --title "Version 1.2.0" --notes "Bug fixes and improvements"

# Create release with auto-generated notes
gh release create v1.2.0 --generate-notes

# Create release with asset files
gh release create v1.2.0 ./dist/app-linux.tar.gz ./dist/app-macos.tar.gz

# Create draft release
gh release create v1.2.0 --draft --title "v1.2.0" --generate-notes

# Create pre-release
gh release create v1.2.0-beta.1 --prerelease --title "v1.2.0 Beta 1"

# Multi-line release notes with HEREDOC
gh release create v1.2.0 --title "v1.2.0" --notes "$(cat <<'EOF'
## What's Changed
- Fixed authentication timeout
- Added dark mode support

## Breaking Changes
- Removed deprecated `/v1/users` endpoint
EOF
)"
```

**Key flags:**
| Flag | Purpose |
|------|---------|
| `--title` | Release title |
| `--notes` | Release notes text |
| `--notes-file` | Read notes from file |
| `--generate-notes` | Auto-generate from commits |
| `--draft` | Create as draft |
| `--prerelease` | Mark as pre-release |
| `--target` | Target branch/commit (default: current) |
| `--latest` | Mark as latest release |

### Listing, Viewing, and Downloading

```bash
# List releases
gh release list
gh release list --limit 5

# View release details
gh release view v1.2.0

# Download release assets
gh release download v1.2.0
gh release download v1.2.0 --pattern "*.tar.gz" --dir ./downloads

# Delete a release
gh release delete v1.2.0 --yes
gh release delete v1.2.0 --cleanup-tag --yes  # also delete the git tag
```

## Actions / Workflows

### Viewing Workflow Runs

```bash
# List recent runs
gh run list
gh run list --limit 10 --workflow build.yml

# List runs with filters
gh run list --branch main --status failure
gh run list --user @me

# View a specific run
gh run view <run-id>

# View run logs
gh run view <run-id> --log
gh run view <run-id> --log-failed  # only failed steps

# Watch a run in progress
gh run watch <run-id>

# Re-run a failed workflow
gh run rerun <run-id>
gh run rerun <run-id> --failed  # only re-run failed jobs
```

### Triggering Workflows

```bash
# List available workflows
gh workflow list

# Trigger a workflow_dispatch event
gh workflow run deploy.yml

# Trigger with input parameters
gh workflow run deploy.yml --field environment=staging --field version=v1.2.0

# Trigger on a specific branch
gh workflow run build.yml --ref feature-branch
```

**Key flags for `gh run list`:**
| Flag | Purpose |
|------|---------|
| `--workflow` | Filter by workflow file name |
| `--branch` | Filter by branch |
| `--status` | Filter: `queued`, `in_progress`, `completed`, `failure`, `success` |
| `--user` | Filter by user who triggered |
| `--limit` | Number of results |
| `--json` | Output as JSON |

## The `gh api` Escape Hatch

For any GitHub API endpoint not covered by dedicated commands, use `gh api` directly. It handles authentication, base URL, and content types automatically.

```bash
# GET request (default)
gh api repos/{owner}/{repo}/contributors

# POST request with JSON body
gh api repos/{owner}/{repo}/labels -f name="priority" -f color="ff0000"

# Use --method for other HTTP methods
gh api repos/{owner}/{repo}/labels/priority --method DELETE

# Pagination — automatically follow all pages
gh api repos/{owner}/{repo}/commits --paginate

# Filter with JQ
gh api repos/{owner}/{repo}/pulls --jq '.[].title'

# Combine pagination and JQ
gh api repos/{owner}/{repo}/commits --paginate --jq '.[].sha'

# POST with raw JSON body
gh api graphql -f query='
  query {
    repository(owner: "owner", name: "repo") {
      pullRequests(last: 5) {
        nodes { title url }
      }
    }
  }
'
```

**Key flags:**
| Flag | Purpose |
|------|---------|
| `--method` | HTTP method (`GET`, `POST`, `PUT`, `PATCH`, `DELETE`) |
| `-f` / `--field` | Add a typed field (strings, bools, ints) |
| `-F` / `--raw-field` | Add a string field (no type inference) |
| `--jq` | Filter JSON output with JQ expression |
| `--paginate` | Follow pagination to get all results |
| `--template` | Format output with Go template |
| `-H` | Set custom HTTP headers |

**Path variables:** `{owner}` and `{repo}` are auto-filled from the current git repository context. Use explicit values when not in a repo directory.

## Common Patterns

### JSON Output for Scripting

Most `gh` commands support `--json` for structured output:

```bash
# Get specific fields as JSON
gh pr list --json number,title,author
gh pr view 123 --json title,body,reviews,statusCheckRollup

# Combine with --jq for filtering
gh pr list --json number,title --jq '.[] | select(.title | test("fix"))'

# Get just values
gh pr list --json number --jq '.[].number'
```

### HEREDOC for Multi-Line Content

Always use HEREDOC for PR/release bodies with formatting:

```bash
gh pr create --title "Feature: Dark Mode" --body "$(cat <<'EOF'
## Summary
- Implemented dark mode toggle
- Added theme persistence

## Testing
- Unit tests for theme context
- Visual regression tests
EOF
)"
```

**Note:** Use `<<'EOF'` (quoted) to prevent shell variable expansion inside the body.

### Repo Context

`gh` auto-detects the repository from the current git directory. When running outside a repo:

```bash
# Specify repo explicitly
gh pr list --repo owner/repo-name
gh release list --repo owner/repo-name

# Works with any command
gh api repos/owner/repo-name/pulls
```

### End-to-End PR Workflow

```bash
# 1. Create and push feature branch
git checkout -b feature/dark-mode
# ... make changes ...
git add -A && git commit -m "Add dark mode support"
git push -u origin feature/dark-mode

# 2. Create PR
gh pr create --title "Add dark mode support" --body "$(cat <<'EOF'
## Summary
- Dark mode toggle in settings
- Theme persisted in localStorage
EOF
)"

# 3. Check CI status
gh pr checks <pr-number> --watch

# 4. Merge when ready
gh pr merge <pr-number> --squash --delete-branch
```

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Using `curl` with GitHub API | Use `gh api` — handles auth, pagination, base URL automatically |
| Forgetting `--repo` outside a git directory | Always specify `--repo owner/name` when not in a repo |
| Not using `--json` for parseable output | Use `--json field1,field2 --jq '.[]'` instead of parsing human-readable text |
| Unescaped characters in PR body strings | Use HEREDOC with `<<'EOF'` to avoid quoting issues |
| Using `--fill` when you need a specific body | `--fill` uses commit messages; use `--title` and `--body` for control |
| Guessing run IDs | Use `gh run list` first to get the correct run ID |
| Not checking if `gh` is authenticated | Run `gh auth status` to verify before starting |
| Interactive prompts in non-interactive agents | Always provide all required flags (`--title`, `--body`, etc.) to avoid interactive prompts |
