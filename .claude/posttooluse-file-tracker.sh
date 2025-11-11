#!/bin/bash
# Hook that tracks when subagents use Write/Edit tools

# Set up log file
LOG_FILE="${CLAUDE_PROJECT_DIR:-.}/.claude/posttooluse-files.log"

# Read JSON input
INPUT=$(cat)

TOOL=$(echo "$INPUT" | python3 -c "import sys, json; data=json.load(sys.stdin); print(data.get('tool_name', ''))" 2>/dev/null)

if [ "$TOOL" = "Write" ] || [ "$TOOL" = "Edit" ]; then
  FILE_PATH=$(echo "$INPUT" | python3 -c "import sys, json; data=json.load(sys.stdin); print(data.get('tool_input', {}).get('file_path', 'unknown'))" 2>/dev/null)

  # Log to file with timestamp
  echo "==================================================" >> "$LOG_FILE"
  echo "TIMESTAMP: $(date -u '+%Y-%m-%d %H:%M:%S UTC')" >> "$LOG_FILE"
  echo "EVENT: PostToolUse - File modification detected" >> "$LOG_FILE"
  echo "TOOL: $TOOL" >> "$LOG_FILE"
  echo "FILE_PATH: $FILE_PATH" >> "$LOG_FILE"
  echo "==================================================" >> "$LOG_FILE"
  echo "" >> "$LOG_FILE"

  # Log to stderr so Claude sees it (won't show in web, but maintains compatibility)
  echo "=== FILE MODIFICATION DETECTED ===" >&2
  echo "Tool: $TOOL" >&2
  echo "File: $FILE_PATH" >&2
  echo "This could be from main Claude or a subagent." >&2
  echo "=== END FILE MODIFICATION HOOK ===" >&2
fi

exit 0
