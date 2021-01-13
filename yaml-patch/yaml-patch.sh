#!/bin/bash

yaml_patch() {
  yq_expr="${1}"
  file_path="${2}"
  yq e "${yq_expr}" -i "${file_path}"
}

conditional_patch() {
  yq_expr="${1}"
  file_relative_path="${2}"

  if [[ "${yq_expr}" && "${file_relative_path}" ]]; then
    input_file="${TEKTON_WORKSPACE_PATH}/${file_relative_path}"
    echo "[yaml-patch] patching ${input_file} with ${yq_expr}"
    yaml_patch "${yq_expr}" "${input_file}"

    if [[ "${LOG_LEVEL}" = "debug" || "${LOG_LEVEL}" = "DEBUG" ]]; then
      echo "[yaml-patch][debug] content of ${input_file} after patch:"
      cat "${input_file}"
    fi
  fi
}

conditional_patch "${YQ_EXPRESSION}" "${YAML_INPUT_FILE_PATH}"

env|grep -E "YAML_INPUT_FILE_PATH_[0-9]+"|while read -r; do
    relative_path="$(echo $REPLY|cut -d= -f2)"
    digit="$(echo $REPLY|cut -d= -f1|grep -Eo "[0-9]+$")"
    yq_expr=$(eval "echo \$YQ_EXPRESSION_${digit}")
    if [[ "${LOG_LEVEL}" = "debug" || "${LOG_LEVEL}" = "DEBUG" ]]; then
      echo "[yaml-patch][debug] relative_path=${relative_path}, digit=${digit}, yq_expr=${yq_expr}"
    fi
    conditional_patch "${yq_expr}" "${relative_path}"
done
