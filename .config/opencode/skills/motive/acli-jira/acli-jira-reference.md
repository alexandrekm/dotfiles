# acli Jira Command Reference

Full command reference for `acli jira`. Use `acli jira <command> --help` for the most up-to-date flag details.

**Common flags across commands:** `--json` (JSON output), `--csv` (CSV output, where supported), `--yes` (skip confirmation prompts), `--ignore-errors` (continue past failures on bulk operations).

**Bulk targeting:** Many write commands accept `--key` (comma-separated keys), `--jql` (JQL query), `--filter` (saved filter ID), or `--from-file` (file with IDs/keys) to target multiple items.

---

## Auth

| Command | Key Flags | Example |
|---------|-----------|---------|
| `acli auth login` | | `acli auth login` |
| `acli auth logout` | | `acli auth logout` |
| `acli auth status` | | `acli auth status` |
| `acli auth switch` | | `acli auth switch` |

---

## Work Items

| Command | Key Flags | Example |
|---------|-----------|---------|
| `acli jira workitem search` | `--jql`, `--fields` (default: issuetype,key,assignee,priority,status,summary), `--json`, `--csv`, `--limit`, `--paginate`, `--count`, `--filter`, `--web` | `acli jira workitem search --jql "project = TEAM AND status = 'In Progress'" --json` |
| `acli jira workitem view [key]` | `--fields` (default: key,issuetype,summary,status,assignee,description; use `*all` or `*navigable`), `--json`, `--web` | `acli jira workitem view TEAM-123 --fields "*all" --json` |
| `acli jira workitem create` | `--summary`, `--project`, `--type` (Epic/Story/Task/Bug), `--assignee` (`@me`/email/`default`), `--description`, `--description-file`, `--label`, `--parent`, `--editor`, `--from-file`, `--from-json`, `--generate-json`, `--json` | `acli jira workitem create --summary "Fix bug" --project "TEAM" --type "Task" --assignee "@me"` |
| `acli jira workitem create-bulk` | `--from-json`, `--from-csv`, `--generate-json`, `--ignore-errors`, `--yes` | `acli jira workitem create-bulk --from-csv issues.csv` |
| `acli jira workitem edit` | `--key`, `--jql`, `--filter`, `--summary`, `--description`, `--description-file`, `--assignee`, `--type`, `--labels`, `--remove-labels`, `--remove-assignee`, `--from-json`, `--generate-json`, `--json`, `--yes` | `acli jira workitem edit --key "TEAM-123" --summary "Updated title" --yes` |
| `acli jira workitem transition` | `--key`, `--jql`, `--filter`, `--status`, `--json`, `--ignore-errors`, `--yes` | `acli jira workitem transition --key "TEAM-123" --status "Done" --yes` |
| `acli jira workitem assign` | `--key`, `--jql`, `--filter`, `--from-file`, `--assignee` (`@me`/email/`default`), `--remove-assignee`, `--json`, `--ignore-errors`, `--yes` | `acli jira workitem assign --key "TEAM-123" --assignee "@me"` |
| `acli jira workitem clone` | `--key`, `--jql`, `--filter`, `--from-file`, `--to-project`, `--to-site`, `--json`, `--ignore-errors`, `--yes` | `acli jira workitem clone --key "TEAM-123" --to-project "OTHER"` |
| `acli jira workitem archive` | `--key`, `--jql`, `--filter`, `--from-file`, `--json`, `--ignore-errors`, `--yes` | `acli jira workitem archive --key "TEAM-123" --yes` |
| `acli jira workitem unarchive` | `--key`, `--from-file`, `--json`, `--ignore-errors`, `--yes` | `acli jira workitem unarchive --key "TEAM-123" --yes` |
| `acli jira workitem delete` | `--key`, `--jql`, `--filter`, `--from-file`, `--json`, `--ignore-errors`, `--yes` | `acli jira workitem delete --key "TEAM-123" --yes` |

---

## Work Item Comments

| Command | Key Flags | Example |
|---------|-----------|---------|
| `acli jira workitem comment create` | `--key`, `--jql`, `--filter`, `--body`, `--body-file`, `--editor`, `--edit-last`, `--json`, `--ignore-errors` | `acli jira workitem comment create --key "TEAM-123" --body "Fixed in abc123"` |
| `acli jira workitem comment list` | `--key`, `--json`, `--limit` (default 50), `--order` (+created/-created/+updated/-updated), `--paginate` | `acli jira workitem comment list --key "TEAM-123" --json` |
| `acli jira workitem comment update` | `--key`, `--id`, `--body`, `--body-file`, `--body-adf`, `--visibility-role`, `--visibility-group`, `--notify` | `acli jira workitem comment update --key "TEAM-123" --id 10001 --body "Updated text"` |
| `acli jira workitem comment delete` | `--key`, `--id` | `acli jira workitem comment delete --key "TEAM-123" --id 10001` |
| `acli jira workitem comment visibility` | `--role` (requires `--project`), `--group` | `acli jira workitem comment visibility --role --project TEAM` |

---

## Work Item Links

| Command | Key Flags | Example |
|---------|-----------|---------|
| `acli jira workitem link create` | `--out` (outward key), `--in` (inward key), `--type` (e.g. Blocks), `--from-json`, `--from-csv`, `--generate-json`, `--ignore-errors`, `--yes` | `acli jira workitem link create --out TEAM-123 --in TEAM-456 --type Blocks` |
| `acli jira workitem link list` | `--key`, `--json` | `acli jira workitem link list --key TEAM-123 --json` |
| `acli jira workitem link delete` | `--id`, `--from-json`, `--from-csv`, `--ignore-errors`, `--yes` | `acli jira workitem link delete --id 10001` |
| `acli jira workitem link type` | `--json` | `acli jira workitem link type --json` |

---

## Work Item Attachments

| Command | Key Flags | Example |
|---------|-----------|---------|
| `acli jira workitem attachment list` | `--key`, `--json` | `acli jira workitem attachment list --key TEAM-123 --json` |
| `acli jira workitem attachment delete` | `--id` | `acli jira workitem attachment delete --id 12345` |

---

## Work Item Watchers

| Command | Key Flags | Example |
|---------|-----------|---------|
| `acli jira workitem watcher list` | `--key`, `--json` | `acli jira workitem watcher list --key TEAM-123` |
| `acli jira workitem watcher remove` | `--key`, `--user` (account ID) | `acli jira workitem watcher remove --key TEAM-123 --user 5b10ac8d82e05b22cc7d4ef5` |

---

## Sprints

| Command | Key Flags | Example |
|---------|-----------|---------|
| `acli jira sprint create` | `--name`, `--board` (board ID, required), `--start`, `--end` (ISO 8601), `--goal`, `--json` | `acli jira sprint create --name "Sprint 1" --board 5 --start 2025-01-01 --end 2025-01-14` |
| `acli jira sprint view` | `--id`, `--json` | `acli jira sprint view --id 37 --json` |
| `acli jira sprint update` | `--id`, `--name`, `--goal`, `--start`, `--end`, `--state` (future/active/closed), `--complete-date`, `--board`, `--json` | `acli jira sprint update --id 37 --state closed` |
| `acli jira sprint delete` | `--id` (comma-separated), `--yes` | `acli jira sprint delete --id 37 --yes` |
| `acli jira sprint list-workitems` | `--sprint` (required), `--board` (required), `--fields`, `--jql`, `--json`, `--csv`, `--limit` (default 50), `--paginate` | `acli jira sprint list-workitems --sprint 37 --board 5 --json` |

---

## Boards

| Command | Key Flags | Example |
|---------|-----------|---------|
| `acli jira board search` | `--name`, `--project`, `--type` (scrum/kanban/simple), `--filter`, `--order-by` (name/-name/+name), `--limit` (default 50), `--paginate`, `--private`, `--json`, `--csv` | `acli jira board search --project "TEAM" --type scrum --json` |
| `acli jira board get` | `--id`, `--json` | `acli jira board get --id 5 --json` |
| `acli jira board create` | `--name`, `--type` (scrum/kanban), `--filter-id`, `--location-type` (project/user), `--project`, `--json` | `acli jira board create --name "Dev Board" --type scrum --filter-id 10040 --location-type project --project "TEAM"` |
| `acli jira board delete` | `--id` (comma-separated), `--yes` | `acli jira board delete --id 5 --yes` |
| `acli jira board list-sprints` | `--id` (board ID), `--state` (future/active/closed, comma-separated), `--limit` (default 50), `--paginate`, `--json`, `--csv` | `acli jira board list-sprints --id 5 --state active --json` |
| `acli jira board list-projects` | `--id` (board ID), `--limit` (default 50), `--paginate`, `--json`, `--csv` | `acli jira board list-projects --id 5 --json` |

---

## Projects

| Command | Key Flags | Example |
|---------|-----------|---------|
| `acli jira project list` | `--json`, `--limit` (default 30), `--paginate`, `--recent` (up to 20) | `acli jira project list --json` |
| `acli jira project view` | `--key`, `--json` | `acli jira project view --key "TEAM" --json` |
| `acli jira project create` | `--key`, `--name`, `--from-project` (clone from existing), `--description`, `--lead-email`, `--url`, `--from-json`, `--generate-json` | `acli jira project create --from-project "TEAM" --key "NEW" --name "New Project"` |
| `acli jira project update` | `--project-key`, `--key` (new key), `--name`, `--description`, `--lead-email`, `--url`, `--from-json`, `--generate-json` | `acli jira project update --project-key "TEAM" --name "Renamed"` |
| `acli jira project delete` | `--key` | `acli jira project delete --key "TEAM"` |
| `acli jira project archive` | `--key` | `acli jira project archive --key "TEAM"` |
| `acli jira project restore` | `--key` | `acli jira project restore --key "TEAM"` |

---

## Filters

| Command | Key Flags | Example |
|---------|-----------|---------|
| `acli jira filter search` | `--name`, `--owner` (email), `--limit` (default 30), `--paginate`, `--json`, `--csv` | `acli jira filter search --owner "user@example.com" --json` |
| `acli jira filter get` | `--id`, `--json`, `--web` | `acli jira filter get --id 10001 --json` |
| `acli jira filter list` | `--my`, `--favourite`, `--json` | `acli jira filter list --my --json` |
| `acli jira filter update` | `--id`, `--name`, `--description`, `--jql`, `--share-permissions`, `--edit-permissions`, `--json` | `acli jira filter update --id 10001 --name "Updated" --jql "project = TEAM"` |
| `acli jira filter add-favourite` | `--filter-id` | `acli jira filter add-favourite --filter-id 10001` |
| `acli jira filter get-columns` | `--id` | `acli jira filter get-columns --id 10001` |
| `acli jira filter reset-columns` | `--id` | `acli jira filter reset-columns --id 10001` |
| `acli jira filter change-owner` | `--id`, `--owner` | `acli jira filter change-owner --id 10001 --owner "user@example.com"` |

---

## Dashboards

| Command | Key Flags | Example |
|---------|-----------|---------|
| `acli jira dashboard search` | `--name`, `--owner` (email), `--limit` (default 30), `--paginate`, `--json`, `--csv` | `acli jira dashboard search --owner "user@example.com" --json` |

---

## Fields

| Command | Key Flags | Example |
|---------|-----------|---------|
| `acli jira field create` | `--name`, `--type`, `--description`, `--searcher-key`, `--json` | `acli jira field create --name "Customer" --type "com.atlassian.jira.plugin.system.customfieldtypes:textfield"` |
| `acli jira field delete` | `--id` | `acli jira field delete --id 10001` |
| `acli jira field cancel-delete` | `--id` | `acli jira field cancel-delete --id 10001` |
