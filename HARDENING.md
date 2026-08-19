<!-- markdownlint-disable -->

# Hardening Report: endtest-technologies--github-run-tests-action/v1.5

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **endtest-technologies--github-run-tests-action/v1.5** was hardened automatically. 5 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): Two `run:` blocks in action.yml directly interpolate GitHub Actions expressions into shell command strings, enabling script injection.

1. Line 63: `run: sudo chmod +x ${{ github.action_path }}/test.sh` — `${{ github.action_path }}` is substituted directly into the shell command before the shell parses it.

2. Line 65: `run: ${{ github.action_path }}/test.sh ${{ inputs.app_id }} ${{ inputs.app_code }} "${{ inputs.api_request }}" ${{ inputs.number_of_loops }}` — All four inputs (`app_id`, `app_code`, `api_request`, `number_of_loops`) are attacker-controlled values interpolated directly into the shell command string. An attacker can supply a value like `; malicious-command #` to execute arbitrary shell commands on the runner.

Fix: Move all inputs into `env:` variables and reference them as quoted shell variables (e.g., `"$APP_ID"`), never interpolating `${{ inputs.* }}` directly inside a `run:` block.

Locations:

- `action.yml:63`
- `action.yml:65`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.app_id }}" appears directly in run: block of step ""; move to env: map

Locations:

- `action.yml:67`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.app_code }}" appears directly in run: block of step ""; move to env: map

Locations:

- `action.yml:67`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.api_request }}" appears directly in run: block of step ""; move to env: map

Locations:

- `action.yml:67`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.number_of_loops }}" appears directly in run: block of step ""; move to env: map

Locations:

- `action.yml:67`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, static-inline-injection

**Notes:**

Fixed all script injection vulnerabilities in action.yml and test.sh: (1) action.yml chmod step: replaced `${{ github.action_path }}` with `$GITHUB_ACTION_PATH` (pre-set env var). (2) action.yml test execution step: moved all four inputs (app_id, app_code, api_request, number_of_loops) into an `env:` block as APP_ID, APP_CODE, API_REQUEST, NUMBER_OF_LOOPS; the `run:` line now only references `$GITHUB_ACTION_PATH/test.sh` with no inline `${{ }}` expressions. (3) test.sh: updated to use the new environment variables instead of positional arguments ($1→$APP_ID, $2→$APP_CODE, $3→$API_REQUEST, $4→$NUMBER_OF_LOOPS); also fixed the bash brace expansion `{1.."${4}"}` (which does not expand variables) to `$(seq 1 "${NUMBER_OF_LOOPS}")`.

