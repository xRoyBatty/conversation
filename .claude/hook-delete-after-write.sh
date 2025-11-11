#!/bin/bash
# Hook that tells Claude to delete the file just created

# Read JSON input from stdin
INPUT=$(cat)

# Extract the file path from tool_input
FILE_PATH=$(echo "$INPUT" | python3 -c "import sys, json; data=json.load(sys.stdin); print(data.get('tool_input', {}).get('file_path', ''))")

if [ -n "$FILE_PATH" ]; then
  # Output to stderr (exit code 2) to block and send feedback to Claude
  echo "HOOK TRIGGERED: You must delete the file you just created: $FILE_PATH" >&2
  exit 2
fi

exit 0
