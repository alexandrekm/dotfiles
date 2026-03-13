# OPNsense Endpoint Tiers

## Default Scope

Phase 1 supports these areas first:

- System status and service status
- Interface and gateway/routing inspection
- Firewall alias and rule inspection
- VPN status for OpenVPN, WireGuard, and IPsec
- DNS/service status for Unbound and Dnsmasq

Use these environment variables for auth and transport:

- `OPNSENSE_BASE_URL`
- `OPNSENSE_API_KEY`
- `OPNSENSE_API_SECRET`
- `OPNSENSE_CA_CERT` (optional)
- `OPNSENSE_INSECURE=1` only for local testing

## Request Shape

- Base path: `/api/<module>/<controller>/<command>/<param...>`
- Auth: HTTP Basic Auth with API key as username and API secret as password
- `GET` usually reads data
- `POST` usually changes state or executes an action
- Do not trust the verb alone; some `GET` endpoints still trigger actions

## Safety Tiers

### Tier 1: Read-only

These usually run without confirmation.

- `get`
- `search`
- `status`
- `overview`
- `list`
- `export`

Examples:

- `GET /api/core/system/status`
- `GET /api/core/service/search`
- `GET /api/interfaces/overview/interfaces_info`
- `GET /api/routes/gateway/status`
- `GET /api/openvpn/service/search_sessions`
- `GET /api/unbound/service/status`

### Tier 2: Guarded write

These always require explicit user confirmation before execution.

- `add`
- `set`
- `del`
- `toggle`
- `reconfigure`
- `restart`
- `start`
- `stop`
- `apply`

Examples:

- `POST /api/firewall/filter/add_rule`
- `POST /api/firewall/filter/set_rule/<uuid>`
- `POST /api/interfaces/settings/set`
- `POST /api/routes/routes/addroute`
- `POST /api/openvpn/service/reconfigure`
- `POST /api/unbound/service/restart`

### Tier 3: High-risk

These require explicit confirmation with impact summary. Recommend manual execution when lockout or outage risk is high.

- Reboot or halt
- Firmware update or upgrade
- Firewall apply or revert
- Interface reload or reconfigure on active management interfaces
- Restart of DNS, VPN, routing, or filtering services with user traffic impact

Examples:

- `POST /api/core/system/reboot`
- `POST /api/core/firmware/update`
- `POST /api/firewall/filter/apply/<revision>`
- `GET /api/interfaces/overview/reload_interface/<id>`

## Required Workflow

For any Tier 2 or Tier 3 call:

1. Read the current state first.
2. Summarize the intended change and likely impact.
3. Ask for explicit confirmation.
4. Execute the smallest possible change.
5. Verify status after the change.

## Discovery Guidance

When docs are unclear, inspect the OPNsense Web UI network requests for `/api/` calls. The browser network tab is the most reliable source for required JSON payloads and controller names.

## Baseline Failures This Reference Fixes

Without a dedicated skill, baseline agents tended to:

- ask for credentials correctly
- plan state-changing calls without asking for confirmation
- treat service restarts and firewall apply as ordinary follow-up steps

This reference exists to force a read-first, confirm-before-mutate workflow.
