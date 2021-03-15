#!/bin/bash

extract_pipeline_id() {
  echo ${HOSTNAME}|grep -oE "[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{8}"
}

get_pr_json_file() {
  suffix="$(extract_pipeline_id)"
  echo "${TEKTON_WORKSPACE_PATH}/prs-${suffix}.json"
}

get_pr_env_file() {
  suffix="$(extract_pipeline_id)"
  echo "${TEKTON_WORKSPACE_PATH}/pr_env-${suffix}.sh"
}
