#!/bin/sh

export SLACK_COLOR="#87CEEB"
export SLACK_USERNAME="Tekton"
export SLACK_EMOJI_AVATAR=":tekton:"
export COMMENT="${SLACK_MSG}"
export PIPELINE_TARGET_URL="${PIPELINE_URL}"
export DEFAULT_PIPELINE_STATE="pending"
[ -z "${STATUS_DESCRIPTION}" ] && export STATUS_DESCRIPTION="build in progress"
[ -z "${STATUS_CONTEXT}" ] && export STATUS_CONTEXT="continuous-integration/tekton"

/bin/sh /fetch-sources.sh

json_manifest="${TEKTON_WORKSPACE_PATH}/manifest.json"
if [[ -f "${json_manifest}" ]]; then
  manifest="$(cat "${json_manfest}")"
  export SLACK_MSG="Pipeline in progress : ${manifest}, follow here: ${PIPELINE_URL}"
else
  export SLACK_MSG="Pipeline in progress, follow here: ${PIPELINE_URL}"
fi
python3 /slack-sender.py
