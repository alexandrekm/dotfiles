---
name: opnsense-shared
description: Use when inspecting or modifying an OPNsense router over its API, especially when deciding whether a request is read-only, state-changing, or high-risk.
---

# OPNsense Shared Reference

## Overview

Use this skill when an OpenCode task needs to talk to an OPNsense router. Core principle: read first, classify the endpoint, and never execute state-changing API calls without explicit user confirmation.

## When to Use

- Router status, gateway status, VPN status, service status
- Firewall, interface, route, DNS, or VPN configuration changes
- Any request involving `/api/<module>/<controller>/<command>` on OPNsense
- Cases where `GET` might still hide an action-like endpoint

Do not use this skill for pfSense, generic routers, or raw shell/network tasks unrelated to OPNsense.

## Required Inputs

- `OPNSENSE_BASE_URL`
- `OPNSENSE_API_KEY`
- `OPNSENSE_API_SECRET`
- `OPNSENSE_CA_CERT` when using a private CA

Never print secrets. Prefer a CA bundle over insecure TLS. Only use `OPNSENSE_INSECURE=1` for local testing.

## Core Safety Rule

Classify every endpoint before calling it.

- Tier 1 `read-only`: proceed without confirmation
- Tier 2 `guarded write`: ask for explicit confirmation first
- Tier 3 `high-risk`: ask for explicit confirmation with outage or lockout impact

Do not classify by HTTP verb alone. Treat action-like names such as `reload`, `apply`, `restart`, `reconfigure`, and `toggle` as mutating even if the docs show `GET`.

See `endpoint-tiers.md` for the starter allowlist, examples, and default scope.

## Workflow

### Read-only request

1. Confirm auth/config exists or ask for the missing location.
2. Use a status, overview, get, or search endpoint.
3. Return the relevant result in a compact summary.

### State-changing request

1. Read current state first.
2. Summarize the exact change you plan to make.
3. State the likely impact.
4. Ask for explicit confirmation.
5. Execute the smallest possible mutation.
6. Verify status after the change.

### High-risk request

1. Read current state first.
2. Warn about outage, lockout, restart, or upgrade risk.
3. Ask for explicit confirmation.
4. Prefer manual execution guidance if the blast radius is large.

## Quick Reference

| Intent | Endpoint clues | Policy |
|---|---|---|
| Inspect | `get`, `search`, `status`, `overview`, `list` | Run |
| Change config | `add`, `set`, `del`, `toggle` | Ask first |
| Activate change | `apply`, `reconfigure`, `restart` | Ask first |
| Disruptive action | `reboot`, `update`, interface reload | Ask first with stronger warning |

## Example

User: "Add a firewall alias named `app-prod` with two hosts."

Good response pattern:

1. Read or inspect the current alias state if possible.
2. Say: "This is a state-changing firewall update. I plan to add alias `app-prod` with hosts `10.0.1.10` and `10.0.1.11`, then verify the saved config. Confirm and I'll execute it."
3. Only after confirmation, send the API request and report the result.

## Common Mistakes

| Mistake | Fix |
|---|---|
| Asking only for credentials, then planning to mutate immediately | Ask for confirmation after summarizing the change |
| Assuming all `GET` calls are safe | Inspect the command semantics, not just the verb |
| Applying firewall changes as a routine follow-up | Treat apply/reload/reconfigure as high-risk or guarded write |
| Printing key or secret values for debugging | Never echo secrets |

## Rationalizations

| Excuse | Reality |
|---|---|
| "I only need credentials, then I can apply it" | Credentials are not confirmation for a mutation |
| "Restarting a service is just operational" | It changes live state and can interrupt traffic |
| "Docs say GET, so it's safe" | OPNsense has action-like GET endpoints |

## Red Flags

- Planning `add`, `set`, `del`, `restart`, `apply`, or `reconfigure` before asking
- Treating firewall apply as a harmless verification step
- Using raw ad-hoc `curl` when a narrower helper or known workflow exists
- Echoing credentials or full auth headers

If any red flag appears, stop and switch back to read-first plus explicit confirmation.
