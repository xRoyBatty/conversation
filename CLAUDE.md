Engage in a dialogue with the user. They want to understand what Claude can do in this environment (Claude Code on the web) and how it differs from the Claude Code CLI app, including how usage limits and promotions apply.

Do not guess about billing or limits. Check what you can (web search, the user's screenshots, the session itself) and say what you could not verify. Web search and fetch are allowed; some hosts may be blocked by the environment's network policy.

Do not rely on a "today" date in this file. Use the date of the session.

## Current state (updated 2026-10-04)

- **Promo in effect**: Pro users get $100 of cloud session credits (Max: $250). Claim by Oct 7; unused credit expires Nov 5, 8:59 AM GMT+1 (per the user's usage panel, which showed $97 of $100 left). Applies to cloud sessions only, not local CLI sessions.
- **Artifact usage promotion (official: support.claude.com article 17274727)**: Oct 1, 2026 11:00 AM PT to Oct 15, 2026 11:59 PM PT, Pro/Max/Team only. After Claude creates or edits an artifact (doc, slides, design) in a Claude chat, the next 10 messages use 50% less of the **five-hour session limit**. The **weekly limit is unchanged**. It does **not** apply to Claude Code (so not to this web session), the API, Slack, or usage credits. No action needed.
- **Cloud credit terms (from news sites, not an official page I could open)**: individual Pro/Max subscribers active on Sep 23, 2026; claim via Anthropic's link or `/claim-credit` by Oct 7; credits apply automatically to cloud sessions and are separate from normal limits.
- **Plan limits**: Pro has a session limit and a weekly all-models limit. The weekly bar showed 100% (reset Monday 4:00 PM) while cloud credits still remained, so cloud credits look like a separate budget.
- **Expired**: the Nov 4-18, 2025 promo ($250 Pro / $1,000 Max) is over.

## Web vs CLI

### Environment and execution
1. **Execution context**: Web runs in an isolated sandbox with a fresh clone; CLI runs in the local terminal. Work must be committed and pushed or it is lost when the container is reclaimed.
2. **Usage**: Web sessions draw on cloud session credits while a promo is active; CLI uses the normal plan limits.
3. **Context window**: This session shows a 1M-token window. The 200k figure noted in Nov 2025 is outdated.

### Hooks (tested Nov 2025, not re-tested since)
4. **Transcript mode**: CLI has transcript mode (Ctrl-R) where exit 0 hook stdout appears; web has no transcript mode.
5. **Hook visibility**:
   - CLI: exit 0 hooks show output in transcript mode.
   - Web: exit 0 hooks run silently, so log to a file to verify execution.
   - Both: exit 2 (blocking) hooks feed stderr to Claude directly.
6. **Hook execution**: Both environments ran hooks the same way (PreToolUse, PostToolUse, SubagentStop confirmed on web).
7. **Environment detection**: `$CLAUDE_CODE_REMOTE` is `"true"` on web, unset in CLI.

### Session management
8. **Teleport**: Web sessions can be moved to the CLI with `claude --teleport <session_id>`; requires a local repo checkout.
9. **Hook loading**: Hooks load at session start in both environments; changes mid-session need a restart.
10. **Web hook workflow**: Hooks created during a web session are inactive until merged to the base branch (or the branch is chosen as the base for a new session), because web sessions pull from the base branch at startup.

### Practical implications
- Web hooks: use exit 2 (blocking), or exit 0 with file logging. Stderr alone is invisible.
- CLI hooks: exit 0 (transcript) and exit 2 (blocking) are both visible.
- Cross-compatible hooks: write to a log file and to stderr.
