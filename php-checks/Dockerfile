ARG PHP_VERSION
ARG COMPOSER_VERSION

FROM composer:${COMPOSER_VERSION} AS composer

FROM php:${PHP_VERSION}-cli-alpine AS php_checks

COPY --from=composer /usr/bin/composer /usr/local/bin/composer

COPY php-checks.sh /

RUN chmod +x /php-checks.sh

CMD [ "/php-checks.sh" ]
