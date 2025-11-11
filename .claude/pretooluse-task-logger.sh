#!/bin/bash
# Hook that logs when Task tool is about to be used (spawning subagent)

# Set up log file
LOG_FILE="${CLAUDE_PROJECT_DIR:-.}/.claude/pretooluse-task.log"

# Read JSON input
INPUT=$(cat)

# Extract tool name to verify it's Task
TOOL=$(echo "$INPUT" | python3 -c "import sys, json; data=json.load(sys.stdin); print(data.get('tool_name', ''))" 2>/dev/null)

if [ "$TOOL" != "Task" ]; then
  exit 0
fi

# Extract the subagent type and prompt
TOOL_INPUT=$(echo "$INPUT" | python3 -c "import sys, json; data=json.load(sys.stdin); print(data.get('tool_input', {}))" 2>/dev/null)
SUBAGENT_TYPE=$(echo "$INPUT" | python3 -c "import sys, json; data=json.load(sys.stdin); print(data.get('tool_input', {}).get('subagent_type', 'unknown'))" 2>/dev/null)

# Log to file with timestamp
echo "==================================================" >> "$LOG_FILE"
echo "TIMESTAMP: $(date -u '+%Y-%m-%d %H:%M:%S UTC')" >> "$LOG_FILE"
echo "EVENT: PreToolUse - Task tool about to spawn subagent" >> "$LOG_FILE"
echo "SUBAGENT_TYPE: $SUBAGENT_TYPE" >> "$LOG_FILE"
echo "==================================================" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

# Log to stderr so Claude sees it (won't show in web, but maintains compatibility)
echo "=== TASK TOOL HOOK TRIGGERED ===" >&2
echo "About to spawn subagent of type: $SUBAGENT_TYPE" >&2
echo "This hook could validate or modify the Task parameters before spawning." >&2
echo "=== END TASK TOOL HOOK ===" >&2

# Allow the subagent to spawn
exit 0
