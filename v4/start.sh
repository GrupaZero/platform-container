#!/bin/bash

function die () {
    echo >&2 "$@"
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

HOST=${DEFAULT_HOST:-localhost}

echo $HOST | grep -E -q '^localhost$|^([a-z0-9]+(-[a-z0-9]+)*\.)+[a-z]{2,}$' || die "Not valid domain"
echo -e "nginx_host: \e[91m$HOST\e[0m"

# Using dev version of site.conf if present
# It should only work on dev, because during build we're ignoring _server dir
if [ -e "/var/www/.server/nginx/site.conf" ]; then
  sed -e "s/{{DEFAULT_HOST}}/$HOST/g" "/var/www/.server/nginx/site.conf" > /etc/nginx/sites-available/default
else
  sed -e "s/{{DEFAULT_HOST}}/$HOST/g" "/etc/nginx/conf.d/site.template" > /etc/nginx/sites-available/default
fi

/usr/bin/supervisord -n -c /etc/supervisord.conf
