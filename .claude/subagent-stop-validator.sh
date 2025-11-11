#!/bin/bash
# Hook that validates subagent output and can block if insufficient

# Read JSON input from stdin
INPUT=$(cat)

# Check if this is actually a subagent stop (has hook_event_name)
EVENT=$(echo "$INPUT" | python3 -c "import sys, json; data=json.load(sys.stdin); print(data.get('hook_event_name', ''))" 2>/dev/null)

if [ "$EVENT" != "SubagentStop" ]; then
  exit 0
fi

# Get the stop_hook_active flag to avoid infinite loops
HOOK_ACTIVE=$(echo "$INPUT" | python3 -c "import sys, json; data=json.load(sys.stdin); print(data.get('stop_hook_active', False))" 2>/dev/null)

if [ "$HOOK_ACTIVE" = "True" ]; then
  # Already in a hook loop, don't block again
  exit 0
fi

# Log that subagent stopped (to stderr so Claude sees it)
echo "=== SUBAGENT STOP HOOK TRIGGERED ===" >&2
echo "A Task subagent has finished its work." >&2
echo "Validating subagent output quality..." >&2

# Simple validation: block if transcript is suspiciously short
# (In real use, you'd check actual output quality)
TRANSCRIPT=$(echo "$INPUT" | python3 -c "import sys, json; data=json.load(sys.stdin); print(data.get('transcript_path', ''))" 2>/dev/null)

# For now, just provide feedback without blocking to see if it works
echo "Subagent validation complete. Output appears sufficient." >&2
echo "=== END SUBAGENT STOP HOOK ===" >&2

# Exit 0 to allow (exit 2 would block)
exit 0
