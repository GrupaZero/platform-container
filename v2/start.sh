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

if [ "$SSL" == "true" ]; then
  SSL="-ssl"
  echo -e "ssl: \e[91menabled\e[0m"
else
  SSL=""
  echo -e "ssl: \e[91mdisabled\e[0m"
fi

if [ "$XDEBUG" == "true" ]; then
  phpenmod xdebug
  echo -e "xdebug: \e[91menabled\e[0m"
else
  phpdismod xdebug
  echo -e "xdebug: \e[91mdisabled\e[0m"
fi

HOST=${NGINX_HOST:-localhost}

echo $HOST | grep -E -q '^localhost$|^([a-z0-9]+(-[a-z0-9]+)*\.)+[a-z]{2,}$' || die "Not valid domain"
sed -e "s/_NGINX_HOST/$HOST/g" "/etc/nginx/conf.d/mysite$SSL.template" > /etc/nginx/sites-available/default
echo -e "nginx_host: \e[91m$HOST\e[0m"

[ -d /var/www/ssl ] || mkdir /var/www/ssl

DHPARAM="/var/www/ssl/dhparam.pem"

if [ ! -e "$DHPARAM" ]
then
  echo ""
  echo -e "\e[91mFirst start of nginx\e[0m"
  echo ""

  echo -e "\e[91mGenerating $DHPARAM with size: 2048\e[0m"
  openssl dhparam -out "$DHPARAM" 2048
  chown www-data:www-data ${DHPARAM}
fi

if [ ! -e "/var/www/ssl/ssl.crt" ] || [ ! -e "/var/www/ssl/ssl.key" ]
then
  echo ""
  echo -e "\e[91mGenerating self signed certificate\e[0m"
  openssl req -x509 -newkey rsa:4086 \
  -subj "/C=XX/ST=XXXX/L=XXXX/O=XXXX/CN=$HOST" \
  -keyout "/var/www/ssl/ssl.key" \
  -out "/var/www/ssl/ssl.crt" \
  -days 3650 -nodes -sha256
  chown www-data:www-data /var/www/ssl/ssl.*
fi

/usr/bin/supervisord -n -c /etc/supervisord.conf
