#!/bin/bash

set -e

function die() {
  echo -e "\e[91m$@\e[0m" >&2
  exit 1
}

if [ "$MODE" == "cron" ]; then
  crontab /var/laravel-cron
  exec cron -f -L 15
else
  exec gosu www-data "$@"
fi
