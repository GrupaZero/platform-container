# Platform docker containers

This repository contains two containers

## platform-web-container
Docker web container for GZERO platform

- v5 - PHP 7.2, Nginx

#### Available env variables (v5):
  - **XDEBUG** *(default: false)*
  - **OVERRIDE_UMASK** *(default: 022)*
  - **NGINX_HOST** *(default: localhost)*
  
## platform-worker-container

- v5 - PHP 7.2, Cron

#### Available env variables (v5):
  - **XDEBUG** *(default: false)*
  - **OVERRIDE_UMASK** *(default: 022)*
  - **MODE** *(cron)* Run cron worker instead queue worker