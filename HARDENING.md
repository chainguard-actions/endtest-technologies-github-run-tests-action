<!-- markdownlint-disable -->

# Hardening Report: endtest-technologies--github-run-tests-action/v1.10

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `1`

Action **endtest-technologies--github-run-tests-action/v1.10** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): A GitHub Actions expression `${{ github.action_path }}` is interpolated directly inside a `run:` shell command string in action.yml. The offending line is: `bash "${{ github.action_path }}/test.sh"`. Any `${{ ... }}` expression inside a `run:` block is a script-injection risk because the value is substituted by the YAML template engine before the shell ever sees it, bypassing shell quoting. The fix is to use the `$GITHUB_ACTION_PATH` environment variable instead: `bash "$GITHUB_ACTION_PATH/test.sh"`.

Locations:

- `action.yml:100`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

Replaced `${{ github.action_path }}` with `$GITHUB_ACTION_PATH` in the `run:` block of action.yml (line 100). The `$GITHUB_ACTION_PATH` environment variable is set by GitHub Actions and is safe to use directly in shell scripts, whereas the `${{ ... }}` template expression is substituted before the shell sees it, creating a script-injection risk.

