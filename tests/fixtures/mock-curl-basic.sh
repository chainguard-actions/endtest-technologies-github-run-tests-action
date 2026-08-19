#!/bin/sh
# Mock curl for basic test scenario
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
  payload="abc123fakehash"
else
  payload='{"test_suite_name":"My Test Suite","configuration":"Chrome on Windows 10","test_cases":5,"passed":5,"failed":0,"errors":0,"detailed_logs":"No errors","screenshots_and_video":"https://endtest.io/screenshots/abc123","start_time":"2024-01-01 10:00:00","end_time":"2024-01-01 10:05:00"}'
fi

if [ -n "$out" ]; then
  printf '%s\n' "$payload" > "$out"
else
  printf '%s\n' "$payload"
fi
exit 0
