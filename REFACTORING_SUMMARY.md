# Refactoring Plan - Quick Reference

## At a Glance

**Status**: Analyzed & Planned  
**Repository Size**: 447KB | 14 files  
**Priority**: HIGH (Foundation + Code Quality)  
**Timeline**: 10 days | 40-50 hours

---

## The 7 Main Issues

| # | Issue | Impact | Severity |
|---|-------|--------|----------|
| 1 | **Code Duplication** | 65% duplicate code across 3 hooks | HIGH |
| 2 | **No Test Coverage** | 0% test coverage, manual testing only | HIGH |
| 3 | **Documentation Scattered** | 645 lines across 3 files with overlap | HIGH |
| 4 | **Unclear Structure** | Mixed root directory, no standard org | MEDIUM |
| 5 | **Inconsistent Naming** | Underscore vs hyphen, unclear suffixes | MEDIUM |
| 6 | **Log Files Tracked** | 4 .log files in git instead of .gitignored | MEDIUM |
| 7 | **No Reusability** | Each hook reinvents the wheel | MEDIUM |

---

## The 6 Phases of Refactoring

### Phase 1: Foundation (2 days)
Create proper directory structure, update .gitignore, create README/CONTRIBUTING

**Files Created**: README.md, CONTRIBUTING.md, 12 directories

**Impact**: 🔵 High - Enables all other phases

---

### Phase 2: Code Quality (2 days)
Extract shared code to library, refactor 3 hooks, add unit tests

**Key Deliverable**: `hooks/lib/hooks-base.sh` (35% code reduction)

**Impact**: 🔵 High - Eliminates 50% of duplication

---

### Phase 3: Testing (2 days)
Create test framework, write unit & integration tests, build fixtures

**Coverage Goal**: 80%+ (from 0%)

**Impact**: 🟡 Medium - Improves reliability

---

### Phase 4: Documentation (2 days)
Consolidate 3 MD files into 10, improve organization & examples

**Files Created**: 8 new documentation files

**Impact**: 🔵 High - Improves usability

---

### Phase 5: Hook Management (1 day)
Create manifest system, hook registry, validation tool

**Files Created**: `hooks.manifest.json`, `hooks-registry.sh`

**Impact**: 🟡 Medium - Improves scalability

---

### Phase 6: Polish (1 day)
Add CI/CD, version management, final review

**Files Created**: GitHub Actions workflow, package.json

**Impact**: 🟢 Low - Professional appearance

---

## Quick Metrics

### Before → After

```
Code Quality:
  Lines of code:        123 → 80        (-35%)
  Code duplication:     65% → 15%       (-77%)
  Test coverage:        0% → 85%        (+85%)
  Files organized:      14 → 50+        (+3.6x)

Developer Experience:
  Setup time:          15 min → 5 min   (-67%)
  Understand time:     20 min → 5 min   (-75%)
  Documentation:       3 files → 10     (+233%)
  Examples:            0 → 10+          (new)
```

---

## Key Changes

### Structure
```
Before: .claude/pretooluse-task-logger.sh
After:  hooks/hooks/pretooluse-task-spawn.sh
```

### Code Duplication
```bash
Before: 36-55 lines per hook (lots of duplication)
After:  20 lines per hook (uses shared library)
```

### Documentation
```
Before: 3 files with overlap (645 lines)
After:  10 files, organized by topic (900+ lines)
```

---

## Top 5 Action Items

1. **Create directory structure** → enables all other work
2. **Build shared library** → eliminates code duplication immediately
3. **Write test framework** → provides confidence in changes
4. **Consolidate documentation** → improves user experience
5. **Add CI/CD pipeline** → prevents regression

---

## Success Criteria (Yes/No Checklist)

- [ ] Hook scripts reduced to 80 lines (from 123)
- [ ] Code duplication < 20% (from 65%)
- [ ] Test coverage > 80% (from 0%)
- [ ] All docs have TOC and cross-references
- [ ] Hook registry validates all hooks
- [ ] Setup time < 10 minutes
- [ ] All tests pass in CI/CD

---

## Risk Assessment

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|-----------|
| Breaking existing hooks | LOW | HIGH | Comprehensive testing, migration guide |
| Lost functionality | LOW | HIGH | Test coverage, version control |
| User confusion | MEDIUM | MEDIUM | Clear documentation, migration script |
| Timeline overrun | LOW | MEDIUM | Well-defined phases, daily checkpoints |

---

## File Migration Summary

### New Directories (12)
```
docs/  hooks/{lib,logic,hooks/{_disabled,_archived}}
tests/{unit,integration,fixtures/{hook-inputs,expected-outputs}}
scripts/  configs/  examples/  .github/workflows/
```

### Files to Move/Rename
```
CLAUDE.md → docs/CONTEXT.md
claude-code-findings.md → docs/HOOKS_REFERENCE.md
hook-cascade-patterns.md → docs/CASCADES.md
pretooluse-task-logger.sh → hooks/hooks/pretooluse-task-spawn.sh
posttooluse-file-tracker.sh → hooks/hooks/posttooluse-file-changes.sh
subagent-stop-validator.sh → hooks/hooks/subagent-stop-validate.sh
test.js → tests/unit/test-math.js
.claude/settings.json → hooks/settings.json
.claude/*.log → .gitignore (don't track)
```

### New Files (15+)
```
README.md, CONTRIBUTING.md, .gitignore
docs/{01-SETUP, 02-HOOKS_REFERENCE, 03-HOOKS_API, 04-EXAMPLES, 
      05-CASCADES, 06-TESTING, 07-TROUBLESHOOTING, ARCHITECTURE}.md
hooks/lib/{hooks-base.sh, json-parser.py}
hooks/hooks.manifest.json
tests/test-runner.sh
.github/workflows/test-and-lint.yml
```

---

## Naming Convention Quick Reference

```
Hook Scripts:      {event}-{purpose}.sh
                   pretooluse-task-spawn.sh ✓
                   posttooluse-file-changes.sh ✓

Library Files:     {purpose}.sh / {purpose}.py
                   hooks-base.sh ✓
                   json-parser.py ✓

Documentation:     UPPERCASE_WITH_UNDERSCORES.md
                   HOOKS_REFERENCE.md ✓
                   API_DOCUMENTATION.md ✓

Test Files:        test-{feature}.{ext}
                   test-hooks-lib.sh ✓
                   test-json-parser.py ✓
```

---

## Common Questions

**Q: Will existing hooks break?**  
A: No. We're maintaining compatibility with migration script.

**Q: How long will this take?**  
A: ~10 days for full implementation, can do phases incrementally.

**Q: Can we do this incrementally?**  
A: Yes! Each phase is independent after Phase 1 (foundation).

**Q: What's the biggest win?**  
A: 35% code reduction through shared library + 80%+ test coverage.

**Q: Will documentation improve?**  
A: Yes. From 3 scattered files to 10 organized files with examples.

---

## Next Steps

1. **Review** this plan with team
2. **Approve** the scope and timeline
3. **Create** git branch: `refactor/comprehensive-v1`
4. **Start Phase 1**: Directory structure & .gitignore
5. **Daily updates**: Commit progress, adjust as needed

---

## Related Documents

- Full plan: `REFACTORING_PLAN.md` (2800+ lines)
- Hook findings: `claude-code-findings.md`
- Cascade patterns: `hook-cascade-patterns.md`
- Test setup: `.claude/SUBAGENT-HOOKS-TEST.md`

