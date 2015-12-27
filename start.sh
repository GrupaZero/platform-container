#!/bin/bash

function die () {
    echo >&2 "$@"
    exit 1
}

if [ $OVERRIDE_UMASK ]; then
    echo $OVERRIDE_UMASK | grep -E -q '^[0-7]{3}$' || die "Not valid umask"
    umask $OVERRIDE_UMASK
    echo -e "umask \e[91m$OVERRIDE_UMASK\e[0m"
else
    echo -e "umask \e[91m022\e[0m"
fi

/usr/bin/supervisord -n -c /etc/supervisord.conf
