#!/usr/bin/env bash
trap "kill $(($BASHPID+1))" INT
tail --pid=$(($BASHPID+1)) -f $LARAVEL_LOG_STREAM | sed -u 's#INFO#\x1b[32m&\x1b[0m#; s#NOTICE#\x1b[1;32m&\x1b[0m#; s#WARNING#\x1b[1;33m&\x1b[0m#; s#ERROR#\x1b[1;31m&\x1b[0m#; s#CRITICAL#\x1b[1;31m&\x1b[0m#; s#ALERT#\x1b[1;31m&\x1b[0m#; s#EMERGENCY#\x1b[1;31m&\x1b[0m#'