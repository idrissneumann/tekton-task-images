#!/bin/sh

if [ -z "${PIPELINE_TARGET_URL}" ]; then
  export PIPELINE_TARGET_URL="${PIPELINE_URL}"
fi

/set-status.py
/slack-result-sender.py
