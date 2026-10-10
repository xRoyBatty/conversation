# Claude Code on the web: tested findings

First-hand observations from hook experiments in Claude Code web sessions (Nov 2025). Trimmed on 2026-10-04: the old summary of the official hooks docs, the tool list and the promo details were removed because they are out of date or duplicated in `CLAUDE.md`.

**Status**: tested in Nov 2025 (sessions `011CV18XTCueKM6RQe6VpYJm`, `c8531714-109b-4121-acba-ca20ac3a5533`). The logs and test scripts were deleted afterwards, so only the conclusions remain. Not re-tested since, except where noted.

For hook reference material use the current docs: https://code.claude.com/docs/en/hooks

## Where the Nov 2025 notes were wrong or out of date

Checked against the current hooks docs on 2026-10-04:

- **Event count**: the old notes listed 9 events. The docs now list about 30 (for example `PermissionRequest`, `PostToolUseFailure`, `SubagentStart`, `PostCompact`, `FileChanged`, `WorktreeCreate`).
- **Default timeout**: not 60 s for everything. Now 600 s for `command`/`http`/`mcp_tool` hooks, 30 s for `prompt`, 60 s for `agent`, with shorter defaults on a few events (`UserPromptSubmit` 30 s, `SessionEnd` 1.5 s shared budget).
- **Hook types**: now `command`, `prompt`, `agent`, `http`, `mcp_tool` (old notes: `command` and `prompt` only).

## Tested behavior

### Stop hook
- Fires when Claude finishes responding, not mid-response.
- Runs independently of what Claude says; creating files and continuing to talk just delays it to the end of the response.
- Can tell "uncommitted changes" apart from "untracked files".
- Matchers accept full regex (`Edit|Write`).
- `~/.claude/stop-hook-git-check.sh` (forces a commit and push) was still active in web sessions on 2026-10-04.

### Subagent hooks (web)
- `PreToolUse` fires when the main Claude spawns a Task subagent. The spawning tool is now called `Agent` in this environment, so a `Task` matcher may no longer match (not tested).
- `SubagentStop` fired more often than top-level spawns (2 spawns, 4 stop events), most likely because Plan spawned its own subagents; the log did not record which agent each event came from.
- `PostToolUse` fires for file operations by both the main Claude and subagents.
- `stop_hook_active` was `False` in every logged event. That only means none came from a stop-hook continuation; it does not show loop protection working. The field still exists (current docs, 2026-10-10), and there is now also a built-in cap of 8 consecutive stop-hook continuations (see `hook-cascade-patterns.md`).
- A Plan subagent took 5+ minutes and spawned its own subagents; each created log files, which made the Stop hook force commits (a cascade).

### Web vs CLI
- Web has no transcript mode (no Ctrl-R), so exit-0 hooks run silently. Verify them with a log file.
- Exit-2 hooks work the same in both: stderr goes to Claude.
- `$CLAUDE_CODE_REMOTE` is `"true"` on web, unset in CLI.
- Hooks load at session start. Hooks Claude creates mid-session are inactive until merged to the base branch and a new session starts. Confirmed by merging to `main` and starting a fresh session.
- `claude --teleport <session_id>` moves a web session to the CLI.

### Pattern that works on web

```bash
#!/bin/bash
LOG_FILE="${CLAUDE_PROJECT_DIR:-.}/.claude/hook-activity.log"
INPUT=$(cat)
TOOL=$(echo "$INPUT" | python3 -c "import sys, json; print(json.load(sys.stdin).get('tool_name', ''))" 2>/dev/null)
echo "$(date -u '+%Y-%m-%d %H:%M:%S UTC') - $TOOL" >> "$LOG_FILE"
exit 0   # silent on web; read the log to confirm
```

To make Claude react instead, print the reason to stderr and `exit 2`.

## Open questions

Answered since (current docs, 2026-10-04):
- **Prompt hooks on PreToolUse/PostToolUse?** Yes, on events that support decision control.
- **Duplicate hook commands?** The same handler defined in several settings files runs once. A plugin's or skill's copy stays separate.
- **Plugin vs user hooks?** They merge additively and run side by side.
- **Is `stop_hook_active` still sent?** Yes, to Stop and SubagentStop hooks (checked 2026-10-10).

Still open:
- Exact input JSON for each MCP tool type.
- Why the Plan subagent spawned extra subagents (may differ in current versions).
