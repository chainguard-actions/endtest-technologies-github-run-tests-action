<!-- markdownlint-disable -->

# Hardening Report: endtest-technologies--github-run-tests-action/v1.6

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **endtest-technologies--github-run-tests-action/v1.6** was hardened automatically. 6 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): The `run:` block on line 62 directly interpolates `${{ github.action_path }}` inside a shell command string. GitHub Actions performs template substitution before the shell ever sees the value, so any expression in `${{ ... }}` is a script-injection risk.

Offending line:
  `run: sudo chmod +x ${{ github.action_path }}/test.sh`

Locations:

- `action.yml:62`

### script-injection (severity: high)

Sub-rule (a) and (b): The `run:` block on line 64 directly interpolates multiple `${{ ... }}` expressions — `${{ github.action_path }}`, `${{ inputs.app_id }}`, `${{ inputs.app_code }}`, `${{ inputs.api_request }}`, and `${{ inputs.number_of_loops }}` — inside a shell command string. This allows an attacker-controlled input to inject arbitrary shell commands before the shell ever parses the string.

Additionally (sub-rule b), `${{ inputs.app_id }}`, `${{ inputs.app_code }}`, and `${{ inputs.number_of_loops }}` are passed as unquoted positional arguments, allowing shell metacharacter injection even if they were moved to env vars.

Offending line:
  `run: ${{ github.action_path }}/test.sh ${{ inputs.app_id }} ${{ inputs.app_code }} "${{ inputs.api_request }}" ${{ inputs.number_of_loops }}`

Locations:

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

Fixed all script injection vulnerabilities in action.yml:
1. chmod step (line 62): Moved `${{ github.action_path }}` to an `env:` block as `ACTION_PATH`, then referenced it as `"$ACTION_PATH/test.sh"` in the run command.
2. test.sh execution step (lines 64/67): Moved all five ${{ }} expressions (`github.action_path`, `inputs.app_id`, `inputs.app_code`, `inputs.api_request`, `inputs.number_of_loops`) to an `env:` block as `ACTION_PATH`, `APP_ID`, `APP_CODE`, `API_REQUEST`, and `NUMBER_OF_LOOPS` respectively. All variables are double-quoted in the run command to prevent word splitting and shell metacharacter injection.

### Iteration 2

**Fixes applied:** invalid-yaml

**Notes:**

Fixed YAML parsing error at line 66 in action.yml. The `run:` value `"$ACTION_PATH/test.sh" "$APP_ID" "$APP_CODE" "$API_REQUEST" "$NUMBER_OF_LOOPS"` was invalid YAML because YAML parsed the leading `"$ACTION_PATH/test.sh"` as a complete quoted scalar and rejected the trailing arguments. Converted to a block scalar using `run: |` so the entire command line is treated as a literal string.

