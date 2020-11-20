#!/bin/sh

export SLACK_COLOR="#87CEEB"
export SLACK_USERNAME="tekton"
export SLACK_EMOJI_AVATAR=":tekton:"
export SLACK_MSG="Pipeline in progress, follow here: ${PIPELINE_URL}"
export COMMENT="${SLACK_MSG}"
export PIPELINE_TARGET_URL="${PIPELINE_URL}"
export DEFAULT_PIPELINE_STATE="pending"
[ -z "${STATUS_DESCRIPTION}" ] && export STATUS_DESCRIPTION="build in progress"
[ -z "${STATUS_CONTEXT}" ] && export STATUS_CONTEXT="continuous-integration/tekton"

/bin/sh /search.sh
python3 /set-status.py
python3 /slack-sender.py
python3 /add-comment.py
/bin/sh /fetch-sources.sh
