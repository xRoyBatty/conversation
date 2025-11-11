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

## Hooks System Understanding

### Hooks vs Instructions (CLAUDE.md)
- **Hooks**: Shell commands that execute at trigger moments (event-driven)
- **Instructions**: Static text always in context that Claude interprets
- **Key Difference**: Hooks = automated enforcement; Instructions = guidelines to follow

### Hook Characteristics (CONFIRMED via testing)
- Not intelligent - just scripts that run
- Output appears as if from user
- Can block Claude's actions
- **Trigger on system events**, not on Claude's statements
- Execute at response lifecycle moments (not mid-response)

### Confirmed Hook Events
1. **stop-hook** (tested: `~/.claude/stop-hook-git-check.sh`)
   - Triggers: When Claude's response completes
   - Timing: AFTER entire response, not mid-response
   - Use case: Enforce repo cleanliness (commit untracked files)

2. **user-prompt-submit-hook** (mentioned in instructions, not tested)
   - Triggers: When user submits a message
   - Timing: Before Claude sees the message

### Deterministic Hook Behavior (Tested)
- Creating files + continuing conversation = hook waits
- Response completion (regardless of what Claude says) = hook triggers
- Hook execution is independent of Claude's awareness or intent

### Speculative Hook Types (NOT CONFIRMED)
These would be useful but we don't know if they exist:
- before-commit-hook
- before-edit-hook / before-write-hook
- after-tool-call-hook
- on-error-hook

### Hook Examples That Would Require Specific Events
1. Pre-commit quality gates → needs before-commit or before-push hook
2. Security scanners → needs before-commit hook
3. Type checking enforcement → needs before-edit/write hook
4. Test coverage requirements → needs before-commit hook
5. Documentation sync reminders → needs before-commit hook

## Open Questions
- Do hooks apply to Task subagents?
- What hook events are available beyond stop-hook and user-prompt-submit-hook?
- Can hooks be scoped to specific operations or tool calls?
- Are there hooks for individual tool calls (Edit, Write, Bash, etc.)?

## Promo Details
- **Period**: Nov 4-18, 2025
- **Credits**: $250 (Pro), $1000 (Max)
- **Expiration**: Nov 18, 11:59 PM PT
- **Usage**: Web and mobile only
