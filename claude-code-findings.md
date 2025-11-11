# Claude Code on the Web - Capabilities Summary

**Date**: November 11, 2025
**Environment**: Claude Code Web (Promo Period)
**Session Branch**: `claude/system-prompt-tools-011CV18XTCueKM6RQe6VpYJm`

## Key Environment Differences

### Claude Code Web vs CLI
1. **Execution Context**: Web operates in isolated sandboxed repo branch; CLI works in local terminal
2. **Usage Limits**: Web uses credit-based billing ($250 for Pro); CLI uses standard Pro message limits + 5-hour timeout
3. **Context Window**: Both share 200k token limit

## Tools Available

### File Operations
- Read, Edit, Write, Glob, Grep, NotebookEdit

### Execution
- Bash (with background support), BashOutput, KillShell

### Specialized Agents
- Task tool with subagents: Explore, Plan, general-purpose, statusline-setup

### Web Access
- WebSearch, WebFetch

### Project Management
- TodoWrite (task tracking)
- Skill system (only `session-start-hook` available)
- SlashCommand (custom commands from `.claude/commands/`)

## Hooks System (Official Documentation Summary)

### Hooks vs Instructions (CLAUDE.md)
- **Hooks**: Shell commands or LLM prompts that execute at trigger moments (event-driven)
- **Instructions**: Static text always in context that Claude interprets
- **Key Difference**: Hooks = automated enforcement; Instructions = guidelines to follow

### Hook Characteristics (CONFIRMED)
- Two types: **"command"** (bash scripts) and **"prompt"** (LLM-based evaluation with Haiku)
- Trigger on **system events**, not on Claude's statements
- Can **block, approve, or modify** Claude's actions
- Execute in **parallel** (all matching hooks run simultaneously)
- **60-second timeout** per hook (configurable)
- Output via **exit codes** (simple) or **JSON** (advanced control)

### All 9 Hook Events (Complete Reference)

#### 1. PreToolUse
**When**: Before tool execution (after Claude creates parameters)
**Matchers**: Tool names - `Bash`, `Edit`, `Write`, `Read`, `Grep`, `Glob`, `Task`, `WebFetch`, etc.
**Use cases**: Permission control, input validation, type checking
**Blocking**: Exit code 2 or JSON `"permissionDecision": "deny"` blocks tool call

#### 2. PostToolUse
**When**: Immediately after tool completes successfully
**Matchers**: Same as PreToolUse
**Use cases**: Verify changes, run tests, validate outputs
**Blocking**: Exit code 2 or JSON `"decision": "block"` provides feedback to Claude

#### 3. UserPromptSubmit
**When**: When user submits a prompt, before Claude processes it
**Matchers**: None (always runs for all prompts)
**Use cases**: Add context, validate prompts, block sensitive requests
**Blocking**: Exit code 2 blocks prompt processing
**Special**: stdout with exit 0 gets added to context

#### 4. Stop
**When**: When Claude finishes responding (TESTED in this session)
**Matchers**: None
**Use cases**: Enforce repo cleanliness, verify task completion
**Blocking**: Exit code 2 or JSON `"decision": "block"` prevents Claude from stopping
**Our test**: `~/.claude/stop-hook-git-check.sh` enforces commits

#### 5. SubagentStop
**When**: When Task subagent (Explore, Plan, etc.) finishes
**Matchers**: None
**Use cases**: Validate subagent work, enforce quality gates
**Blocking**: Same as Stop hook

#### 6. Notification
**When**: System notifications are sent
**Matchers**: `permission_prompt`, `idle_prompt`, `auth_success`, `elicitation_dialog`
**Use cases**: Custom alerts, logging, external notifications
**Blocking**: Cannot block notifications

#### 7. SessionStart
**When**: Session starts or resumes
**Matchers**: `startup`, `resume`, `clear`, `compact`
**Use cases**: Install dependencies, load context, setup environment
**Special**: Has access to `CLAUDE_ENV_FILE` to persist environment variables
**Special**: stdout with exit 0 gets added to context

#### 8. SessionEnd
**When**: Session terminates
**Matchers**: None (reason field: `clear`, `logout`, `prompt_input_exit`, `other`)
**Use cases**: Cleanup, logging, save state
**Blocking**: Cannot block session end

#### 9. PreCompact
**When**: Before context window compaction
**Matchers**: `manual` (from /compact command), `auto` (automatic compaction)
**Use cases**: Save state before context cleanup
**Blocking**: Cannot block compaction

### Hook Configuration Structure

**Location**: `~/.claude/settings.json` or `.claude/settings.json` (project-level)

```json
{
  "hooks": {
    "EventName": [{
      "matcher": "ToolPattern",  // Regex supported: "Edit|Write", "Notebook.*", "*"
      "hooks": [{
        "type": "command",           // or "prompt" for LLM-based
        "command": "script.sh",      // for type: "command"
        "prompt": "Evaluate...",     // for type: "prompt"
        "timeout": 60                // optional, seconds
      }]
    }]
  }
}
```

### Exit Code Behavior

- **Exit 0**: Success (stdout shown in transcript for most hooks; added to context for UserPromptSubmit/SessionStart)
- **Exit 2**: Blocking error (stderr shown to Claude; prevents action)
- **Other codes**: Non-blocking error (stderr shown to user, execution continues)

### JSON Output Schema (Advanced Control)

**Common fields (all hooks)**:
```json
{
  "continue": false,              // Stop Claude entirely
  "stopReason": "Custom message", // Shown to user when continue=false
  "suppressOutput": true,         // Hide from transcript
  "systemMessage": "Warning text" // Optional message to user
}
```

**PreToolUse specific**:
```json
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "allow" | "deny" | "ask",
    "permissionDecisionReason": "Explanation",
    "updatedInput": {             // Modify tool parameters
      "field_name": "new_value"
    }
  }
}
```

**PostToolUse specific**:
```json
{
  "decision": "block" | undefined,
  "reason": "Feedback for Claude",
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "additionalContext": "Extra info for Claude"
  }
}
```

**Stop/SubagentStop specific**:
```json
{
  "decision": "block" | undefined,
  "reason": "Why Claude must continue"
}
```

**UserPromptSubmit specific**:
```json
{
  "decision": "block" | undefined,
  "reason": "Shown to user if blocked",
  "hookSpecificOutput": {
    "hookEventName": "UserPromptSubmit",
    "additionalContext": "Added to context if not blocked"
  }
}
```

**SessionStart specific**:
```json
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "Loaded into context"
  }
}
```

### Special Environment Variables

- **`$CLAUDE_PROJECT_DIR`**: Absolute path to project root (always available)
- **`$CLAUDE_ENV_FILE`**: Path to file for persisting env vars (SessionStart only)
- **`$CLAUDE_CODE_REMOTE`**: Set to `"true"` in web environment, unset/empty in CLI
- **`${CLAUDE_PLUGIN_ROOT}`**: Plugin directory path (plugin hooks only)

### MCP Tool Integration

MCP tools follow pattern: `mcp__<server>__<tool>`

Examples:
- `mcp__memory__create_entities`
- `mcp__filesystem__read_file`
- `mcp__github__search_repositories`

Match with regex: `"matcher": "mcp__memory__.*"` or `"matcher": "mcp__.*__write.*"`

### Practical Examples

**1. Detect web vs CLI environment:**
```bash
if [ "$CLAUDE_CODE_REMOTE" = "true" ]; then
  echo "Running in Claude Code Web"
else
  echo "Running in Claude Code CLI"
fi
```

**2. Auto-approve safe file reads:**
```json
{
  "PreToolUse": [{
    "matcher": "Read",
    "hooks": [{
      "type": "command",
      "command": "python check-safe-read.py"
    }]
  }]
}
```

**3. LLM-based Stop hook (intelligent completion check):**
```json
{
  "Stop": [{
    "hooks": [{
      "type": "prompt",
      "prompt": "Analyze if all tasks are complete: $ARGUMENTS. Return {\"decision\": \"approve\" or \"block\", \"reason\": \"explanation\"}"
    }]
  }]
}
```

**4. Persist environment in SessionStart:**
```bash
#!/bin/bash
if [ -n "$CLAUDE_ENV_FILE" ]; then
  echo 'export NODE_ENV=production' >> "$CLAUDE_ENV_FILE"
  echo 'export PATH="$PATH:./node_modules/.bin"' >> "$CLAUDE_ENV_FILE"
fi
```

**5. Validate bash commands before execution:**
```json
{
  "PreToolUse": [{
    "matcher": "Bash",
    "hooks": [{
      "type": "command",
      "command": "python validate-command.py",
      "timeout": 10
    }]
  }]
}
```

### Key Insights from Testing

✅ **Confirmed**: Stop hook triggers on response completion, not mid-response
✅ **Confirmed**: Hook execution is independent of Claude's awareness
✅ **Confirmed**: Creating files + continuing conversation = hook waits until response ends
✅ **Confirmed**: Matchers support full regex (Edit|Write works)
✅ **Confirmed**: Hooks can differentiate "uncommitted changes" vs "untracked files"

### Remaining Questions

- How do plugin hooks merge with user hooks in practice?
- What's the exact input JSON schema for each MCP tool type?
- Can prompt-based hooks be used with PreToolUse/PostToolUse effectively?
- How does hook deduplication work with identical commands from different sources?

## Promo Details
- **Period**: Nov 4-18, 2025
- **Credits**: $250 (Pro), $1000 (Max)
- **Expiration**: Nov 18, 11:59 PM PT
- **Usage**: Web and mobile only
