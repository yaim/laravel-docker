FROM php:7.3.11-fpm-alpine3.10

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

WORKDIR /var/www

RUN apk add --no-cache --virtual .build-deps \
    $PHPIZE_DEPS \
    zlib-dev \
    libzip-dev \
    libxml2-dev \
    postgresql-dev \
    libpng-dev \
    php-soap

RUN apk add --no-cache \
    postgresql \
    libzip \
    libpng

RUN docker-php-ext-install \
    pdo_mysql \
    pdo_pgsql \
    mbstring \
    zip \
    exif \
    pcntl \
    soap \
    gd

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN apk del -f .build-deps

RUN addgroup -g 1000 www
RUN adduser -u 1000 -D -s /bin/bash -G www www

RUN chown www:www ./

USER www

EXPOSE 9000

CMD ["php-fpm"]
