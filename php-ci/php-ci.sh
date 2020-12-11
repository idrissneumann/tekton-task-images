#!/bin/sh

cd "${TEKTON_WORKSPACE_PATH}"

[ -z "${SRC_DIR}" ] && SRC_DIR="src/"
[ -z "${PSALM_FILE}" ] && PSALM_FILE="psalm.xml"

if [ "${LOG_LEVEL}" = "debug" ] || [ "${LOG_LEVEL}" = "DEBUG" ]; then
  echo "[php-ci][debug] Show the occuped space of workspace"
  du -sh "${TEKTON_WORKSPACE_PATH}"
  echo "[php-ci][debug] SRC_DIR=${SRC_DIR}, ENABLE_COMPOSER_INSTALL=${ENABLE_COMPOSER_INSTALL}, ENABLE_PHPCS=${ENABLE_PHPCS}, ENABLE_PSALM=${ENABLE_PSALM}, ENABLE_PHPUNIT=${ENABLE_PHPUNIT}"
fi


if [ "${ENABLE_COMPOSER_INSTALL}" == "enabled" ]; then
    echo "[php-ci] run composer install --prefer-dist --no-progress --no-suggest"
    composer install --prefer-dist --no-progress --no-suggest
fi

if [ "${ENABLE_PHPCS}" == "enabled" ]; then
    echo "[php-ci] run ./vendor/bin/phpcs ${SRC_DIR}"
    ./vendor/bin/phpcs ${SRC_DIR}
fi

if [ "${ENABLE_PSALM}" == "enabled" ]; then
    echo "[php-ci] run ./vendor/bin/psalm -c=${PSALM_FILE}"
    ./vendor/bin/psalm -c=${PSALM_FILE}
fi

if [ "${ENABLE_PHPUNIT}" == "enabled" ]; then
    echo "[php-ci] run ./vendor/bin/phpunit"
    ./vendor/bin/phpunit
fi
