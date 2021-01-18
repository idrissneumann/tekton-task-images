#!/bin/bash

# Constants
API_VERSION="v3"
GITHUB_HOST_URL="api.github.com"

VERBOSE_OPT=""
if [[ $LOG_LEVEL == "debug" || $LOG_LEVEL == "DEBUG" ]]; then
  VERBOSE_OPT="-v"
fi

endpoint="https://${GITHUB_HOST_URL}/repos/${REPO_ORG}/${REPO_NAME}/pulls"
body='{"title":"'"${PR_TITLE}"'", "head":"'"${GIT_SRC_BRANCH}"'","base":"'"${GIT_TARGET_BRANCH}"'", "owner":"'"${REPO_ORG}"'", "repo":"'"${REPO_NAME}"'"}'
auth_header="Authorization: Bearer ${GITHUBTOKEN}"
accept_header="Accept: application/vnd.github.${API_VERSION}+json"

[[ $GIT_BRANCH && $AUTO_MERGE_GIT_BRANCH ]] && echo "[github-open-pr] Auto-merge is enabled with GIT_BRANCH=${GIT_BRANCH} and ${AUTO_MERGE_GIT_BRANCH}"

if [[ ! $GIT_BRANCH || ! $AUTO_MERGE_GIT_BRANCH || $GIT_BRANCH != $AUTO_MERGE_GIT_BRANCH ]]; then
  curl ${VERBOSE_OPT} -X POST "${endpoint}" -H "${auth_header}" -H "${accept_header}" -d "${body}"
else
  id=$(curl -X POST "${endpoint}" -H "${auth_header}" -H "${accept_header}" -d "${body}"|jq -r .id)
  merge_endpoint="${endpoint}/${id}/merge"
  merge_body='{"commit_title":"'"${PR_TITLE}"'"}'
  curl ${VERBOSE_OPT} -X PUT "${merge_endpoint}" -H "${auth_header}" -H "${accept_header}" -d "${merge_body}"
fi

exit 0
