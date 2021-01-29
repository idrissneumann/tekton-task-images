#!/bin/sh

[ -z "${YARN_INSTALL}" ] && YARN_INSTALL="disabled"
[ -z "${TARGET}" ] && TARGET="only_install"

if [ "${LOG_LEVEL}" = "debug" ] || [ "${LOG_LEVEL}" = "DEBUG" ]; then
  echo "[yarn-check][success][debug] target = ${TARGET}, opt = ${INSTALL_EXTRA_OPT}"
  echo "[yarn-check][success][debug] Show the occuped space of workspace"
  du -sh "${TEKTON_WORKSPACE_PATH}"
fi

rtn=0
if [ "${YARN_INSTALL}" = "enabled" ]; then
  yarn install $INSTALL_EXTRA_OPT
  rtn=$?
fi

if [ $rtn -eq 0 ] && [ "${LOG_LEVEL}" = "debug" ] || [ "${LOG_LEVEL}" = "DEBUG" ]; then
  echo "[yarn-check][success][debug] Show the occuped space of workspace"
  du -sh "${TEKTON_WORKSPACE_PATH}"
fi

if [ $rtn -eq 0 ] && [ ! -z "${TARGET}" ] && [ "${TARGET}" != "only_install" ]; then
  yarn $TARGET
  rtn=$?
fi

exit $rtn
