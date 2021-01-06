#!/bin/sh

# Constants
API_VERSION="v3"
GITHUB_HOST_URL="api.github.com"

VERBOSE_OPT=""
if [ "${LOG_LEVEL}" = "debug" ] || [ "${LOG_LEVEL}" = "DEBUG" ]; then
  VERBOSE_OPT="-v"
fi

curl -X POST -H "Authorization: Bearer ${GITHUBTOKEN}"  \
    -H "Accept: application/vnd.github.${API_VERSION}+json" \ 
    "${GITHUB_HOST_URL}/repos/${REPO_ORG}/${REPO_NAME}/pulls" \
    ${VERBOSE_OPT} \
    -d '{"title":"'"${PR_TITLE}"'", "head":"'"${GIT_SRC_BRANCH}"'","base":"'"${GIT_TARGET_BRANCH}"'", "owner":"'"${REPO_ORG}"'", "repo":"'"${REPO_NAME}"'"}'
