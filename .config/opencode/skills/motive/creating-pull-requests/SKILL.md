---
name: creating-pull-requests
description: Use when creating or updating a pull request on GitHub, after implementation is complete — handles Jira ticket resolution, commit format validation, branch naming, and PR creation with company-standard format
---

# Creating Pull Requests

## Overview

Orchestrate the full PR creation workflow: resolve a Jira ticket, enforce commit format and branch naming conventions, auto-generate a PR with the company template, and push to GitHub.

**Core principle:** Every PR must have a Jira ticket, conforming commits, a correctly named branch, and a standardized PR body. No shortcuts.

**Announce at start:** "I'm using the creating-pull-requests skill to create this PR."

## The Process

### Step 1: Resolve Jira Ticket

Every PR requires a Jira ticket. Search for an existing one before creating a new one.

**Search order:**

1. Current sprint tickets assigned to user:

```bash
acli jira workitem search --jql "assignee = currentUser() AND sprint in openSprints() AND status != Done" --json
```

2. If none found, search project-level open tickets:

```bash
acli jira workitem search --jql "assignee = currentUser() AND status != Done" --json --limit 10
```

3. Present results to user, ask them to pick the relevant ticket.

4. If no ticket exists, create one:

```bash
# List projects to suggest the most likely one
acli jira project list --json

# List open epics in the chosen project
acli jira workitem search --jql "project = <PROJECT> AND type = Epic AND status != Done" --json

# Create the ticket under the chosen epic
acli jira workitem create --summary "<summary>" --project "<PROJECT>" --type "Task" --assignee "@me" --parent "<EPIC-KEY>"
```

when creating the jira ticket ask the user for one phrase describing the change, and use that as the summary. For example, if the user says "I added a new XGBoost model for SBV CBB", the summary could be "Add XGBoost model for SBV CBB".

**Result:** `JIRA_KEY` (e.g., `OP-107`) — used in all subsequent steps.

### Step 2: Validate Branch Name

**Required format:** `type/JIRA_KEY-short-description`

```
^(feat|fix|chore|docs|style|refactor|perf|test|build|ci)/[A-Z]+-\d+-.+$
```

**Examples:**
- `feat/OP-107-xgboost-sbv-cbb`
- `fix/AUTH-91-expired-refresh-tokens`

**Actions:**

```bash
# Get current branch
git branch --show-current
```

- If on `main` or `master`: ask user for the type and description, then create branch:
  ```bash
  git checkout -b type/JIRA_KEY-short-description
  ```
- If branch name doesn't match the pattern: offer to rename:
  ```bash
  git branch -m <new-name>
  ```
- If branch name already conforms: proceed.

### Step 3: Validate Commit Messages

**Required format:** `type(JIRA_KEY): lowercase description`

```
^(feat|fix|chore|docs|style|refactor|perf|test|build|ci)\([A-Z]+-\d+\): .+$
```

**Valid examples:**
- `feat(TEST-123): add saved filters to search results`
- `fix(AUTH-91): handle expired refresh tokens`

**Invalid examples:**
- `added filters`
- `fix: auth bug`
- `feat(123): missing project prefix`

**Actions:**

```bash
# Determine base branch
git merge-base HEAD main 2>/dev/null || git merge-base HEAD master 2>/dev/null

# List commits on the branch
git log <base>..HEAD --oneline
```

Check each commit message against the required format.

If non-conforming commits are found:

- **Single commit:** suggest amend:
  ```bash
  git commit --amend -m "type(JIRA_KEY): corrected description"
  ```
- **Multiple commits:** show which commits fail and suggest the user rebase interactively to reword them. Provide the corrected message format for each failing commit.

**Do NOT push until all commits conform.**

### Step 4: Push Branch

```bash
git push -u origin <branch-name>
```

If the branch already exists on the remote and has diverged, inform the user and ask how to proceed (force push or reconcile).

### Step 5: Auto-Generate PR Content

Analyze the diff and commit history to generate the PR:

```bash
# Get the full diff
git diff <base>...HEAD

# Get commit log
git log <base>..HEAD --format="%s%n%b"
```

**Generate PR title:**

```
type(JIRA_KEY): Short Description
```

The type and JIRA_KEY come from Step 1 and Step 3. The description should summarize the change concisely.

**Generate PR body using this template:**

```
## Why is this change needed?
<generated from commit messages and diff context>

## How does the PR address the problem?
<generated from diff analysis — what was added/changed/removed>

## How was this change tested?
<generated if test files are in the diff, otherwise ask the user>

## What else do I need to know?
<generated or "Nothing">

Jira: https://k2labs.atlassian.net/browse/JIRA_KEY
```

**Present the generated title and body to the user for review.** Wait for approval or edits before proceeding.

### Step 6: Update the JIRA ticket
Update the jira description with the things we did in the PR, so that the ticket is up to date with the work we did. If it deviates too much from the original description ask the user for confirmation before updating the ticket.

### Step 7: Create PR

```bash
gh pr create --title "type(JIRA_KEY): Description" --body "$(cat <<'EOF'
## Why is this change needed?
...

## How does the PR address the problem?
...

## How was this change tested?
...

## What else do I need to know?
...

Jira: https://k2labs.atlassian.net/browse/JIRA_KEY
EOF
)"
```

### Step 7: Report Result

Output the PR URL to the user.

## Commit Format Reference

| Type | Use |
|------|-----|
| `feat` | New feature |
| `fix` | Bug fix |
| `chore` | Maintenance, dependencies |
| `docs` | Documentation only |
| `style` | Formatting, no code change |
| `refactor` | Code restructuring |
| `perf` | Performance improvement |
| `test` | Adding/fixing tests |
| `build` | Build system changes |
| `ci` | CI configuration |

**Formats at a glance:**

| Item | Pattern | Example |
|------|---------|---------|
| Commit message | `type(JIRA-123): description` | `feat(OP-107): add xgboost model for sbv cbb` |
| PR title | `type(JIRA-123): Description` | `feat(OP-107): XGBoost Model for SBV CBB` |
| Branch name | `type/JIRA-123-description` | `feat/OP-107-xgboost-sbv-cbb` |

## PR Body Template

```
## Why is this change needed?
<Explain the motivation — what problem exists or what feature is needed>

## How does the PR address the problem?
<Describe the approach — what was added, changed, or removed>

## How was this change tested?
<Describe testing — unit tests, integration tests, manual testing, etc.>

## What else do I need to know?
<Any additional context, migration steps, or "Nothing">

Jira: https://k2labs.atlassian.net/browse/<JIRA_KEY>
```

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Pushing without validating commits | Always validate commit format in Step 3 before pushing |
| Skipping Jira ticket resolution | Every PR must have a Jira ticket — no exceptions |
| Using `gh pr create --fill` | Always use the company template, never `--fill` |
| Creating PR from main/master | Always create a feature branch first (Step 2) |
| Forgetting Jira link in PR body | The template includes it — always fill in the `JIRA_KEY` |
| Commit description in uppercase | Commit descriptions should be lowercase; PR titles can use title case |
| Branch name missing Jira key | Branch must include `JIRA_KEY` between type and description |

## Red Flags

If you catch yourself thinking any of these, STOP:

| Thought | Reality |
|---------|---------|
| "I'll add the Jira ticket later" | No. Resolve it first — it's needed for commits, branch, and PR. |
| "The commit format is close enough" | Close enough will be blocked. Match the regex exactly. |
| "I'll just push and fix the PR body later" | Present the PR content for review first. Always. |
| "This is a small change, skip the template" | Every PR uses the template. No exceptions. |
| "The branch name doesn't matter" | It does — `type/JIRA_KEY-description` is enforced. |

## Integration

- **Uses:** `acli-jira` skill (Jira ticket search and creation), `using-github-cli` skill (PR creation commands)
