FROM ubuntu:14.04.4

MAINTAINER Adrian Skierniewski <adrian.skierniewski@gmail.com>

# Set correct environment variables
ENV HOME /root
ENV TERM xterm
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y software-properties-common --no-install-recommends && \
    LANG=C.UTF-8 add-apt-repository ppa:nginx/stable && \
    LANG=C.UTF-8 add-apt-repository ppa:ondrej/php5-5.6 && \
    apt-get update && \
    apt-get install -y \
      nano \
      htop \
      git \
      supervisor \
      nginx \
      gettext \
      curl \
      mysql-client \
      php5-fpm \
      php5-cli \
      php5-curl \
      php5-gd \
      php5-intl \
      php5-json \
      php5-ldap \
      php5-mcrypt \
      php5-mysql \
      php5-xdebug \
      php5-redis && \
    apt-get remove --purge -y software-properties-common && \
    apt-get autoremove -y && \
    apt-get clean && \
    apt-get autoclean && \
    echo -n > /var/lib/apt/extended_states && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /usr/share/man/?? && \
    rm -rf /usr/share/man/??_*

RUN php5enmod mcrypt

RUN /usr/bin/curl -sS https://getcomposer.org/installer | /usr/bin/php
RUN /bin/mv composer.phar /usr/local/bin/composer

# Nginx config
ADD ./cfg/nginx.conf /etc/nginx/nginx.conf

# PHP-FPM configs
ADD ./cfg/php-fpm.conf /etc/php5/fpm/php-fpm.conf
ADD ./cfg/php.ini /etc/php5/fpm/php.ini
ADD ./cfg/pool.d/www.conf /etc/php5/fpm/pool.d/www.conf

# Supervisor config
ADD ./cfg/supervisord.conf /etc/supervisord.conf

# Start script
ADD ./start.sh /start.sh
RUN chmod +x /start.sh

# Wrapper to run as www-data
ADD ./commandWrapper.sh /commandWrapper.sh
RUN chmod +x /commandWrapper.sh

RUN mv /var/www/html /var/www/public
RUN mv /var/www/public/index.nginx-debian.html /var/www/public/index.html
ADD ./cfg/default-site /etc/nginx/conf.d/mysite.template

EXPOSE 80

CMD ["/bin/bash", "/start.sh"]