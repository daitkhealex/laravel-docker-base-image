FROM composer:latest AS composer
FROM php:7.4-fpm

# GLOBAL ENVIROMENT
ENV PHPREDIS_VERSION 3.0.0
ENV COMPOSER_HOME $HOME/.config/composer
ENV COMPOSER_CACHE_DIR $HOME/.cache/composer

# COMPOSER
COPY --from=composer /usr/bin/composer /usr/bin/composer

# TIMEZONE
RUN rm -f /etc/localtime \
    && ln -sf /usr/share/zoneinfo/Asia/Almaty /etc/localtime \
    && echo 'Asia/Almaty' > /etc/timezone

# PHP EXTENSIONS
ADD https://raw.githubusercontent.com/mlocati/docker-php-extension-installer/master/install-php-extensions /usr/local/bin/
RUN chmod uga+x /usr/local/bin/install-php-extensions \
    && sync \
    && install-php-extensions --cleanup gd intl pdo_pgsql soap zip bcmath

# REDIS
RUN mkdir -p /usr/src/php/ext/redis \
    && curl -L https://github.com/phpredis/phpredis/archive/$PHPREDIS_VERSION.tar.gz | tar xvz -C /usr/src/php/ext/redis --strip 1 \
    && echo 'redis' >> /usr/src/php-available-exts \
    && docker-php-ext-install redis

# wkhtmltopdf
RUN set -eux \
    && apt-get update \
    && apt-get install -y --no-install-recommends wget unzip fontconfig \
        libfontenc1 libjpeg62-turbo libx11-6 libx11-data libxau6 libxcb1 \
        libxdmcp6 libxext6 libxrender1 x11-common xfonts-75dpi \
        xfonts-base xfonts-encodings xfonts-utils

#Noto sans SC Fonts
RUN wget https://fonts.google.com/download?family=Noto%20Sans%20SC -O Noto_Sans_SC.zip \
    && unzip Noto_Sans_SC.zip -d /usr/share/fonts \
    && fc-cache

RUN wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.buster_amd64.deb -O wkhtmltox_0.12.6-1.buster_amd64.deb \
    && dpkg -i wkhtmltox_0.12.6-1.buster_amd64.deb

# SUPERVISOR
COPY supervisord.conf /etc/supervisord.conf

RUN apt-get update \
    && apt-get install -y --no-install-recommends supervisor

COPY start.sh /usr/local/bin/start

#Clean up useless dependency packages
RUN set -eux \
    && apt-get autoremove \
    && apt-get autoclean \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 9000

WORKDIR /var/www

CMD ["/usr/local/bin/start"]
