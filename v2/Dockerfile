FROM ubuntu:16.04

MAINTAINER Adrian Skierniewski <adrian.skierniewski@gmail.com>

# Set correct environment variables
ENV HOME /root
ENV TERM xterm
ENV DEBIAN_FRONTEND noninteractive
ENV COMPOSER_ALLOW_SUPERUSER 1

RUN apt-get update && \
    apt-get install -y software-properties-common --no-install-recommends && \
    LANG=C.UTF-8 add-apt-repository ppa:nginx/stable && \
    LANG=C.UTF-8 add-apt-repository ppa:ondrej/php && \
    apt-get update && \
    apt-get install -y \
      sudo \
      nano \
      htop \
      git \
      supervisor \
      nginx \
      gettext \
      curl \
      mysql-client \
      php7.0-fpm \
      php7.0-cli \
      php7.0-common \
      php7.0-curl \
      php7.0-gd \
      php7.0-intl \
      php7.0-json \
      php7.0-ldap \
      php7.0-mcrypt \
      php7.0-mbstring \
      php7.0-mysql \
      php7.0-pgsql \
      php7.0-opcache \
      php7.0-xdebug \
      php7.0-xml \
      php7.0-redis \
      php7.0-zip && \
    apt-get remove --purge -y software-properties-common && \
    apt-get autoremove -y && \
    apt-get clean && \
    apt-get autoclean && \
    echo -n > /var/lib/apt/extended_states && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /usr/share/man/?? && \
    rm -rf /usr/share/man/??_*

# Nginx config
ADD ./cfg/nginx.conf /etc/nginx/nginx.conf

# PHP-FPM configs
ADD ./cfg/php-fpm.conf /etc/php/7.0/fpm/php-fpm.conf
ADD ./cfg/php.ini /etc/php/7.0/fpm/php.ini
ADD ./cfg/pool.d/www.conf /etc/php/7.0/fpm/pool.d/www.conf
ADD ./cfg/xdebug.ini ./etc/php/7.0/mods-available/xdebug.ini

# Supervisor config
ADD ./cfg/supervisord.conf /etc/supervisord.conf

# Start script
ADD ./start.sh /start.sh

# Add site templates
ADD ./cfg/mysite /etc/nginx/conf.d/mysite.template
ADD ./cfg/mysite-ssl /etc/nginx/conf.d/mysite-ssl.template

RUN phpenmod mcrypt \
  && /usr/bin/curl -sS https://getcomposer.org/installer | /usr/bin/php \
  && /bin/mv composer.phar /usr/local/bin/composer \
  && chmod +x /start.sh \
  && mv /var/www/html /var/www/public \
  && mv /var/www/public/index.nginx-debian.html /var/www/public/index.html

EXPOSE 80 443

CMD ["/bin/bash", "/start.sh"]
