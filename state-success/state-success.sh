#!/bin/sh

suffix=$(echo ${HOSTNAME}|sed 's/\(.*\)-.*/\1/;s/\-chec?//g;s/\-succ?//g')
pr_env_file="${TEKTON_WORKSPACE_PATH}/pr_env-${suffix}.sh"
sed -i "s/^\(export PIPELINE_STATE=\).*/\1\"success\"/g" $pr_env_file

if [ "${LOG_LEVEL}" = "debug" ] || [ "${LOG_LEVEL}" = "DEBUG" ]; then
  echo "[state-success][success] Content of $pr_env_file :"
  cat $pr_env_file
fi
