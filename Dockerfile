FROM php:7.4.5-cli-alpine3.11

USER root

RUN apk --update add --no-cache curl gcc autoconf libc-dev make libressl-dev pcre-dev zlib-dev linux-headers gnupg \
libxslt-dev gd-dev geoip-dev perl-dev openssh-client libcurl augeas-dev ca-certificates dialog musl-dev libmcrypt-dev \
libpng-dev icu-dev libpq libffi-dev freetype-dev libjpeg-turbo-dev ca-certificates libressl curl-dev g++ zip unzip \
autoconf imagemagick-dev libtool make pcre-dev screen git && \
apk add gnu-libiconv --update-cache --repository https://dl-cdn.alpinelinux.org/alpine/edge/testing/ --allow-untrusted
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

RUN docker-php-ext-install mysqli json sockets opcache pdo_mysql &&\
docker-php-ext-enable mysqli json sockets opcache pdo_mysql

RUN docker-php-ext-install pcntl &&  docker-php-ext-install bcmath && docker-php-ext-enable bcmath && \
docker-php-ext-install gd

RUN apk --update add libzip libzip-dev && \
docker-php-ext-install zip

RUN pecl install http://pecl.php.net/get/mcrypt-1.0.3.tgz && docker-php-ext-enable mcrypt
RUN pecl install http://pecl.php.net/get/redis-5.2.1.tgz && docker-php-ext-enable redis
RUN pecl install http://pecl.php.net/get/imagick-3.4.4.tgz && docker-php-ext-enable imagick
# RUN pecl install http://pecl.php.net/get/mongodb-1.7.4.tgz && docker-php-ext-enable mongodb
# RUN pecl install http://pecl.php.net/get/protobuf-3.11.4.tgz && docker-php-ext-enable protobuf && \
# pecl install http://pecl.php.net/get/grpc-1.28.0.tgz && docker-php-ext-enable grpc

RUN mkdir -p ~/build/tmp && \
cd ~/build && \
rm -rf ./swoole-src && \
curl -o ./tmp/swoole.tar.gz https://github.com/swoole/swoole-src/archive/v4.5.2.tar.gz -L && \
tar zxvf ./tmp/swoole.tar.gz && \
mv swoole-src* swoole-src && \
cd swoole-src && \
phpize && \
./configure \
--enable-openssl  \
--enable-http2 && \
make && make install

RUN chmod -R  755  /usr/local/etc/php

RUN cp  /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini

RUN echo "extension=swoole.so" >> /usr/local/etc/php/php.ini
RUN mkdir -p /usr/local/work && chmod -R  755  /usr/local/work

CMD ["/usr/local/work/run.sh"]
