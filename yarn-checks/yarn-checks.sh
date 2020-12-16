#!/bin/sh

[ -z "${YARN_INSTALL}" ] && YARN_INSTALL="disabled"
[ -z "${TARGET}" ] && TARGET="only_install"

if [ "${LOG_LEVEL}" = "debug" ] || [ "${LOG_LEVEL}" = "DEBUG" ]; then
  echo "[yarn-ci][success][debug] target = ${TARGET}, opt = ${INSTALL_EXTRA_OPT}"
  echo "[yarn-ci][success][debug] Show the occuped space of workspace"
  du -sh "${TEKTON_WORKSPACE_PATH}"
fi

if [ "${YARN_INSTALL}" = "enabled" ]; then
  yarn install $INSTALL_EXTRA_OPT
fi

if [ "${LOG_LEVEL}" = "debug" ] || [ "${LOG_LEVEL}" = "DEBUG" ]; then
  echo "[yarn-ci][success][debug] Show the occuped space of workspace"
  du -sh "${TEKTON_WORKSPACE_PATH}"
fi

if [ ! -z "${TARGET}" ] && [ "${TARGET}" != "only_install" ]; then
  yarn $TARGET
fi
