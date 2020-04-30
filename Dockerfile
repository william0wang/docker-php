FROM php:7.4.5-fpm-alpine3.11

USER root

RUN apk --update add --no-cache curl gcc autoconf  libc-dev make libressl-dev pcre-dev zlib-dev linux-headers gnupg \
libxslt-dev gd-dev geoip-dev perl-dev openssh-client libcurl augeas-dev ca-certificates dialog musl-dev libmcrypt-dev \
libpng-dev icu-dev libpq libffi-dev freetype-dev libjpeg-turbo-dev ca-certificates libressl curl-dev g++ zip unzip \
autoconf imagemagick-dev libtool make pcre-dev screen git && \
apk add gnu-libiconv --update-cache --repository https://dl-cdn.alpinelinux.org/alpine/edge/testing/ --allow-untrusted
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

RUN docker-php-ext-install mysqli json sockets opcache pdo_mysql &&\
docker-php-ext-enable mysqli json sockets opcache pdo_mysql

ADD www.conf /usr/local/etc/php-fpm.d/www.conf
# ADD error.conf /usr/local/etc/php-fpm.d/error.conf

RUN docker-php-ext-install pcntl &&  docker-php-ext-install bcmath && docker-php-ext-enable bcmath && \
docker-php-ext-install gd

RUN apk --update add libzip libzip-dev && \
docker-php-ext-install zip

RUN pecl install http://pecl.php.net/get/mcrypt-1.0.3.tgz && docker-php-ext-enable mcrypt
RUN pecl install http://pecl.php.net/get/redis-5.2.1.tgz && docker-php-ext-enable redis
RUN pecl install http://pecl.php.net/get/imagick-3.4.4.tgz && docker-php-ext-enable imagick
RUN pecl install http://pecl.php.net/get/mongodb-1.7.4.tgz && docker-php-ext-enable mongodb
