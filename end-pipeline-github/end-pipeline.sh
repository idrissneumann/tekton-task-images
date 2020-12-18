#!/bin/sh

/set-status.py
/slack-result-sender.py

if [ "${ENABLE_DESTROY_PVC}" = "enabled" ]; then
    /destroy-pvc.sh
fi

exit 0
