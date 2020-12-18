#!/bin/sh

[ -z "${PIPELINE_TARGET_URL}" ] && export PIPELINE_TARGET_URL="${PIPELINE_URL}"

/set-status.py
/slack-result-sender.py
