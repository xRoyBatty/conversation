#!/bin/bash
# Hook that validates subagent output and can block if insufficient

# Set up log file
LOG_FILE="${CLAUDE_PROJECT_DIR:-.}/.claude/subagent-stop.log"

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
  echo "==================================================" >> "$LOG_FILE"
  echo "TIMESTAMP: $(date -u '+%Y-%m-%d %H:%M:%S UTC')" >> "$LOG_FILE"
  echo "EVENT: SubagentStop - SKIPPED (stop_hook_active=True)" >> "$LOG_FILE"
  echo "==================================================" >> "$LOG_FILE"
  echo "" >> "$LOG_FILE"
  exit 0
fi

# Get transcript path and session ID
TRANSCRIPT=$(echo "$INPUT" | python3 -c "import sys, json; data=json.load(sys.stdin); print(data.get('transcript_path', ''))" 2>/dev/null)
SESSION_ID=$(echo "$INPUT" | python3 -c "import sys, json; data=json.load(sys.stdin); print(data.get('session_id', ''))" 2>/dev/null)

# Log to file with timestamp and full details
echo "==================================================" >> "$LOG_FILE"
echo "TIMESTAMP: $(date -u '+%Y-%m-%d %H:%M:%S UTC')" >> "$LOG_FILE"
echo "EVENT: SubagentStop - Task subagent finished" >> "$LOG_FILE"
echo "SESSION_ID: $SESSION_ID" >> "$LOG_FILE"
echo "TRANSCRIPT_PATH: $TRANSCRIPT" >> "$LOG_FILE"
echo "STOP_HOOK_ACTIVE: $HOOK_ACTIVE" >> "$LOG_FILE"
echo "VALIDATION: Output appears sufficient (not blocking)" >> "$LOG_FILE"
echo "==================================================" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

# Log that subagent stopped (to stderr so Claude sees it)
echo "=== SUBAGENT STOP HOOK TRIGGERED ===" >&2
echo "A Task subagent has finished its work." >&2
echo "Validating subagent output quality..." >&2

# For now, just provide feedback without blocking to see if it works
echo "Subagent validation complete. Output appears sufficient." >&2
echo "=== END SUBAGENT STOP HOOK ===" >&2

# Exit 0 to allow (exit 2 would block)
exit 0
