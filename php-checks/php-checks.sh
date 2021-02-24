#!/bin/sh

cd "${TEKTON_WORKSPACE_PATH}"

[ -z "${SRC_DIR}" ] && SRC_DIR="src/"
[ -z "${PSALM_FILE}" ] && PSALM_FILE="psalm.xml"
[ -z "${INSTALL_EXTRA_ARGS}" ] && INSTALL_EXTRA_ARGS="--prefer-dist --no-progress --no-suggest"
[ -z "${ENABLE_COMPOSER_INSTALL}" ] && ENABLE_COMPOSER_INSTALL="disabled"
[ -z "${ENABLE_PHPCS}" ] && ENABLE_PHPCS="disabled"
[ -z "${ENABLE_PSALM}" ] && ENABLE_PSALM="disabled"
[ -z "${ENABLE_PHPUNIT}" ] && ENABLE_PHPUNIT="disabled"
 
if [ "${LOG_LEVEL}" = "debug" ] || [ "${LOG_LEVEL}" = "DEBUG" ]; then
  echo "[php-checks][debug] Show the occuped space of workspace"
  du -sh "${TEKTON_WORKSPACE_PATH}"
  echo "[php-checks][debug] SRC_DIR=${SRC_DIR}, ENABLE_COMPOSER_INSTALL=${ENABLE_COMPOSER_INSTALL}, ENABLE_PHPCS=${ENABLE_PHPCS}, ENABLE_PSALM=${ENABLE_PSALM}, ENABLE_PHPUNIT=${ENABLE_PHPUNIT}"
fi

rtn=0
if [ "${ENABLE_COMPOSER_INSTALL}" = "enabled" ]; then
  echo "[php-checks] run composer install ${INSTALL_EXTRA_ARGS}"
  composer install ${INSTALL_EXTRA_ARGS}
  rtn=$?
fi

if [ $rtn -eq 0 ] && [ "${ENABLE_PHPCS}" = "enabled" ]; then
  echo "[php-checks] run ./vendor/bin/phpcs ${SRC_DIR}"
  ./vendor/bin/phpcs ${SRC_DIR}
  rtn=$?
fi

if [ $rtn -eq 0 ] && [ "${ENABLE_PSALM}" = "enabled" ]; then
  echo "[php-checks] run ./vendor/bin/psalm -c=${PSALM_FILE}"
  ./vendor/bin/psalm -c=${PSALM_FILE}
  rtn=$?
fi

if [ $rtn -eq 0 ] && [ "${ENABLE_PHPUNIT}" = "enabled" ]; then
  echo "[php-checks] run ./vendor/bin/phpunit"
  ./vendor/bin/phpunit
  rtn=$?
fi

exit $rtn
