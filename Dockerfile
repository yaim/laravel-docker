FROM php:7.3.11-fpm-buster

ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /var/www

RUN apt-get update && apt-get install -y \
    apt-utils

RUN apt-get install -y \
    build-essential \
    mariadb-client \
    libpq-dev \
    libzip-dev \
    libxml2-dev \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    bash-completion \
    curl

RUN docker-php-ext-install \
    pdo_mysql \
    pdo_pgsql \
    mbstring \
    zip \
    exif \
    pcntl \
    soap \
    gd

RUN apt -y autoremove

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN addgroup --gid 1000 www
RUN adduser -uid 1000 --shell /bin/bash --disabled-password --gecos "" --gid 1000 www

RUN chown www:www ./

USER www

EXPOSE 9000

CMD ["php-fpm"]
