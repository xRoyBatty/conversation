#!/bin/bash
# Hook that logs when Task tool is about to be used (spawning subagent)

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

# Log to stderr so Claude sees it
echo "=== TASK TOOL HOOK TRIGGERED ===" >&2
echo "About to spawn subagent of type: $SUBAGENT_TYPE" >&2
echo "This hook could validate or modify the Task parameters before spawning." >&2
echo "=== END TASK TOOL HOOK ===" >&2

# Allow the subagent to spawn
exit 0
