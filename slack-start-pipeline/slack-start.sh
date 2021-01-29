#!/bin/sh

json_manifest="${TEKTON_WORKSPACE_PATH}/manifest.json"
if [ -f "${json_manifest}" ]; then
  manifest=$(cat "${json_manifest}")
  export SLACK_MSG="Pipeline in progress : ${manifest}, follow here: ${PIPELINE_URL}"
else
  export SLACK_MSG="Pipeline in progress, follow here: ${PIPELINE_URL}"
fi
python3 /slack-sender.py
