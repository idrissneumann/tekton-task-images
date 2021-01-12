#!/bin/sh

INPUT_FILE="${TEKTON_WORKSPACE_PATH}/${YAML_INPUT_FILE_PATH}"

echo "[yaml-patch] patching ${INPUT_FILE} with ${YQ_EXPRESSION}"

yq e "${YQ_EXPRESSION}" -i "${INPUT_FILE}"

if [ "${LOG_LEVEL}" = "debug" ] || [ "${LOG_LEVEL}" = "DEBUG" ]; then
    echo "[yaml-patch][debug] content of ${INPUT_FILE} after patch:"
    cat "${INPUT_FILE}"
fi
