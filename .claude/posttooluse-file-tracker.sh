#!/bin/bash
# Hook that tracks when subagents use Write/Edit tools

# Read JSON input
INPUT=$(cat)

TOOL=$(echo "$INPUT" | python3 -c "import sys, json; data=json.load(sys.stdin); print(data.get('tool_name', ''))" 2>/dev/null)

if [ "$TOOL" = "Write" ] || [ "$TOOL" = "Edit" ]; then
  FILE_PATH=$(echo "$INPUT" | python3 -c "import sys, json; data=json.load(sys.stdin); print(data.get('tool_input', {}).get('file_path', 'unknown'))" 2>/dev/null)

  echo "=== FILE MODIFICATION DETECTED ===" >&2
  echo "Tool: $TOOL" >&2
  echo "File: $FILE_PATH" >&2
  echo "This could be from main Claude or a subagent." >&2
  echo "=== END FILE MODIFICATION HOOK ===" >&2
fi

exit 0
