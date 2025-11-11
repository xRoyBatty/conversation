---
name: security-auditor
description: Performs comprehensive security audit of codebase with structured output, external CVE lookups, and deterministic analysis workflow. Use when user requests security audit or vulnerability assessment.
---

# Security Auditor Skill

Conduct a comprehensive security audit following a deterministic, structured workflow that produces consistent, actionable results.

## CRITICAL: This skill enforces a specific workflow Claude would NOT follow naturally

**Key behaviors enforced by this skill:**
1. **ALWAYS create a TODO list first** using TodoWrite tool with ALL audit phases
2. **MUST check external CVE database** via WebSearch for dependency vulnerabilities
3. **MUST use specific output format** with emoji markers (🔴 Critical, 🟡 Warning, 🟢 Pass)
4. **MUST create files** in `.security/` directory (Claude normally avoids creating directories)
5. **MUST generate structured JSON report** (Claude typically gives prose summaries)

## Mandatory Workflow (Execute in Exact Order)

### Phase 1: Initialize Audit Structure

**REQUIRED ACTIONS:**
1. Use TodoWrite to create complete task list for all 8 phases
2. Create `.security/` directory if it doesn't exist
3. Create `.security/audit-YYYY-MM-DD.json` with timestamp
4. Mark Phase 1 as in_progress, then completed

### Phase 2: Dependency Analysis

**REQUIRED ACTIONS:**
1. Mark Phase 2 as in_progress
2. Find ALL dependency files (package.json, requirements.txt, Cargo.toml, go.mod, etc.)
3. For EACH dependency manager found:
   - Extract ALL package names and versions
   - **MANDATORY**: Use WebSearch to check "[package-name] CVE vulnerability" for top 5 dependencies
   - Record CVE IDs found (format: CVE-YYYY-NNNNN)
4. Write findings to `.security/dependencies.json` in this EXACT format:

```json
{
  "scan_timestamp": "ISO-8601",
  "managers_found": ["npm", "pip"],
  "total_packages": 42,
  "vulnerabilities": [
    {
      "package": "package-name",
      "version": "1.2.3",
      "cve_ids": ["CVE-2023-12345"],
      "severity": "CRITICAL|HIGH|MEDIUM|LOW",
      "source": "NVD|GitHub Advisory"
    }
  ]
}
```

5. Mark Phase 2 as completed

### Phase 3: Secret Scanning

**REQUIRED ACTIONS:**
1. Mark Phase 3 as in_progress
2. Use Grep to search for patterns:
   - `password.*=.*['"]\w+['"]` (case insensitive)
   - `api[_-]?key.*=.*['"]\w+['"]` (case insensitive)
   - `secret.*=.*['"]\w+['"]` (case insensitive)
   - `token.*=.*['"]\w+['"]` (case insensitive)
   - Private keys: `BEGIN.*PRIVATE.*KEY`
3. For each match, record file:line
4. Write to `.security/secrets.json`
5. Mark Phase 3 as completed

### Phase 4: Code Pattern Analysis

**REQUIRED ACTIONS:**
1. Mark Phase 4 as in_progress
2. Search for dangerous patterns:
   - SQL injection: `execute.*\+.*|query.*%.*|SELECT.*\+`
   - XSS: `innerHTML.*=|dangerouslySetInnerHTML`
   - Command injection: `exec\(|system\(|shell_exec`
   - Path traversal: `\.\./|path\.join.*\.\./`
3. Write findings to `.security/code-issues.json`
4. Mark Phase 4 as completed

### Phase 5: Configuration Review

**REQUIRED ACTIONS:**
1. Mark Phase 5 as in_progress
2. Check for insecure configurations:
   - CORS: Look for `Access-Control-Allow-Origin: *`
   - Debug mode: Search for `DEBUG.*=.*True|debug.*:.*true`
   - Weak crypto: Search for `MD5|SHA1` (flag if used for security)
3. Write to `.security/config-issues.json`
4. Mark Phase 5 as completed

### Phase 6: Generate Severity Report

**REQUIRED ACTIONS:**
1. Mark Phase 6 as in_progress
2. Create `.security/AUDIT-REPORT.md` with this EXACT structure:

```markdown
# Security Audit Report

**Generated**: YYYY-MM-DD HH:MM UTC
**Auditor**: Claude Security Auditor Skill v1.0
**Repository**: [repo-name]

## Executive Summary

- 🔴 Critical Issues: X
- 🟡 High Priority: X
- 🟢 Passed Checks: X

## Critical Findings

### 🔴 [Issue Title]
- **Category**: Dependencies | Secrets | Code | Config
- **Severity**: Critical
- **Location**: file:line
- **CVE ID**: CVE-YYYY-NNNNN (if applicable)
- **Remediation**: Specific action to take

[Repeat for each critical issue]

## High Priority Findings

[Same format as Critical]

## All Checks Performed

✅ Dependency vulnerability scan (via external CVE database)
✅ Secret scanning (5 pattern types)
✅ Code pattern analysis (4 vulnerability classes)
✅ Configuration review (3 security categories)

## Recommendations

[Ordered by priority]
```

3. Mark Phase 6 as completed

### Phase 7: Generate Machine-Readable Report

**REQUIRED ACTIONS:**
1. Mark Phase 7 as in_progress
2. Consolidate ALL findings into `.security/audit-YYYY-MM-DD.json`:

```json
{
  "audit_metadata": {
    "timestamp": "ISO-8601",
    "skill_version": "1.0",
    "phases_completed": 7
  },
  "summary": {
    "critical": 0,
    "high": 0,
    "medium": 0,
    "low": 0
  },
  "findings": [
    {
      "id": "FINDING-001",
      "severity": "CRITICAL|HIGH|MEDIUM|LOW",
      "category": "DEPENDENCY|SECRET|CODE|CONFIG",
      "title": "Brief description",
      "location": "file:line",
      "cve_id": "CVE-YYYY-NNNNN or null",
      "remediation": "Specific action"
    }
  ],
  "external_lookups_performed": ["NVD CVE search for top 5 dependencies"]
}
```

3. Mark Phase 7 as completed

### Phase 8: Commit Results

**REQUIRED ACTIONS:**
1. Mark Phase 8 as in_progress
2. Stage ALL files in `.security/` directory
3. Commit with message: "Security audit completed - [X] critical, [Y] high priority findings"
4. Mark Phase 8 as completed
5. Mark ALL todos as completed

## Final Output Format

After completing all phases, provide user with:

```
🔒 Security Audit Complete

📊 Results Summary:
   🔴 Critical: X
   🟡 High: X
   🟢 Passed: X

📁 Reports Generated:
   - .security/AUDIT-REPORT.md (Human-readable)
   - .security/audit-YYYY-MM-DD.json (Machine-readable)
   - .security/dependencies.json (Dependency analysis)
   - .security/secrets.json (Secret scan results)
   - .security/code-issues.json (Code pattern findings)
   - .security/config-issues.json (Configuration review)

🔍 External Verifications Performed:
   ✅ CVE database lookups for top dependencies

📋 Next Steps:
   1. Review .security/AUDIT-REPORT.md
   2. Address critical findings immediately
   3. Schedule remediation for high-priority items
```

## Important Notes for Claude

- **DO NOT skip WebSearch**: External CVE lookup is REQUIRED for dependency validation
- **DO NOT summarize**: Create ALL specified JSON files with complete data
- **DO NOT improvise format**: Use exact JSON schemas provided
- **DO NOT skip directory creation**: `.security/` directory is mandatory
- **DO NOT skip TodoWrite**: Task tracking is required for audit trail
- **DO NOT provide prose-only output**: Structured files are mandatory

## Differences from Normal Behavior

Without this skill, Claude would typically:
- Provide a prose summary without creating files
- Skip external CVE lookups (wouldn't think to use WebSearch)
- Not create `.security/` directory structure
- Not generate machine-readable JSON reports
- Not use TodoWrite for audit phases
- Not enforce specific emoji markers
- Not commit results automatically

**This skill enforces structured, reproducible security audits with external validation.**
