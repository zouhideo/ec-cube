FROM php:7.1-apache

RUN set -x \
    # 高速化のためaptリポジトリを変更
    && echo "deb http://deb.debian.org/debian jessie main" > /etc/apt/sources.list \
    && echo "deb http://security.debian.org jessie/updates main" >> /etc/apt/sources.list \
    && sed -i.bak -e "s%http://deb.debian.org/debian%http://ftp.riken.jp/pub/Linux/debian/debian%g" /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        sudo \
        git \
        libxml2-dev \
        unzip \
        wget \
        zlib1g-dev \
        iproute \
        libsqlite3-dev \
        libpq-dev \
        libicu-dev \
        gnupg2 \
    && wget -qO- https://deb.nodesource.com/setup_10.x | bash - \
    && apt-get install -y --no-install-recommends \
        nodejs \
    && docker-php-ext-install \
        intl \
        mbstring \
        pdo \
        pdo_sqlite \
        pdo_mysql \
        pdo_pgsql \
        soap \
        xml \
        zip \
    && pecl install xdebug \
    && pecl install apcu \
    && docker-php-ext-enable \
        xdebug \
        apcu \
        opcache \
    && a2enmod rewrite \
    && apt-get clean \
    && rm -rf /tmp/*

RUN curl -sS https://getcomposer.org/installer \
    |  php -- \
        --filename=composer \
        --install-dir=/usr/local/bin \
    # composerの高速化
    && COMPOSER_ALLOW_SUPERUSER=1 composer global require --optimize-autoloader "hirak/prestissimo" \
    && chown www-data /var/www \
    && chmod g+s /var/www/html

COPY ./shop.ini /usr/local/etc/php/conf.d/shop.ini
COPY ./shop.conf /etc/apache2/conf-available/shop.conf
COPY ./default-ssl.conf /etc/apache2/sites-available/default-ssl.conf
COPY ./entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

RUN a2enmod ssl
RUN a2enconf shop

EXPOSE 80
EXPOSE 443
EXPOSE 9000

ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
