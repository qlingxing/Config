#!/bin/sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
TEMPORARY=$(mktemp "${TMPDIR:-/tmp}/config-urls.XXXXXX")
trap 'rm -f "$TEMPORARY"' EXIT HUP INT TERM

set -- \
  "$ROOT/QuantumultX/qlingxing.conf" \
  "$ROOT/Surge/macOS/Surge-6.conf" \
  "$ROOT/Surge/iOS/Surge-6.conf" \
  "$ROOT/Surge/Module/Surge.sgmodule" \
  "$ROOT/Surge/Module/spotify.module" \
  "$ROOT/Surge/Modules/BiliBili-AdBlock.sgmodule" \
  "$ROOT/Surge/Modules/Emby-Public-Experimental.sgmodule" \
  "$ROOT/Loon/Loon.conf" \
  "$ROOT/Loon/Plugins/Sub-Store.plugin" \
  "$ROOT/Loon/Plugins/Spotify-Enhance.plugin" \
  "$ROOT/Loon/Plugins/YouTube-AdBlock.plugin" \
  "$ROOT/Loon/Plugins/BiliBili-Enhance.plugin" \
  "$ROOT/Loon/Plugins/Emby-Public-Experimental.plugin"

awk '
  !/^[[:space:]]*(#|;|\/\/)/ && /https?:\/\// {
    while (match($0, /https?:\/\/[^,[:space:]"`)]*/)) {
      print substr($0, RSTART, RLENGTH)
      $0 = substr($0, RSTART + RLENGTH)
    }
  }
' "$@" | sort -u > "$TEMPORARY"

failed=0

if ! xargs -n 1 -P 8 sh -c '
  root=$1
  url=$2

  case "$url" in
    *dns-query|*generate_204|https://sub-store.vercel.app|http://substore.stash|https://substore.stash)
      printf "SKIP endpoint %s\\n" "$url"
      exit 0
      ;;
    https://raw.githubusercontent.com/qlingxing/Config/main/*)
      local_path=${url#https://raw.githubusercontent.com/qlingxing/Config/main/}
      if [ -f "$root/$local_path" ]; then
        printf "LOCAL %s\\n" "$local_path"
        exit 0
      fi
      printf "FAIL missing local source %s\\n" "$local_path" >&2
      exit 1
      ;;
  esac

  status=$(/usr/bin/curl -L --retry 2 --retry-all-errors --max-time 30 --connect-timeout 8 -s -o /dev/null -w "%{http_code}" "$url" </dev/null || true)
  if [ "$status" = 200 ]; then
    printf "OK   %s\\n" "$url"
  else
    printf "FAIL HTTP %s %s\\n" "${status:-transport-error}" "$url" >&2
    exit 1
  fi
' sh "$ROOT" < "$TEMPORARY"; then
  failed=1
fi

exit "$failed"
