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

### Hook Characteristics
- Not intelligent - just scripts that run
- Output appears as if from user
- Can block Claude's actions
- Event-triggered (e.g., user-prompt-submit-hook)

### Hook Examples for Repo Control
1. Pre-commit quality gates (linters, tests)
2. Security scanners (detect secrets)
3. Type checking enforcement
4. Test coverage requirements
5. Documentation sync reminders

## Open Questions
- Do hooks apply to Task subagents?
- What hook events are available besides user-prompt-submit?
- Can hooks be scoped to specific operations?

## Promo Details
- **Period**: Nov 4-18, 2025
- **Credits**: $250 (Pro), $1000 (Max)
- **Expiration**: Nov 18, 11:59 PM PT
- **Usage**: Web and mobile only
