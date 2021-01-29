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
/slack-start.sh
