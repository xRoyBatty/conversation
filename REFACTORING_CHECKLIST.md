# Refactoring Implementation Checklist

**Use this checklist to track implementation progress**

---

## Phase 1: Foundation (Days 1-2)

### Directory Creation
- [ ] Create `docs/` directory
- [ ] Create `hooks/lib/` directory
- [ ] Create `hooks/hooks/` directory
- [ ] Create `hooks/logic/` directory
- [ ] Create `hooks/hooks/_disabled/` directory
- [ ] Create `hooks/hooks/_archived/` directory
- [ ] Create `tests/unit/` directory
- [ ] Create `tests/integration/` directory
- [ ] Create `tests/fixtures/hook-inputs/` directory
- [ ] Create `tests/fixtures/expected-outputs/` directory
- [ ] Create `scripts/` directory
- [ ] Create `configs/` directory
- [ ] Create `examples/` directory
- [ ] Create `.github/workflows/` directory
- [ ] Create `docs/_assets/` directory

### Root Files
- [ ] Create `README.md` (main entry point)
- [ ] Create `CONTRIBUTING.md` (contribution guide)
- [ ] Create `.gitignore` (with log file patterns)

### Documentation
- [ ] Create `docs/README.md` (docs index)
- [ ] Create `docs/01-SETUP.md`
- [ ] Create `docs/CONTEXT.md` (from CLAUDE.md)
- [ ] Create `docs/ARCHITECTURE.md`
- [ ] Create `docs/NAMING_CONVENTIONS.md`

---

## Phase 2: Code Quality (Days 3-4)

### Shared Libraries
- [ ] Create `hooks/lib/hooks-base.sh` (main utilities)
- [ ] Create `hooks/lib/json-parser.py` (JSON helper)
- [ ] Add unit tests for hooks-base.sh
- [ ] Add unit tests for json-parser.py
- [ ] Document library in `docs/HOOKS_LIBRARY.md`

### Refactor Hook Scripts
- [ ] Refactor `pretooluse-task-logger.sh`
  - [ ] Source `hooks-base.sh`
  - [ ] Replace inline Python with parse_json()
  - [ ] Remove duplicate logging code
  - [ ] Test functionality

- [ ] Refactor `posttooluse-file-tracker.sh`
  - [ ] Source `hooks-base.sh`
  - [ ] Replace inline Python with parse_json()
  - [ ] Remove duplicate logging code
  - [ ] Test functionality

- [ ] Refactor `subagent-stop-validator.sh`
  - [ ] Source `hooks-base.sh`
  - [ ] Replace inline Python with parse_json()
  - [ ] Remove duplicate logging code
  - [ ] Test functionality

### Code Review
- [ ] Verify 35%+ code reduction
- [ ] Verify <20% remaining duplication
- [ ] Verify all tests pass

---

## Phase 3: Testing (Days 5-6)

### Test Framework
- [ ] Create `tests/test-runner.sh` (orchestrator)
- [ ] Create `tests/jest.config.js`
- [ ] Create `tests/pytest.ini`
- [ ] Document testing in `docs/06-TESTING.md`

### Unit Tests
- [ ] Write 10-15 tests for `hooks-base.sh`
  - [ ] Test `hook_init()` function
  - [ ] Test `log_hook_event()` function
  - [ ] Test `parse_json()` function
  - [ ] Test `exit_hook()` function

- [ ] Write 8-12 tests for `json-parser.py`
  - [ ] Test nested field extraction
  - [ ] Test default values
  - [ ] Test error handling

- [ ] Write 5-10 tests for existing `test.js`

### Integration Tests
- [ ] Create `tests/integration/test-hook-execution.sh`
  - [ ] Test hook execution flow
  - [ ] Test log file creation
  - [ ] Test JSON parsing

- [ ] Create `tests/integration/test-pretooluse-task.sh`
- [ ] Create `tests/integration/test-cascade-patterns.sh`

### Test Fixtures
- [ ] Create `tests/fixtures/hook-inputs/pretooluse-task.json`
- [ ] Create `tests/fixtures/hook-inputs/posttooluse-write.json`
- [ ] Create `tests/fixtures/hook-inputs/subagent-stop.json`
- [ ] Create expected outputs in `tests/fixtures/expected-outputs/`

### Coverage
- [ ] Achieve 80%+ test coverage
- [ ] Add coverage reporting
- [ ] Document coverage in test results

---

## Phase 4: Documentation (Days 7-8)

### Documentation Files
- [ ] Create `docs/02-HOOKS_REFERENCE.md` (from findings)
- [ ] Create `docs/03-HOOKS_API.md` (complete API)
- [ ] Create `docs/04-EXAMPLES.md` (practical examples)
- [ ] Move `hook-cascade-patterns.md` → `docs/05-CASCADES.md`
- [ ] Create `docs/07-TROUBLESHOOTING.md` (FAQ)

### Content Organization
- [ ] Add table of contents to all docs
- [ ] Add cross-references between docs
- [ ] Consolidate duplicate content from old files
- [ ] Add copy-paste-ready code examples

### Visual Assets
- [ ] Create `docs/_assets/hook-lifecycle.svg`
- [ ] Create `docs/_assets/event-flow-diagram.svg`
- [ ] Create `docs/_assets/cascade-decision-tree.svg`
- [ ] Create `docs/_assets/api-schema.json`

### Documentation Review
- [ ] Verify no duplicate content
- [ ] Verify all examples work
- [ ] Verify cross-references are valid

---

## Phase 5: Hook Management (Days 9)

### Manifest System
- [ ] Create `hooks/hooks.manifest.json`
  - [ ] Add `pretooluse-task-spawn` entry
  - [ ] Add `posttooluse-file-changes` entry
  - [ ] Add `subagent-stop-validate` entry
  - [ ] Include metadata (author, version, status, etc.)

- [ ] Create `hooks/hooks-registry.sh`
  - [ ] Implement `validate_hook()` function
  - [ ] Implement `list_hooks()` function
  - [ ] Add manifest validation

### Hook Organization
- [ ] Create `hooks/hooks/_disabled/` with placeholder
- [ ] Create `hooks/hooks/_archived/v1.0/` for old versions
- [ ] Document hook versioning strategy

### Testing
- [ ] Add manifest validation to test suite
- [ ] Test hook registry tool
- [ ] Test hook discovery

---

## Phase 6: Polish (Day 10)

### CI/CD Integration
- [ ] Create `.github/workflows/test-and-lint.yml`
  - [ ] Run all tests
  - [ ] Run shellcheck on bash scripts
  - [ ] Run markdownlint on docs
  - [ ] Generate coverage report

### Version Management
- [ ] Create `package.json` (root)
  - [ ] Set version to 1.0.0
  - [ ] Add description
  - [ ] Add scripts (test, lint, docs)

- [ ] Create `setup.py` (Python)

### Migration Tools
- [ ] Create `scripts/migrate-to-refactored.sh`
  - [ ] Backup old hooks
  - [ ] Create symlinks for compatibility
  - [ ] Update settings.json paths
  - [ ] Output migration summary

- [ ] Create `scripts/validate-docs.py`
  - [ ] Check markdown syntax
  - [ ] Verify cross-references
  - [ ] Check code examples

### Final Review
- [ ] All tests pass (80%+ coverage)
- [ ] All documentation complete
- [ ] Hook registry validated
- [ ] Git history clean
- [ ] No uncommitted changes

---

## File Migration Tracking

### Source Files to Move/Rename
- [ ] `CLAUDE.md` → `docs/CONTEXT.md`
- [ ] `claude-code-findings.md` → `docs/HOOKS_REFERENCE.md`
- [ ] `hook-cascade-patterns.md` → `docs/05-CASCADES.md`
- [ ] `.claude/SUBAGENT-HOOKS-TEST.md` → `docs/06-TESTING.md`
- [ ] `.claude/pretooluse-task-logger.sh` → `hooks/hooks/pretooluse-task-spawn.sh`
- [ ] `.claude/posttooluse-file-tracker.sh` → `hooks/hooks/posttooluse-file-changes.sh`
- [ ] `.claude/subagent-stop-validator.sh` → `hooks/hooks/subagent-stop-validate.sh`
- [ ] `.claude/settings.json` → `hooks/settings.json`
- [ ] `test.js` → `tests/unit/test-math.js`
- [ ] `test-hook-trigger.txt` → `tests/fixtures/hook-trigger-output.txt`
- [ ] `mid-response-test.txt` → `tests/fixtures/mid-response-output.txt`

### Log Files (Remove from Git)
- [ ] Remove `.claude/pretooluse-task.log`
- [ ] Remove `.claude/posttooluse-files.log`
- [ ] Remove `.claude/subagent-stop.log`
- [ ] Add `*.log` to `.gitignore`

---

## Quality Assurance

### Code Quality Checks
- [ ] All hook scripts pass shellcheck
- [ ] All Python files pass flake8
- [ ] All JavaScript files pass eslint
- [ ] No console errors in hooks
- [ ] All tests pass

### Documentation Quality
- [ ] All markdown files pass markdownlint
- [ ] All code examples work
- [ ] All links are valid
- [ ] All cross-references correct
- [ ] Table of contents accurate

### Functionality Checks
- [ ] All hooks execute without errors
- [ ] Logs created in correct location
- [ ] JSON parsing works correctly
- [ ] Test fixtures parse correctly
- [ ] Registry validates all hooks

---

## Verification Checklist

### Before Committing
- [ ] Run: `bash tests/test-runner.sh all`
- [ ] Run: `shellcheck hooks/**/*.sh`
- [ ] Run: `python3 scripts/validate-docs.py`
- [ ] Run: `git status` shows expected changes
- [ ] Run: `git diff` shows clean changes

### Before Merging
- [ ] All 6 phases completed
- [ ] All tests passing (80%+ coverage)
- [ ] Code review approved
- [ ] Documentation reviewed
- [ ] Migration guide updated

---

## Success Criteria Validation

After all phases, verify:

**Code Metrics:**
- [ ] Hook scripts ≤ 80 lines each (was 35-55)
- [ ] Code duplication ≤ 15% (was 65%)
- [ ] Test coverage ≥ 80% (was 0%)

**File Organization:**
- [ ] Documentation in `docs/` (was root + .claude/)
- [ ] Hooks in `hooks/` (was .claude/)
- [ ] Tests in `tests/` (was root + .claude/)
- [ ] All directories created

**Developer Experience:**
- [ ] README provides quick start
- [ ] Setup time < 10 minutes
- [ ] CONTRIBUTING guide available
- [ ] Examples provided

**Project Health:**
- [ ] CI/CD pipeline working
- [ ] Hook registry updated
- [ ] Version numbers set
- [ ] Migration documented

---

## Notes Section

Use this space to track decisions, blockers, or notes:

```
Date        Status      Note
---         ------      ----
[Example]   [Status]    [Note about decision or blocker]
```

---

## Timeline Tracking

**Start Date**: _______________  
**Target Completion**: _______________  
**Actual Completion**: _______________

**Phase Progress**:
- Phase 1: __/2 days
- Phase 2: __/2 days
- Phase 3: __/2 days
- Phase 4: __/2 days
- Phase 5: __/1 day
- Phase 6: __/1 day

**Total Time Invested**: ________ hours / 50 hours estimate

