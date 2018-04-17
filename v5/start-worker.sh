#!/bin/bash

function die () {
    echo -e >&2 "\e[91m$@\e[0m"
    exit 1
}

if [ $OVERRIDE_UMASK ]; then
    echo $OVERRIDE_UMASK | grep -E -q '^[0-7]{3}$' || die "Not valid umask"
    umask $OVERRIDE_UMASK
    echo -e "umask: \e[91m$OVERRIDE_UMASK\e[0m"
else
    echo -e "umask: \e[91m022\e[0m"
fi

if [ "$XDEBUG" == "true" ]; then
  phpenmod xdebug
  echo -e "xdebug: \e[91menabled\e[0m"
else
  phpdismod xdebug
  echo -e "xdebug: \e[91mdisabled\e[0m"
fi

if [ "$MODE" == "horizon" ]; then
  crontab -u www-data /var/laravel-cron
  su - www-data -s /bin/sh -c "php /var/www/artisan horizon"
elif [ "$MODE" == "cron" ]; then
  cron -f -L 15
else
  die 'Error: not supported mode (use horizon or cron)'
fi

