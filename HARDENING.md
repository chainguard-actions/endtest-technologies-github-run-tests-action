<!-- markdownlint-disable -->

# Hardening Report: endtest-technologies--github-run-tests-action/v1.7

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `1`

Action **endtest-technologies--github-run-tests-action/v1.7** was hardened automatically. 5 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a) violation: User-controlled inputs are directly interpolated via ${{ }} expressions into a run: shell command in action.yml (line 64). The expressions ${{ inputs.app_id }}, ${{ inputs.app_code }}, ${{ inputs.api_request }}, and ${{ inputs.number_of_loops }} are passed as unquoted shell arguments (except api_request which is double-quoted but still interpolated). An attacker calling this composite action can inject arbitrary shell commands through any of these inputs. Additionally, ${{ github.action_path }} is interpolated directly in run: blocks on lines 62 and 64.

Locations:

- `action.yml:62`
- `action.yml:64`

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

Fixed all script injection vulnerabilities in action.yml by moving all ${{ }} expressions out of run: shell commands and into env: blocks. Specifically: (1) In the chmod step, moved ${{ github.action_path }} to env: as ACTION_PATH and updated the run command to use "$ACTION_PATH/test.sh". (2) In the main test step, moved ${{ github.action_path }}, ${{ inputs.app_id }}, ${{ inputs.app_code }}, ${{ inputs.api_request }}, and ${{ inputs.number_of_loops }} to env: as ACTION_PATH, APP_ID, APP_CODE, API_REQUEST, and NUMBER_OF_LOOPS respectively, and updated the run command to reference these environment variables with proper double-quoting.

### Iteration 2

**Fixes applied:** invalid-yaml

**Notes:**

Fixed invalid YAML on line 66 of action.yml. The `run:` field had a value starting with a double-quoted string (`"$ACTION_PATH/test.sh"`), which YAML parsed as a complete quoted scalar and rejected the trailing arguments (`"$APP_ID" "$APP_CODE" "$API_REQUEST" "$NUMBER_OF_LOOPS"`). Converted the single-line run: to a block scalar using `|` so the entire command is treated as a literal string, resolving the YAML parse error.

