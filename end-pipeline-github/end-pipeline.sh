#!/bin/sh

[ -z "${PIPELINE_TARGET_URL}" ] && PIPELINE_TARGET_URL="${PIPELINE_URL}"

/set-status.py
/slack-result-sender.py

if [ "${ENABLE_DESTROY_PVC}" = "enabled" ]; then
    /destroy-pvc.sh
fi

exit 0
