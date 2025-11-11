# Subagent Hooks Test Setup

## What's Configured

Three hooks are active in this repo to test subagent behavior:

### 1. PreToolUse on Task (pretooluse-task-logger.sh)
**Triggers**: Before spawning any Task subagent (Explore, Plan, general-purpose, etc.)
**Behavior**: Logs the subagent type and notifies that Task tool is about to execute
**Purpose**: Confirms PreToolUse hooks fire when main Claude spawns subagents

### 2. PostToolUse on Write|Edit (posttooluse-file-tracker.sh)
**Triggers**: After any Write or Edit tool completes
**Behavior**: Logs which file was modified and by which tool
**Purpose**: Tests if hooks fire for subagent file operations (or just main agent)

### 3. SubagentStop (subagent-stop-validator.sh)
**Triggers**: When any Task subagent finishes responding
**Behavior**: Validates subagent output (currently just logs, doesn't block)
**Purpose**: Tests the SubagentStop event - does it actually fire?

## How to Test

**IMPORTANT**: Start a NEW Claude Code session in this repo for hooks to load.

### Test Sequence

1. **Ask Claude to use a Task subagent:**
   - "Use the Explore agent to find all markdown files in this repo"
   - "Use the Plan agent to create a plan for refactoring"
   - "Launch a general-purpose agent to search for TODO comments"

2. **Watch for hook feedback:**
   - Look for "=== TASK TOOL HOOK TRIGGERED ===" when spawning
   - Look for "=== SUBAGENT STOP HOOK TRIGGERED ===" when subagent finishes
   - Look for "=== FILE MODIFICATION DETECTED ===" if files are changed

3. **Ask Claude to modify files directly (not via subagent):**
   - "Create a test file called test.txt"
   - Check if PostToolUse hook triggers for main Claude's file operations

### Questions to Answer

- ✓/✗ Does PreToolUse fire when spawning subagents?
- ✓/✗ Does SubagentStop fire when subagents finish?
- ✓/✗ Does PostToolUse fire for subagent file operations?
- ✓/✗ Does PostToolUse fire for main agent file operations?
- ✓/✗ Can SubagentStop block and force respawning?
- ✓/✗ Do hooks see different context for main vs subagent?

## Expected Behavior

**Scenario 1: Main Claude creates file**
```
User: Create test.txt
Claude: *uses Write tool*
Hook: "=== FILE MODIFICATION DETECTED === Tool: Write, File: test.txt"
```

**Scenario 2: Spawn Explore subagent**
```
User: Use Explore agent to find markdown files
Claude: *about to use Task tool*
Hook: "=== TASK TOOL HOOK TRIGGERED === About to spawn subagent of type: Explore"
Claude: *spawns Explore subagent*
Subagent: *does its work*
Hook: "=== SUBAGENT STOP HOOK TRIGGERED === A Task subagent has finished"
```

**Scenario 3: Subagent modifies files (if capable)**
```
Subagent: *uses Write/Edit tool*
Hook: "=== FILE MODIFICATION DETECTED ===" (proves hooks apply to subagents)
```

## Advanced Test: Blocking SubagentStop

To test if SubagentStop can block and force respawning, modify `subagent-stop-validator.sh`:

Change the exit from `exit 0` to:
```bash
echo "Subagent output insufficient. Search more locations." >&2
exit 2  # Block with feedback
```

This should force main Claude to address the feedback and potentially spawn another subagent.

## Notes

- These hooks won't affect THIS session (hooks load at startup)
- All hooks currently just log and allow operations (exit 0)
- Hooks can be made blocking by changing to exit 2
- Hook scripts are in `.claude/` directory
- Configuration is in `.claude/settings.json`

## Cleanup

To remove hooks, delete `.claude/settings.json` or the entire `.claude/` directory before starting a new session.
