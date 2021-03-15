#!/bin/bash

source /env_file_utils.sh
pr_env_file="$(get_pr_env_file)"

sed -i "s/^\(export PIPELINE_STATE=\).*/\1\"success\"/g" $pr_env_file

if [[ $LOG_LEVEL == "debug" || $LOG_LEVEL == "DEBUG" ]]; then
  echo "[state-success][success] Content of $pr_env_file :"
  cat $pr_env_file
fi
