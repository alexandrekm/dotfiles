#!/usr/bin/env node
/**
 * command-guard.js — Claude Code PreToolUse hook
 *
 * Reads a JSON hook payload from stdin, normalizes the Bash command to strip
 * bypass prefixes, then matches the result against configurable glob-style
 * rules loaded from ~/.claude/command-guard.json.
 *
 * Outputs one of:
 *   {"permissionDecision": "allow"}
 *   {"permissionDecision": "ask",  "permissionDecisionReason": "..."}
 *   {"permissionDecision": "deny", "permissionDecisionReason": "..."}
 *
 * Rule precedence: deny > ask > allow (default when nothing matches).
 * Config errors / parse failures → silently allow.
 */

"use strict";

const fs   = require("fs");
const path = require("path");
const os   = require("os");

// ---------------------------------------------------------------------------
// Logging — appends structured JSON lines to ~/.claude/command-guard.log
// ---------------------------------------------------------------------------

const LOG_FILE = path.join(os.homedir(), ".claude", "command-guard.log");

function log(level, message, extra = {}) {
  try {
    const entry = JSON.stringify({
      ts:      new Date().toISOString(),
      level,
      message,
      ...extra,
    });
    fs.appendFileSync(LOG_FILE, entry + "\n");
  } catch (_) {
    // Logging must never crash the hook
  }
}

// ---------------------------------------------------------------------------
// Hardcoded fallback — used when config file is missing or malformed
// ---------------------------------------------------------------------------
const WATCH_LIST = ["ls", "rm *", "git *", "npm *", "sudo *"];

// ---------------------------------------------------------------------------
// Normalization — strip bypass prefixes until the command is stable
// ---------------------------------------------------------------------------

/**
 * Strip one layer of known bypass wrappers. Returns null when nothing changed.
 *
 * Patterns handled:
 *   cd <path> &&              e.g. cd /tmp &&
 *   sh -c "..."               (single or double quoted)
 *   bash -c "..."
 *   eval "..."
 */
function stripOnce(cmd) {
  let s = cmd.trim();

  // cd <path> &&  (path may be bare, single-quoted, or double-quoted)
  const cdRe = /^cd\s+(?:"[^"]*"|'[^']*'|\S+)\s*&&\s*/;
  if (cdRe.test(s)) {
    return s.replace(cdRe, "").trim();
  }

  // sh -c "..." / bash -c "..."
  const shellRe = /^(?:sh|bash)\s+-c\s+(?:"((?:[^"\\]|\\.)*)"|'((?:[^'\\]|\\.)*)')\s*$/;
  const shellM  = s.match(shellRe);
  if (shellM) {
    return (shellM[1] !== undefined ? shellM[1] : shellM[2]).trim();
  }

  // eval "..." / eval '...'
  const evalRe = /^eval\s+(?:"((?:[^"\\]|\\.)*)"|'((?:[^'\\]|\\.)*)')\s*$/;
  const evalM  = s.match(evalRe);
  if (evalM) {
    return (evalM[1] !== undefined ? evalM[1] : evalM[2]).trim();
  }

  return null; // no change
}

/**
 * Repeatedly strip bypass prefixes until no more apply (fixed-point).
 */
function normalize(cmd) {
  let current = cmd.trim();
  for (let i = 0; i < 20; i++) {       // cap iterations against pathological input
    const next = stripOnce(current);
    if (next === null) break;
    current = next;
  }
  return current;
}

// ---------------------------------------------------------------------------
// Flag-stripped skeleton
//
// Removes tokens that look like flags (-x, --foo, --foo=bar) and their
// flag-value arguments (-C /path, --work-tree /path) so that
//   git -C /repo commit --amend
// becomes
//   git commit --amend   →   skeleton: "git commit"
// allowing the pattern "git commit*" to match.
// ---------------------------------------------------------------------------

/**
 * Build a version of the command with pure-flag tokens removed.
 * We keep the first word (the binary) and any non-flag token.
 * Flag-value pairs (e.g. -C /path, --work-tree /path) consume the next token.
 */
function flagStripped(cmd) {
  // Tokenize naively on whitespace (sufficient for our matching purposes)
  const tokens  = cmd.trim().split(/\s+/);
  const out     = [];
  const flagValueRe = /^-[a-zA-Z]$/;    // single-char flags that typically take a value

  // Flags that are known to consume the next argument (conservative list)
  const flagsTakingValue = new Set([
    "-C", "-c", "-D", "-e", "-E", "-f", "-F", "-i", "-I", "-l",
    "-L", "-m", "-n", "-o", "-O", "-p", "-q", "-r", "-s", "-S",
    "-t", "-T", "-u", "-U", "-w", "-x"
  ]);

  for (let i = 0; i < tokens.length; i++) {
    const tok = tokens[i];
    if (i === 0) {
      out.push(tok);   // always keep the binary name
      continue;
    }
    if (/^--/.test(tok)) {
      // Long flag (--foo or --foo=bar): skip
      continue;
    }
    if (/^-[a-zA-Z]/.test(tok)) {
      // Short flag: if it's known to take a value, skip next token too
      if (flagsTakingValue.has(tok)) i++;
      continue;
    }
    out.push(tok);
  }

  return out.join(" ");
}

// ---------------------------------------------------------------------------
// Glob-style pattern matching
//
// Supports * as a wildcard matching any sequence (including spaces).
// Pattern is anchored at the start; a trailing * covers all arguments.
// ---------------------------------------------------------------------------

function patternToRegex(pattern) {
  // Escape regex special chars except *
  const escaped = pattern.replace(/[.+^${}()|[\]\\]/g, "\\$&");
  // * → .* (greedy, matches anything including spaces)
  const regexStr = "^" + escaped.replace(/\*/g, ".*");
  return new RegExp(regexStr, "i");
}

/**
 * Returns the matched pattern string if the command matches, otherwise null.
 * Tries both the full normalized command and the flag-stripped skeleton.
 */
function matchesPattern(pattern, normalizedCmd, skeleton) {
  const re = patternToRegex(pattern.trim());
  return re.test(normalizedCmd) || re.test(skeleton) ? pattern : null;
}

// ---------------------------------------------------------------------------
// Config loading
// ---------------------------------------------------------------------------

function stripJsoncComments(str) {
  let inString = false, escaped = false, result = "";
  for (let i = 0; i < str.length; i++) {
    const c = str[i];
    if (escaped)          { escaped = false; result += c; continue; }
    if (c === "\\" && inString) { escaped = true; result += c; continue; }
    if (c === "\"")       { inString = !inString; result += c; continue; }
    if (!inString && c === "/" && str[i + 1] === "/") {
      while (i < str.length && str[i] !== "\n") i++;
      continue;
    }
    if (!inString && c === "/" && str[i + 1] === "*") {
      i += 2;
      while (i < str.length - 1 && !(str[i] === "*" && str[i + 1] === "/")) i++;
      i++;
      continue;
    }
    result += c;
  }
  return result;
}

function loadConfig() {
  const configPath = path.join(os.homedir(), ".claude", "command-guard.jsonc");
  try {
    const raw    = fs.readFileSync(configPath, "utf8");
    const parsed = JSON.parse(stripJsoncComments(raw));
    const rules  = parsed.rules || {};
    const config = {
      ask:  Array.isArray(rules.ask)  ? rules.ask  : [],
      deny: Array.isArray(rules.deny) ? rules.deny : [],
    };
    log("debug", "config loaded", { configPath, askCount: config.ask.length, denyCount: config.deny.length });
    return config;
  } catch (err) {
    // Missing or malformed config → fall back to WATCH_LIST
    log("warn", "config unavailable, using fallback WATCH_LIST", { configPath, error: err.message });    return { ask: WATCH_LIST, deny: [] };
  }
}

// ---------------------------------------------------------------------------
// Decision
// ---------------------------------------------------------------------------

function decide(normalizedCmd, config) {
  const skeleton = flagStripped(normalizedCmd);
  log("debug", "evaluating command", { normalized: normalizedCmd, skeleton });

  // Deny checked first (most restrictive)
  for (const pattern of config.deny) {
    if (matchesPattern(pattern, normalizedCmd, skeleton)) {
      const result = {
        permissionDecision:       "deny",
        permissionDecisionReason: `Custom Guard: '${normalizedCmd}' blocked by deny rule '${pattern}'.`,
      };
      log("info", "decision: deny", { normalized: normalizedCmd, matchedPattern: pattern });
      return result;
    }
  }

  // Ask checked second
  for (const pattern of config.ask) {
    if (matchesPattern(pattern, normalizedCmd, skeleton)) {
      const result = {
        permissionDecision:       "ask",
        permissionDecisionReason: `Custom Guard: '${normalizedCmd}' matched ask rule '${pattern}'.`,
      };
      log("info", "decision: ask", { normalized: normalizedCmd, matchedPattern: pattern });
      return result;
    }
  }

  // Default: allow
  log("info", "decision: allow", { normalized: normalizedCmd });
  return { permissionDecision: "allow" };
}

// ---------------------------------------------------------------------------
// Main
// ---------------------------------------------------------------------------

function main() {
  let raw = "";
  process.stdin.setEncoding("utf8");
  process.stdin.on("data", chunk => { raw += chunk; });
  process.stdin.on("end", () => {
    try {
      const payload = JSON.parse(raw);
      const command = (payload.tool_input && payload.tool_input.command) || "";

      log("debug", "hook invoked", { toolName: payload.tool_name, rawCommand: command });

      if (!command) {
        log("debug", "empty command, allowing");
        process.stdout.write(JSON.stringify({ hookSpecificOutput: { hookEventName: "PreToolUse", permissionDecision: "allow" } }) + "\n");
        return;
      }

      const normalized = normalize(command);
      if (normalized !== command.trim()) {
        log("debug", "command normalized", { original: command.trim(), normalized });
      }

      const config = loadConfig();
      const inner  = decide(normalized, config);

      // Claude Code requires permissionDecision nested inside hookSpecificOutput
      const result = inner.permissionDecision === "allow"
        ? { hookSpecificOutput: { hookEventName: "PreToolUse", permissionDecision: "allow" } }
        : { hookSpecificOutput: { hookEventName: "PreToolUse", ...inner } };

      process.stdout.write(JSON.stringify(result) + "\n");
    } catch (err) {
      log("error", "unhandled error, falling back to allow", { error: err.message, stack: err.stack });
      process.stdout.write(JSON.stringify({ hookSpecificOutput: { hookEventName: "PreToolUse", permissionDecision: "allow" } }) + "\n");
    }
  });
}

main();
