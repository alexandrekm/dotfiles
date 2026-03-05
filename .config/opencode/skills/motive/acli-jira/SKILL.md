---
name: acli-jira
description: Use when interacting with Jira via the acli CLI - searching, viewing, creating, editing, or transitioning work items, managing sprints and boards, or querying project information
---

# acli-jira

## Overview

Reference guide for the Atlassian CLI (`acli`) Jira commands. Requires `acli` to be installed and authenticated (`acli auth login`).

Check auth status: `acli auth status`

## When to Use

- User asks about Jira tickets, issues, or work items
- Need to search, create, view, edit, or transition Jira work items
- Managing sprints, boards, or projects
- Adding comments, assigning work, or linking issues
- Querying Jira data for context during development

## Output Formats

All commands support output format flags:

| Flag | Use case |
|------|----------|
| `--json` | Programmatic processing, structured data extraction |
| `--csv` | Tabular output (where supported) |
| (none) | Human-readable plain text (default) |

Always prefer `--json` when you need to parse or process results.

## Common Operations

| Operation | Command | Key Flags |
|-----------|---------|-----------|
| Search work items | `acli jira workitem search` | `--jql "..."`, `--fields`, `--json`, `--limit`, `--paginate` |
| View work item | `acli jira workitem view KEY-123` | `--fields`, `--json`, `--web` |
| Create work item | `acli jira workitem create` | `--summary`, `--project`, `--type`, `--assignee`, `--description`, `--label`, `--parent` |
| Edit work item | `acli jira workitem edit` | `--key`, `--summary`, `--description`, `--assignee`, `--type`, `--labels`, `--yes` |
| Transition work item | `acli jira workitem transition` | `--key`, `--status`, `--yes` |
| Assign work item | `acli jira workitem assign` | `--key`, `--assignee` (`@me` for self) |
| Add comment | `acli jira workitem comment create` | `--key`, `--body` |
| List boards | `acli jira board search` | `--project`, `--type`, `--json` |
| List sprints | `acli jira board list-sprints` | `--id` (board ID), `--state`, `--json` |
| Sprint work items | `acli jira sprint list-workitems` | `--sprint`, `--board`, `--json` |
| List projects | `acli jira project list` | `--json` |

## Quick Examples

Search for my open issues:

```bash
acli jira workitem search --jql "assignee = currentUser() AND status != Done" --json
```

Create a task:

```bash
acli jira workitem create --summary "Fix login bug" --project "TEAM" --type "Task" --assignee "@me"
```

Move ticket to In Progress:

```bash
acli jira workitem transition --key "TEAM-123" --status "In Progress" --yes
```

View ticket details:

```bash
acli jira workitem view TEAM-123 --fields "*all" --json
```

Add a comment:

```bash
acli jira workitem comment create --key "TEAM-123" --body "Fixed in commit abc123"
```

Search a board's active sprints:

```bash
acli jira board list-sprints --id 5 --state active --json
```

## Key Tips

- Use `@me` for self-assignment, `default` for project default assignee
- Use `--yes` to skip confirmation prompts (important for non-interactive use from agents)
- Use `--paginate` to fetch all results beyond the default limit
- Use `--fields` to customize which fields are returned
- Use `--jql` for JQL queries; `--filter` for saved filter IDs
- Use `--ignore-errors` when operating on multiple items to continue past failures
- Bulk targeting: many commands accept `--key` (comma-separated), `--jql`, or `--filter` to operate on multiple items
- `acli jira <command> --help` is always available for detailed flag information

## Full Reference

See `acli-jira-reference.md` in this skill directory for the complete command reference covering all subcommands and flags.
