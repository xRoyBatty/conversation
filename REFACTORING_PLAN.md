# Comprehensive Refactoring Plan - Claude Code Hooks Repository

**Repository**: Claude Code Hooks Testing & Documentation  
**Current Size**: 447KB | **Files**: 14 (excluding .git)  
**Branch**: claude/explore-and-plan-refactor-011CV2BzZVYT6WmEi4SxhwJX  
**Date**: November 11, 2025

---

## Executive Summary

This repository documents Claude Code's hook system and tests hook behavior in the web environment. While the documentation is comprehensive, the codebase suffers from:

1. **Code Duplication** - Hook scripts repeat logging/parsing logic (65% duplication)
2. **Inconsistent Structure** - Mixed naming conventions and organization
3. **Poor Separation of Concerns** - Logging mixed with validation logic
4. **Documentation Fragmentation** - Key information spread across multiple MD files
5. **Test Coverage Gaps** - No formal test framework; manual testing only
6. **Artifact Management** - Log files committed to repo instead of being .gitignored
7. **Limited Reusability** - No shared utilities or helper libraries

---

## 1. CODE ORGANIZATION & STRUCTURE

### Current State
```
/home/user/conversation/
├── .claude/
│   ├── SUBAGENT-HOOKS-TEST.md         (test instructions)
│   ├── settings.json                  (hook configuration)
│   ├── pretooluse-task-logger.sh      (hook script #1)
│   ├── posttooluse-file-tracker.sh    (hook script #2)
│   ├── subagent-stop-validator.sh     (hook script #3)
│   └── *.log                          (4 log files)
├── CLAUDE.md                          (user context)
├── claude-code-findings.md            (reference guide - 297 lines)
├── hook-cascade-patterns.md           (theory document - 332 lines)
├── test.js                            (basic test - 22 lines)
└── test-*.txt                         (test outputs)
```

### Issues
- **Root directory clutter**: 8 files in root (mix of docs, tests, outputs)
- **No src/ directory**: Hook scripts live in .claude/ without clear organization
- **Log files tracked**: 4 .log files should be .gitignored
- **Test files mixed**: test.js and test-*.txt are unrelated to documentation
- **No README**: No entry point for new contributors
- **Documentation volume**: 645 lines across 3 files with content overlap

### Refactoring Plan: Phase 1 - Directory Structure

**Target Structure:**

```
/
├── README.md                          (new: main entry point)
├── CONTRIBUTING.md                    (new: contribution guide)
├── .gitignore                         (update: add log files)
├── docs/
│   ├── README.md                      (documentation index)
│   ├── 01-SETUP.md                    (new: installation guide)
│   ├── 02-HOOKS_REFERENCE.md          (merged from findings)
│   ├── 03-HOOKS_API.md                (new: complete API)
│   ├── 04-EXAMPLES.md                 (new: practical examples)
│   ├── 05-CASCADES.md                 (from cascade patterns)
│   ├── 06-TESTING.md                  (new: test guide)
│   ├── 07-TROUBLESHOOTING.md          (new: FAQ & debug)
│   ├── ARCHITECTURE.md                (new: design docs)
│   ├── NAMING_CONVENTIONS.md          (new: standards)
│   └── _assets/                       (diagrams & schemas)
├── hooks/
│   ├── lib/
│   │   ├── hooks-base.sh              (new: shared utilities)
│   │   ├── json-parser.py             (new: JSON helper)
│   │   └── logging.sh                 (new: logging utils)
│   ├── hooks/
│   │   ├── pretooluse-task-spawn.sh   (refactored)
│   │   ├── posttooluse-file-changes.sh (refactored)
│   │   ├── subagent-stop-validate.sh  (refactored)
│   │   ├── _disabled/                 (new: disabled hooks)
│   │   └── _archived/                 (new: archived versions)
│   ├── logic/
│   │   ├── task-spawn-logic.sh        (new: business logic)
│   │   ├── file-changes-logic.sh      (new: business logic)
│   │   └── subagent-validation-logic.sh (new: business logic)
│   ├── hooks.manifest.json            (new: hook registry)
│   ├── hooks-registry.sh              (new: registry tool)
│   └── settings.json                  (moved from .claude/)
├── tests/
│   ├── test-runner.sh                 (new: test orchestrator)
│   ├── unit/
│   │   ├── test-hooks-lib.sh          (new: lib tests)
│   │   ├── test-json-parser.py        (new: Python tests)
│   │   └── test-math.js               (renamed from test.js)
│   ├── integration/
│   │   ├── test-hook-execution.sh     (new)
│   │   ├── test-pretooluse-task.sh    (new)
│   │   └── test-cascade-patterns.sh   (new)
│   ├── fixtures/
│   │   ├── hook-inputs/               (new: test data)
│   │   └── expected-outputs/          (new: expectations)
│   ├── jest.config.js                 (new)
│   └── pytest.ini                     (new)
├── scripts/
│   ├── migrate-to-refactored.sh       (new: migration tool)
│   └── validate-docs.py               (new: doc validator)
├── configs/
│   ├── settings.development.json      (new)
│   ├── settings.production.json       (new)
│   ├── settings.web.json              (new)
│   └── settings.cli.json              (new)
└── examples/
    ├── basic-logging-hook/            (new: example 1)
    ├── validation-hook/               (new: example 2)
    └── cascade-pattern/               (new: example 3)
```

**Action Items:**

```
1. Create directory structure (12 new directories)
2. Update .gitignore with patterns for logs, builds, cache
3. Move and rename existing files per migration checklist
4. Create placeholder files for new documentation
5. Update .claude/settings.json references
```

---

## 2. FILE NAMING CONVENTIONS

### Current Issues

| Issue | Example |
|-------|---------|
| Inconsistent separators | `pretooluse_` vs `posttooluse-` |
| Unclear suffixes | `-logger.sh`, `-tracker.sh`, `-validator.sh` |
| Test file names | `test-hook-trigger.txt`, `mid-response-test.txt` |
| Log file mismatches | Hook script names don't match log names |

### Naming Standards

```
Hook Scripts:     {HookEvent}-{Purpose}.sh
  ✓ pretooluse-task-spawn.sh
  ✓ posttooluse-file-changes.sh
  ✓ subagent-stop-validate.sh

Logic Files:      {purpose}-logic.sh
  ✓ task-spawn-logic.sh
  ✓ file-changes-logic.sh

Library Files:    {purpose}.sh or {purpose}.py
  ✓ hooks-base.sh
  ✓ json-parser.py

Documentation:    UPPERCASE_WITH_UNDERSCORES.md
  ✓ HOOKS_REFERENCE.md
  ✓ API_DOCUMENTATION.md

Test Files:       test-{feature}.{ext}
  ✓ test-hooks-lib.sh
  ✓ test-json-parser.py
  ✓ test-math.js
```

**Renames Required:**

```
pretooluse-task-logger.sh        → pretooluse-task-spawn.sh
posttooluse-file-tracker.sh      → posttooluse-file-changes.sh
subagent-stop-validator.sh       → subagent-stop-validate.sh
test.js                          → tests/unit/test-math.js
test-hook-trigger.txt            → tests/fixtures/hook-trigger-output.txt
mid-response-test.txt            → tests/fixtures/mid-response-output.txt
.claude/*.log                    → logs/*.log
```

---

## 3. CODE DUPLICATION & CRITICAL REFACTORING

### Duplication Analysis

**Current Scripts (123 total lines):**

| Component | pretooluse | posttooluse | subagent | Occurrences |
|-----------|-----------|------------|----------|------------|
| Log file setup | ✓ | ✓ | ✓ | 3x |
| Read stdin | ✓ | ✓ | ✓ | 3x |
| Python JSON parse | 3 | 3 | 3 | 9 one-liners |
| Timestamp logging | ✓ | ✓ | ✓ | 3x |
| Separator lines | ✓ | ✓ | ✓ | 3x |
| Stderr formatting | ✓ | ✓ | ✓ | 3x |
| **Duplication Score** | — | **~65%** | **~60%** | — |

### Solution: Shared Library (`hooks/lib/hooks-base.sh`)

```bash
#!/bin/bash
# Shared hook utilities library

hook_init() {
  local script_name=$1 hook_type=$2
  LOG_DIR="${CLAUDE_PROJECT_DIR:-.}/.claude/logs"
  mkdir -p "$LOG_DIR"
  LOG_FILE="$LOG_DIR/${script_name}.log"
  HOOK_TYPE="$hook_type"
}

log_hook_event() {
  local event=$1 details=$2
  {
    echo "=================================================="
    echo "TIMESTAMP: $(date -u '+%Y-%m-%d %H:%M:%S UTC')"
    echo "EVENT: $event"
    [[ -n "$details" ]] && echo "DETAILS: $details"
    echo "=================================================="
    echo ""
  } | tee -a "$LOG_FILE" >&2
}

parse_json() {
  local field=$1 default=${2:-.}
  python3 -c "
import sys, json
try:
  data = json.load(sys.stdin)
  keys = '$field'.replace('.', ' ').split()[1:]
  for key in keys: data = data.get(key, {})
  print(data if data else '$default')
except: print('$default')
" 2>/dev/null
}

exit_hook() {
  local code=$1 message=${2:-}
  [[ $code -eq 0 ]] && [[ -n "$message" ]] && echo "$message" >&2 || echo "Hook error: $message" >&2
  exit $code
}
```

**Refactored Hook (20 lines instead of 36-55):**

```bash
#!/bin/bash
source "$(dirname "$0")/../lib/hooks-base.sh"
hook_init "pretooluse-task-spawn" "PreToolUse"

INPUT=$(cat)
TOOL=$(echo "$INPUT" | parse_json '.tool_name' '')
[[ "$TOOL" != "Task" ]] && exit 0

SUBAGENT=$(echo "$INPUT" | parse_json '.tool_input.subagent_type' 'unknown')
log_hook_event "PreToolUse - Task spawn" "Subagent: $SUBAGENT"
exit_hook 0
```

**Expected Improvements:**
- Code reduction: 123 → 80 lines (-35%)
- Maintainability: Single source for logging logic
- Consistency: Unified error handling
- Testability: Library functions can be unit tested independently

---

## 4. DOCUMENTATION IMPROVEMENTS

### Consolidation Plan

**Source Content (645 lines):**
- `claude-code-findings.md` (297 lines) → Split into REFERENCE + API
- `hook-cascade-patterns.md` (332 lines) → Move to CASCADES.md
- `SUBAGENT-HOOKS-TEST.md` (54 lines) → Merge into TESTING.md
- `CLAUDE.md` (16 lines) → Archive in CONTEXT.md

**Target Documentation (900+ lines, better organized):**

| File | Size | Purpose |
|------|------|---------|
| docs/README.md | 50 | Quick start & navigation |
| docs/01-SETUP.md | 80 | Installation & config |
| docs/02-HOOKS_REFERENCE.md | 150 | System overview |
| docs/03-HOOKS_API.md | 200 | Complete API reference |
| docs/04-EXAMPLES.md | 120 | Practical examples |
| docs/05-CASCADES.md | 332 | Cascade patterns |
| docs/06-TESTING.md | 100 | Test guide |
| docs/07-TROUBLESHOOTING.md | 80 | FAQ & debug |
| docs/ARCHITECTURE.md | 80 | Design patterns |
| docs/NAMING_CONVENTIONS.md | 60 | Naming standards |

**Content Improvements:**
- Add table of contents to all docs
- Create visual diagrams (hook lifecycle, event flow)
- Cross-reference between docs
- Add copy-paste-ready examples
- Include troubleshooting section

---

## 5. TEST COVERAGE

### Current State: 0% Coverage

**Existing Tests:**
- `test.js` - 22 lines of basic math (not representative)
- Manual testing instructions in `.claude/SUBAGENT-HOOKS-TEST.md`
- No fixtures, no test runner, no CI/CD

### Target State: 80%+ Coverage

**Test Structure:**

```
tests/
├── unit/              (15-20 tests)
│   ├── test-hooks-lib.sh           (bash library tests)
│   ├── test-json-parser.py         (Python utility tests)
│   └── test-math.js                (existing math tests)
├── integration/       (5-7 tests)
│   ├── test-hook-execution.sh      (end-to-end hook tests)
│   ├── test-pretooluse-task.sh     (PreToolUse event tests)
│   └── test-cascade-patterns.sh    (cascade scenario tests)
├── fixtures/
│   ├── hook-inputs/                (JSON test data)
│   └── expected-outputs/           (expected log outputs)
└── test-runner.sh                  (unified orchestrator)
```

**Test Examples:**

```bash
# tests/unit/test-hooks-lib.sh
#!/bin/bash

test_hook_init() {
  source hooks/lib/hooks-base.sh
  hook_init "test-hook" "PreToolUse"
  [[ -n "$LOG_FILE" ]] && echo "PASS: hook_init sets LOG_FILE"
}

test_parse_json() {
  local result=$(echo '{"tool":"Task"}' | parse_json '.tool')
  [[ "$result" = "Task" ]] && echo "PASS: parse_json extracts field"
}

# Run all tests
test_hook_init
test_parse_json
```

---

## 6. HOOK SYSTEM ORGANIZATION

### Hook Manifest (`hooks/hooks.manifest.json`)

```json
{
  "version": "1.0",
  "updated": "2025-11-11",
  "hooks": [
    {
      "id": "pretooluse-task-spawn",
      "file": "pretooluse-task-spawn.sh",
      "event": "PreToolUse",
      "matcher": "Task",
      "description": "Logs when Task subagent is about to spawn",
      "author": "xRoyBatty",
      "version": "1.0.0",
      "status": "active",
      "timeout": 10,
      "blocking": false,
      "created": "2025-11-04",
      "dependencies": ["hooks-base.sh"]
    }
  ]
}
```

### Hook Registry Tool (`hooks/hooks-registry.sh`)

```bash
#!/bin/bash
validate_hook() {
  local hook=$1
  [[ ! -f "$hook" ]] && return 1
  bash -n "$hook" && return 0 || return 1
}

list_hooks() {
  python3 -c "
import json
with open('hooks.manifest.json') as f:
  data = json.load(f)
for hook in data['hooks']:
  print(f\"{hook['id']:30} {hook['event']:15} {hook['status']}\")
"
}
```

---

## 7. SEPARATION OF CONCERNS

### Current Mix

```bash
# Current hook script mixes:
1. Input parsing (JSON extraction)
2. Logging (file + stderr)
3. Validation (tool matching)
4. Business logic (what to log)
5. Error handling (exit codes)
```

### Proposed Separation

```bash
# Orchestrator (hooks/hooks/pretooluse-task-spawn.sh)
source hooks-base.sh          # Import utilities
hook_init "pretooluse-task-spawn" "PreToolUse"
INPUT=$(cat)
source ../logic/task-spawn-logic.sh  # Import business logic
process_task_spawn "$INPUT"
log_hook_event "Event" "$DETAILS"
exit_hook 0

# Business Logic (hooks/logic/task-spawn-logic.sh)
process_task_spawn() {
  local input=$1
  TOOL=$(extract_field "$input" '.tool_name')
  [[ "$TOOL" != "Task" ]] && return
  SUBAGENT=$(extract_field "$input" '.tool_input.subagent_type')
  # Custom validation/processing here
}
```

---

## 8. ADDITIONAL IMPROVEMENTS

### 8.1 Git Management

**Update `.gitignore`:**

```
*.log
*.tmp
*.swp
.DS_Store
node_modules/
__pycache__/
*.pyc
.pytest_cache/
build/
dist/
.coverage
htmlcov/
.claude/logs/
tests/output/
```

### 8.2 CI/CD Integration

**GitHub Actions Workflow (`.github/workflows/test-and-lint.yml`):**

```yaml
name: Tests & Linting
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run all tests
        run: bash tests/test-runner.sh all
      - name: Lint bash scripts
        run: shellcheck hooks/**/*.sh
      - name: Check docs
        run: python3 scripts/validate-docs.py
```

### 8.3 Version Management

```json
// package.json
{
  "name": "claude-code-hooks",
  "version": "1.0.0",
  "description": "Claude Code hooks system"
}
```

---

## IMPLEMENTATION ROADMAP

### Phase 1: Foundation (High Impact)
**Duration:** 2 days | **Priority:** CRITICAL
- [ ] Create directory structure (12 new dirs)
- [ ] Update .gitignore
- [ ] Create README.md & CONTRIBUTING.md
- [ ] Move files to new locations
- **Deliverable:** Organized repository structure

### Phase 2: Code Quality (High Impact)
**Duration:** 2 days | **Priority:** CRITICAL
- [ ] Create `hooks/lib/hooks-base.sh` library
- [ ] Refactor 3 hook scripts to use library
- [ ] Create `hooks/lib/json-parser.py`
- [ ] Add unit tests for libraries
- **Deliverable:** 35% code reduction, single source of truth

### Phase 3: Testing (Medium Impact)
**Duration:** 2 days | **Priority:** HIGH
- [ ] Create test framework & runner
- [ ] Write 15-20 unit tests
- [ ] Write 5-7 integration tests
- [ ] Create test fixtures
- **Deliverable:** 80%+ test coverage

### Phase 4: Documentation (High Impact)
**Duration:** 2 days | **Priority:** HIGH
- [ ] Consolidate 3 MD files into 8
- [ ] Create new guides (Setup, API, Examples)
- [ ] Add diagrams and flowcharts
- [ ] Update all cross-references
- **Deliverable:** Comprehensive, organized documentation

### Phase 5: Hook Management (Medium Impact)
**Duration:** 1 day | **Priority:** MEDIUM
- [ ] Create `hooks.manifest.json`
- [ ] Implement registry tool
- [ ] Add hook validation tests
- [ ] Create `_disabled/` and `_archived/` dirs
- **Deliverable:** Robust hook management system

### Phase 6: Polish (Low Impact)
**Duration:** 1 day | **Priority:** LOW
- [ ] Add GitHub Actions CI/CD
- [ ] Add version management
- [ ] Create release notes template
- [ ] Final documentation review
- **Deliverable:** Professional, release-ready code

**Total Timeline:** 10 days | **Total Files Created/Modified:** 40+

---

## SUCCESS METRICS

### Code Quality

| Metric | Before | After | Target |
|--------|--------|-------|--------|
| Lines of hook code | 123 | 80 | <80 |
| Code duplication | 65% | 15% | <20% |
| Cyclomatic complexity | 8 | 3 | <5 |
| Test coverage | 0% | 85% | >80% |

### Developer Experience

| Metric | Before | After | Target |
|--------|--------|-------|--------|
| Time to understand | 20 min | 5 min | <10 min |
| Time to setup | 15 min | 5 min | <10 min |
| Documentation files | 3 | 10 | >8 |
| Examples provided | 0 | 10+ | >5 |

### Maintainability

| Metric | Before | After |
|--------|--------|-------|
| Source of truth for logging | 3 places | 1 place |
| Hook validation method | Manual | Automated |
| Version tracking | None | Manifest + tags |
| Dependency management | Implicit | Explicit |

---

## TECHNICAL DEBT ADDRESSED

| Category | Issue | Severity | Solution |
|----------|-------|----------|----------|
| **Code** | Duplication in hooks | HIGH | Shared library |
| **Code** | No test coverage | HIGH | Test framework |
| **Docs** | Scattered content | HIGH | Consolidation |
| **Repo** | Log files tracked | MEDIUM | .gitignore |
| **Repo** | No hook registry | MEDIUM | Manifest system |
| **Org** | Unclear structure | MEDIUM | Std directories |
| **Names** | Inconsistent conventions | MEDIUM | Naming standards |
| **Eng** | No CI/CD | LOW | GitHub Actions |
| **Eng** | No version mgmt | LOW | package.json |

---

## MIGRATION CHECKLIST

### Pre-Migration
- [ ] Backup current .claude/ directory
- [ ] Document all custom hook configurations
- [ ] Create git branch for refactoring

### Directory Creation
- [ ] mkdir -p docs/_assets
- [ ] mkdir -p hooks/{lib,hooks/{_disabled,_archived},logic}
- [ ] mkdir -p tests/{unit,integration,fixtures/{hook-inputs,expected-outputs}}
- [ ] mkdir -p scripts configs examples

### File Migration
- [ ] Copy CLAUDE.md → docs/CONTEXT.md
- [ ] Copy claude-code-findings.md → docs/HOOKS_REFERENCE.md
- [ ] Copy hook-cascade-patterns.md → docs/CASCADES.md
- [ ] Move pretooluse-task-logger.sh → hooks/hooks/pretooluse-task-spawn.sh
- [ ] Move posttooluse-file-tracker.sh → hooks/hooks/posttooluse-file-changes.sh
- [ ] Move subagent-stop-validator.sh → hooks/hooks/subagent-stop-validate.sh
- [ ] Move .claude/settings.json → hooks/settings.json
- [ ] Move test.js → tests/unit/test-math.js

### New Files
- [ ] Create README.md (root)
- [ ] Create CONTRIBUTING.md
- [ ] Create docs/01-SETUP.md through docs/ARCHITECTURE.md
- [ ] Create hooks/lib/hooks-base.sh
- [ ] Create hooks/lib/json-parser.py
- [ ] Create hooks/hooks.manifest.json
- [ ] Create tests/test-runner.sh
- [ ] Create .gitignore
- [ ] Create .github/workflows/test-and-lint.yml

### Validation
- [ ] All hooks execute without errors
- [ ] All tests pass
- [ ] Documentation builds without errors
- [ ] Git status shows clean working tree

---

## EXPECTED OUTCOMES

**Code Metrics:**
- 123 → 80 lines (35% reduction)
- 65% → 15% duplication (77% improvement)
- 0% → 85% test coverage
- 3 → 10 documentation files

**Quality Improvements:**
- Centralized logging logic
- Unified naming conventions
- Comprehensive test suite
- Professional documentation
- Automated validation

**Developer Benefits:**
- 5-minute setup process
- Clear contribution guidelines
- Working code examples
- Troubleshooting guide
- Automated testing

---

**Plan prepared:** November 11, 2025  
**Estimated completion:** November 21-23, 2025  
**Total effort:** ~40-50 hours across 10 days

