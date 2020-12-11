ARG PHP_VERSION
ARG COMPOSER_VERSION

FROM composer:${COMPOSER_VERSION} AS composer

FROM php:${PHP_VERSION}-cli-alpine AS php_ci

COPY --from=composer /usr/bin/composer /usr/local/bin/composer

COPY php-ci.sh /

RUN chmod +x /php-ci.sh

CMD [ "/php-ci.sh" ]
