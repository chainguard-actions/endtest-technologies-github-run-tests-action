<!-- markdownlint-disable -->

# Hardening Report: endtest-technologies--github-run-tests-action/v1.10

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **endtest-technologies--github-run-tests-action/v1.10** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): The `run:` block in the `endtest_functional_tests` step directly interpolates `${{ github.action_path }}` inside the shell command string: `bash "${{ github.action_path }}/test.sh"`. Any `${{ ... }}` expression inside a `run:` block is substituted by the YAML template engine before the shell processes it, making this a script-injection risk. The fix is to use the pre-set environment variable `$GITHUB_ACTION_PATH` instead: `bash "$GITHUB_ACTION_PATH/test.sh"`.

Locations:

- `action.yml:109`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

Replaced `${{ github.action_path }}` with `$GITHUB_ACTION_PATH` in the `run:` block of the `endtest_functional_tests` step in action.yml (line 109). GitHub Actions pre-sets the `GITHUB_ACTION_PATH` environment variable to the same value, so this is a safe, equivalent substitution that eliminates the template-engine interpolation risk.

