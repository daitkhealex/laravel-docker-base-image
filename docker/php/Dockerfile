FROM composer:latest AS composer
FROM php:8.4-fpm

# Set environment variables for composer
ENV COMPOSER_HOME $HOME/.config/composer
ENV COMPOSER_CACHE_DIR $HOME/.cache/composer

# Set environment variables
ENV PHP_OPCACHE_ENABLE=1
ENV PHP_OPCACHE_ENABLE_CLI=0
ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS=0
ENV PHP_OPCACHE_REVALIDATE_FREQ=0

# Copy configuration files.
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
COPY conf/ "$PHP_INI_DIR/conf.d"

# COMPOSER
COPY --from=composer /usr/bin/composer /usr/bin/composer

# TIMEZONE
RUN rm -f /etc/localtime \
    && ln -sf /usr/share/zoneinfo/Asia/Almaty /etc/localtime \
    && echo 'Asia/Almaty' > /etc/timezone

# PHP EXTENSIONS
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod uga+x /usr/local/bin/install-php-extensions \
    && sync \
    && install-php-extensions --cleanup gd intl pdo_pgsql soap zip bcmath pcntl gmp opcache

# wkhtmltopdf
RUN apt-get update \
    && apt-get install -y --no-install-recommends wget unzip fontconfig \
        libfontenc1 libjpeg62-turbo libx11-6 libx11-data libxau6 libxcb1 \
        libxdmcp6 libxext6 libxrender1 x11-common xfonts-75dpi \
        xfonts-base xfonts-encodings xfonts-utils postgresql-client

RUN pecl install --force redis \
    && rm -rf /tmp/pear \
    && docker-php-ext-enable redis


RUN wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.0g-2ubuntu4_amd64.deb -O libssl1.1_1.1.0g-2ubuntu4_amd64.deb \
    && dpkg -i libssl1.1_1.1.0g-2ubuntu4_amd64.deb

RUN wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-2/wkhtmltox_0.12.6.1-2.bullseye_amd64.deb -O wkhtmltox_0.12.6-1.buster_amd64.deb \
    && dpkg -i wkhtmltox_0.12.6-1.buster_amd64.deb

# SUPERVISOR
COPY supervisord.conf /etc/supervisord.conf

RUN apt-get install -y --no-install-recommends supervisor

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
