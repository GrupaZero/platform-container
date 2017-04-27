#!/usr/bin/env bash
pipe=$LARAVEL_LOG_STREAM

while true
do
    if read line <$pipe; then
        if [[ "$line" == 'quit' ]]; then
            break
        fi
        echo $line | sed 's#INFO#\x1b[32m&\x1b[0m#; s#NOTICE#\x1b[1;32m&\x1b[0m#; s#WARNING#\x1b[1;33m&\x1b[0m#; s#ERROR#\x1b[1;31m&\x1b[0m#; s#CRITICAL#\x1b[1;31m&\x1b[0m#; s#ALERT#\x1b[1;31m&\x1b[0m#; s#EMERGENCY#\x1b[1;31m&\x1b[0m#'
    fi
done
