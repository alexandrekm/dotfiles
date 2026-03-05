---
name: reviewing-copilot-comments
description: Use when reviewing a PR that has GitHub Copilot code review comments, or when the user asks to check automated PR feedback, or after running /review-copilot
---

# Reviewing Copilot Comments

## Overview

Fetch, evaluate, and act on GitHub Copilot's automated code review comments on a PR.

**Core principle:** Assess before acting. Copilot suggestions are not orders — evaluate each technically, propose a specific fix, and let the user decide.

## The Process

```
WHEN reviewing Copilot comments:

1. DETECT: Find PR from current branch
2. FETCH: Get Copilot's reviews and inline comments via gh API
3. SUMMARIZE: Present all comments in a table
4. ITERATE: For each comment — show it, assess it, propose fix, ask user
5. APPLY: Batch-apply all approved fixes
6. COMMIT: Stage, commit, push
7. REPORT: Summary of actions taken
```

## Step 1: Detect PR

```bash
# Get PR from current branch
gh pr view --json number,url,title,headRefName,baseRefName

# Extract owner/repo from git remote
gh repo view --json nameWithOwner --jq '.nameWithOwner'
```

If no PR found on current branch, ask the user for a PR number or URL.

Display the PR title and number for confirmation before proceeding.

## Step 2: Fetch Copilot Reviews

```bash
# Get owner/repo
REPO=$(gh repo view --json nameWithOwner --jq '.nameWithOwner')
PR_NUMBER=$(gh pr view --json number --jq '.number')

# Find Copilot's review IDs
gh api "repos/${REPO}/pulls/${PR_NUMBER}/reviews" --paginate \
  --jq '[.[] | select(.user.login == "copilot")] | .[] | {id, state, body}'

# For each review ID, fetch inline comments
gh api "repos/${REPO}/pulls/${PR_NUMBER}/reviews/{REVIEW_ID}/comments" --paginate \
  --jq '.[] | {id, path, line, body, diff_hunk}'
```

**If the login `copilot` returns no results**, also try `copilot[bot]` or filter by `user.type == "Bot"` and look for Copilot-related names. The exact login may vary by organization.

If no Copilot reviews found, report "No Copilot review comments found on this PR" and stop.

## Step 3: Present Summary

Show a summary table with all comments before diving into details:

```
## Copilot Review Summary

PR: #123 - "Add user authentication"
Reviews: 2 (CHANGES_REQUESTED, COMMENTED)
Total inline comments: 5

| # | File            | Line | Preview                        |
|---|-----------------|------|--------------------------------|
| 1 | src/auth.ts     | 42   | "Consider sanitizing input..." |
| 2 | src/auth.ts     | 78   | "Potential null reference..."  |
| 3 | src/utils.ts    | 15   | "Unused import..."             |
| 4 | src/db.ts       | 101  | "Consider using batch..."      |
| 5 | src/db.ts       | 130  | "Missing error handling..."    |
```

## Step 4: Iterate Through Each Comment

For each comment, present three things:

### 4a. Show the Comment

Display:
- File path and line number
- The diff hunk (code context)
- Copilot's full comment text

### 4b. Assess the Comment

Evaluate technically:
- **Does this make sense?** Is it a valid concern or a false positive?
- **What is the specific fix?** State it concretely (e.g., "remove the unused import `lodash`", "add a null check before accessing `user.email`", "wrap the database call in a try/catch")
- **Severity:** Critical (must fix), Recommended (should fix), Optional (nice-to-have)

Be honest. If Copilot is wrong, say so and explain why.

### 4c. Ask the User

Ask the user what to do using the question tool with these options:
- **Fix it** — apply the proposed fix
- **Skip** — ignore this comment
- **Discuss** — user wants to talk about it before deciding

Collect all decisions before making any changes.

## Step 5: Apply Fixes

After all comments have been reviewed:
- Read each affected file
- Apply approved fixes using the Edit tool
- Show what changed for each fix

**Do NOT modify files during iteration.** Wait until all decisions are collected.

## Step 6: Commit and Push

```bash
# Stage modified files
git add <files>

# Commit - check recent commit history for conventions first
git log --oneline -5

# Commit with descriptive message
git commit -m "fix: address Copilot review feedback"

# Push
git push
```

Follow existing commit message conventions from the repository.

## Step 7: Report Results

Present a final summary:

```
## Results

Fixed: 3 comments
Skipped: 2 comments

Changes pushed to branch feature/auth (PR #123)

| # | File         | Line | Action  | Fix Applied                    |
|---|--------------|------|---------|--------------------------------|
| 1 | src/auth.ts  | 42   | Fixed   | Added input sanitization       |
| 2 | src/auth.ts  | 78   | Fixed   | Added null check               |
| 3 | src/utils.ts | 15   | Fixed   | Removed unused import          |
| 4 | src/db.ts    | 101  | Skipped | —                              |
| 5 | src/db.ts    | 130  | Skipped | —                              |
```

Ask the user if they want to re-request review from Copilot. Note that pushing new commits may auto-trigger a new review depending on repo settings.

## Error Handling

| Scenario | Action |
|----------|--------|
| No PR on current branch | Ask user for PR number/URL |
| No Copilot reviews found | Report and stop |
| `gh` not authenticated | Tell user to run `gh auth login` |
| `copilot` login not found | Try `copilot[bot]`, filter by `user.type == "Bot"` |
| API rate limiting | Report error, suggest waiting |

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Blindly fixing every suggestion | Evaluate each technically first |
| Vague fix descriptions | State the exact change (e.g., "remove unused variable `x`") |
| Editing files during iteration | Collect all decisions first, then batch-apply |
| One commit per fix | Batch all fixes into a single commit |
| Skipping the summary | Always show the summary table first |
| Not checking commit conventions | Run `git log --oneline -5` before committing |

## Integration

- **REQUIRED BACKGROUND:** `using-github-cli` for `gh` API command reference
- **RELATED:** `receiving-code-review` for the mindset of critically evaluating feedback — don't blindly agree with bot suggestions
