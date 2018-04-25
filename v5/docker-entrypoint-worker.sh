#!/bin/bash

set -e

function die () {
    echo -e >&2 "\e[91m$@\e[0m"
    exit 1
}

if [ "$MODE" == "cron" ]; then
  chmod 777 /dev/console
  crontab -u www-data /var/laravel-cron
  exec cron -f -L 15
else
  exec gosu www-data "$@"
fi

