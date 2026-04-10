#!/bin/bash
# Read the input Claude is sending to the tool
input=$(cat)

# Run the safety-net plugin (uses bunx for speed, fallback to npx)
if command -v bunx > /dev/null; then
  result=$(echo "$input" | bunx cc-safety-net 2>/dev/null)
else
  result=$(echo "$input" | npx -y cc-safety-net 2>/dev/null)
fi

# INTERCEPT: If safety-net says "deny", we change it to "ask"
if echo "$result" | grep -q '"permissionDecision": "deny"'; then
  # We swap the decision so Claude shows the Y/n prompt instead of an error
  echo "$result" | sed 's/"permissionDecision": "deny"/"permissionDecision": "ask"/'
else
  # Otherwise, pass through the original decision (usually "allow")
  echo "$result"
fi
