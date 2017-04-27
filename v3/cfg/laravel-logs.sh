#!/usr/bin/env bash
cat $LARAVEL_LOG_STREAM | stdbuf -oL sed 's#INFO#\x1b[32m&\x1b[0m#; s#NOTICE#\x1b[1;32m&\x1b[0m#; s#WARNING#\x1b[1;33m&\x1b[0m#; s#ERROR#\x1b[1;31m&\x1b[0m#; s#CRITICAL#\x1b[1;31m&\x1b[0m#; s#ALERT#\x1b[1;31m&\x1b[0m#; s#EMERGENCY#\x1b[1;31m&\x1b[0m#'
