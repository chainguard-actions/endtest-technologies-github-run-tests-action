#!/bin/sh
# Mock curl for polling test scenario
# Call 1: returns hash
# Call 2+: returns results JSON
count=$(cat /tmp/curl_call_count 2>/dev/null || echo 0)
count=$((count + 1))
echo "$count" > /tmp/curl_call_count

out=""
prev=""
for arg in "$@"; do
  case "$prev" in
    -o|--output) out="$arg" ;;
  esac
  prev="$arg"
done

if [ "$count" -eq 1 ]; then
  payload="hashxyz789poll"
else
  payload='{"test_suite_name":"Polling Test Suite","configuration":"Firefox on macOS","test_cases":3,"passed":2,"failed":1,"errors":0,"detailed_logs":"Step 3 failed","screenshots_and_video":"https://endtest.io/screenshots/xyz789","start_time":"2024-01-02 09:00:00","end_time":"2024-01-02 09:03:00"}'
fi

if [ -n "$out" ]; then
  printf '%s\n' "$payload" > "$out"
else
  printf '%s\n' "$payload"
fi
exit 0
