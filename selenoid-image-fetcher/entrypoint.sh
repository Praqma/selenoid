#!/bin/bash
set -euo pipefail

PULL_PERIOD=60

: ${PULL_WAIT_PERIOD:=}

main() {

  if [ -n "$PULL_WAIT_PERIOD" ]; then
    PULL_PERIOD="${PULL_WAIT_PERIOD}"
  fi

  while true
    do
      echo "INFO: Pulling browser images defined in browser.json."
      cat /config/browsers.json | jq -r '..|.image?|strings' | xargs -I{} docker pull {}
      echo "INFO: Will wait ${PULL_PERIOD} seconds between pulls of images."
      sleep "${PULL_PERIOD}" & wait $!
    done
}

trap "exit 0" SIGINT SIGTERM SIGQUIT;

main "$@"