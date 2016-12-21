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

if [ $SSL ]; then
  SSL="-ssl"
  echo -e "ssl: \e[91menabled\e[0m"
else
  SSL=""
  echo -e "ssl: \e[91mdisabled\e[0m"
fi

if [ $XDEBUG ]; then
  phpenmod xdebug
  echo -e "xdebug: \e[91menabled\e[0m"
else
  phpdismod xdebug
  echo -e "xdebug: \e[91mdisabled\e[0m"
fi

if [ $NGINX_HOST ]; then
    echo $NGINX_HOST | grep -E -q '^([a-z0-9]+(-[a-z0-9]+)*\.)+[a-z]{2,}$' || die "Not valid domain"
    sed -e "s/_NGINX_HOST/$NGINX_HOST/g" "/etc/nginx/conf.d/mysite$SSL.template" > /etc/nginx/sites-available/default
    echo -e "nginx_host: \e[91m$NGINX_HOST\e[0m"
else
    sed -e "s/_NGINX_HOST/localhost/g" "/etc/nginx/conf.d/mysite$SSL.template" > /etc/nginx/sites-available/default
    echo -e "nginx_host: \e[91mlocalhost\e[0m"
fi

/usr/bin/supervisord -n -c /etc/supervisord.conf
