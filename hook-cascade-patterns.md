# Hook cascades: one real test and some untested ideas

A cascade is when hooks keep sending Claude back to work: a hook blocks, Claude fixes something, another hook fires, and so on.

Trimmed and checked against https://code.claude.com/docs/en/hooks on 2026-10-10. The original (Nov 2025) was mostly theoretical: seven example pipelines with guessed iteration counts. Those counts were estimates, not measurements, and are removed. The one real test is kept below.

## Loop limits: corrections to the Nov 2025 notes

- **`stop_hook_active` does not stop loops by itself.** It is `true` in the Stop/SubagentStop input when Claude is already continuing because of a stop hook. A hook has to read it and decide not to block again. The old notes called it "the key safety mechanism", which overstated it.
- **There is now a built-in cap.** The docs say: after stop hooks continue the turn 8 times in a row, Claude Code overrides the next block and ends the turn. The count resets each time Claude calls a tool. `CLAUDE_CODE_STOP_HOOK_BLOCK_CAP` raises it. So the old "never stop" example (`exit 2` on every Stop) no longer blocks forever. Not tested here.
- **Timeouts**: default 600 s for command hooks, 30 s for prompt hooks, 60 s for agent hooks (old notes: 60 s).
- **Context window**: 1M tokens in current sessions (old notes: 200k).
- **Subagent tool name**: the tool that spawns subagents is now called `Agent` in this environment (it was `Task`). A `PreToolUse` matcher of `Task` may no longer match. Not tested.
- **SubagentStop matchers** now filter by agent type (`Explore`, `Plan`, `general-purpose`, custom names).

Guard the docs recommend in a Stop hook:

```bash
#!/bin/bash
INPUT=$(cat)
if [ "$(echo "$INPUT" | jq -r '.stop_hook_active')" = "true" ]; then
  exit 0  # already continuing because of a stop hook; don't block again
fi
echo "Run the test suite before finishing." >&2
exit 2
```

## The real test (Nov 2025, web, session `c8531714-109b-4121-acba-ca20ac3a5533`)

Hooks: PreToolUse on `Task` (log spawns), PostToolUse on `Write|Edit` (log edits), SubagentStop (log), and the global Stop hook that forces commits.

Prompts: (1) use Explore to find markdown files, (2) create a test file, (3) use Plan to make a refactoring plan.

Logged timeline (UTC):

```
13:35:56  SubagentStop #1 (source unclear)
13:35:58  PreToolUse: Explore spawned
13:36:04  SubagentStop #2
13:36:10  SubagentStop #3
13:39:07  PreToolUse: Plan spawned
13:44:29  SubagentStop #4 (Plan finished)
```

What it showed:
- 2 spawns produced 4 SubagentStop events, so SubagentStop fired for more than the top-level agents. That Plan spawned its own subagents is the likely explanation; the log did not record which agent each event came from.
- The hooks' own log files triggered the Stop hook, which forced 2 commits. Hooks that write files into the repo feed the commit-enforcing Stop hook.
- `stop_hook_active` was `false` in every logged event. That only means none of those events came from a stop-hook continuation. It does not show that loop protection works.
- Total: about 14 actions (8 hook runs, 4 subagent operations, 2 forced commits).

The logs were deleted afterwards, so this timeline is the only record.

## Untested ideas from the original notes

Each would chain hooks so Claude cannot finish until a check passes:

1. PostToolUse runs tests after edits; Stop runs the linter.
2. SubagentStop checks a search subagent's results and blocks if incomplete.
3. PostToolUse prompt hook scores written code and blocks below a threshold.
4. PostToolUse detects a deploy and runs smoke tests; Stop checks health.
5. SubagentStop validates a planner and several workers; Stop runs integration tests.
6. Stop blocks while modules remain unmigrated.
7. PostToolUse runs a security scan after each edit; Stop runs a full audit.
8. PreToolUse prompt hook blocks writing code before tests exist (test-first).

With the 8-continuation cap, Stop-driven loops like 6 now end after 8 blocks in a row unless Claude calls a tool in between, which resets the count.
