#!/bin/bash
# Hook that ends session when file deletion is detected

# Read JSON input from stdin
INPUT=$(cat)

# Extract the bash command
COMMAND=$(echo "$INPUT" | python3 -c "import sys, json; data=json.load(sys.stdin); print(data.get('tool_input', {}).get('command', ''))")

# Check if this is an rm command (file deletion)
if echo "$COMMAND" | grep -qE '^\s*rm\s+'; then
  # Output JSON to stop Claude entirely
  cat <<'EOF'
{
  "continue": false,
  "stopReason": "HOOK TRIGGERED: File deletion detected. Session ended by hook.",
  "systemMessage": "A hook detected file deletion and terminated the session."
}
EOF
  exit 0
fi

# Not a delete command, allow it
exit 0
