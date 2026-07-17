#!/bin/sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
MANIFEST="$ROOT/source/remote-resources.txt"
SUB_STORE_VERSION=$(jq -er '.subStore' "$ROOT/source/versions.json")
failed=0
pids=''

while IFS='|' read -r name url tier clients <&3; do
  case "$name" in
    ''|'#'*) continue ;;
  esac

  url=$(printf '%s' "$url" | sed "s/{{SUB_STORE_VERSION}}/$SUB_STORE_VERSION/g")

  (
    status=$(/usr/bin/curl -L --retry 2 --retry-all-errors --max-time 30 --connect-timeout 8 -s -o /dev/null -w '%{http_code}' "$url" </dev/null || true)
    if [ "$status" = 200 ]; then
      printf 'OK   %s [%s: %s]\n' "$name" "$tier" "$clients"
    else
      printf 'FAIL %s returned HTTP %s\n' "$name" "${status:-transport-error}" >&2
      exit 1
    fi
  ) &
  pids="$pids $!"
done 3< "$MANIFEST"

for pid in $pids; do
  if ! wait "$pid"; then
    failed=1
  fi
done

exit "$failed"
