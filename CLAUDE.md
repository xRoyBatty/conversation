Engage in a dialogue with the user. He would like to understand the array of your skills in this environment - Claude Code on the web (promo) and differences compared to Claude Code CLI app. Do not browse web results as you will be suggested to think in a certain way, you are you and you know how to check what you yourself can do. The reason it's urgent is here, Anthropic's email:
We're offering a limited-time promotion that gives Pro and Max users extra usage credits exclusively for Claude Code on the web and mobile. This is designed to help you explore the full power of parallel Claude Code sessions without worrying about your regular usage limits.

Pro users receive $250 in credits

Max users receive $1,000 in credits

These credits are separate from your standard usage limits and can only be used for Claude Code on the web and mobile. They expire on November 18 at 11:59 PM PT. Your regular Claude usage limits remain unchanged.

Promotion dates: Tuesday, November 4, 2025 at 9:00 AM PT through Tuesday, November 18, 2025 at 11:59 PM PT.

This is a limited time offer. It is available for existing users and only available for new users while supplies last.
Today is 11th November, I'm a pro user.

## Confirmed Differences: Web vs CLI

### Environment & Execution
1. **Execution Context**: Web operates in isolated sandboxed environment with automated branch creation; CLI works in local terminal
2. **Usage Limits**: Web uses credit-based billing ($250 for Pro); CLI uses standard Pro message limits + 5-hour timeout
3. **Context Window**: Both share 200k token limit

### Hooks System (TESTED & CONFIRMED)
4. **Transcript Mode**: CLI has transcript mode (Ctrl-R) where exit 0 hook stdout appears; **Web has NO transcript mode**
5. **Hook Visibility**:
   - CLI: Exit 0 hooks show output in transcript mode
   - Web: Exit 0 hooks execute silently - **require file logging to verify execution**
   - Both: Exit 2 (blocking) hooks feed stderr to Claude directly
6. **Hook Execution**: Both environments execute hooks identically (PreToolUse, PostToolUse, SubagentStop all confirmed working in web)
7. **Environment Detection**: Use `$CLAUDE_CODE_REMOTE` env var - set to `"true"` in web, unset/empty in CLI

### Session Management
8. **Teleport Feature**: Web sessions can be moved to CLI with `claude --teleport <session_id>` but requires local repo checkout
9. **Hook Loading**: Hooks load at session startup in both environments (mid-session changes require restart)

### Practical Implications
- **For web hooks**: Use exit 2 (blocking) OR exit 0 with file logging - stderr-only output is invisible
- **For CLI hooks**: Both exit 0 (transcript) and exit 2 (blocking) are visible
- **Cross-compatible hooks**: Write to log files AND stderr for universal compatibility
