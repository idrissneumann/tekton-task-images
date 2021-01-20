#!/bin/bash

# Constants
API_VERSION="v3"
GITHUB_HOST_URL="api.github.com"

VERBOSE_OPT=""
if [[ $LOG_LEVEL == "debug" || $LOG_LEVEL == "DEBUG" ]]; then
  VERBOSE_OPT="-v"
fi

suffix=$(echo ${HOSTNAME}|sed 's/\(.*\)-.*/\1/;s/\-open//g;s/\-//g')
pr_json_file="${TEKTON_WORKSPACE_PATH}/prs-open-${suffix}.json"
endpoint="https://${GITHUB_HOST_URL}/repos/${REPO_ORG}/${REPO_NAME}/pulls"
body='{"title":"'"${PR_TITLE}"'", "head":"'"${GIT_SRC_BRANCH}"'","base":"'"${GIT_TARGET_BRANCH}"'", "owner":"'"${REPO_ORG}"'", "repo":"'"${REPO_NAME}"'"}'
auth_header="Authorization: Bearer ${GITHUBTOKEN}"
accept_header="Accept: application/vnd.github.${API_VERSION}+json"

[[ $GIT_BRANCH && $AUTO_MERGE_GIT_BRANCH ]] && echo "[github-open-pr] Auto-merge is enabled with GIT_BRANCH=${GIT_BRANCH} and ${AUTO_MERGE_GIT_BRANCH}"

curl ${VERBOSE_OPT} -X POST "${endpoint}" -H "${auth_header}" -H "${accept_header}" -d "${body}"

if [[ ! $GIT_BRANCH || ! $AUTO_MERGE_GIT_BRANCH || $GIT_BRANCH != $AUTO_MERGE_GIT_BRANCH ]]; then
  echo "[github-open-pr] Auto-merge is disabled with GIT_BRANCH=${GIT_BRANCH} and ${AUTO_MERGE_GIT_BRANCH}"
  exit 0
fi

state="open"
search_pr_end_point="${GITHUB_HOST_URL}/search/issues"
search_pr_query="q=type:pr+repo:${REPO_ORG}%2F${REPO_NAME}+state:${STATE}+head:${GIT_SRC_BRANCH}"
json_query=".items[]|{title: .title,internal_id : .id,url: .url}"
curl -H "${auth_header}" -H "${accept_header}" "${search_pr_end_point}?${search_pr_query}"|jq -cr "${json_query}" > $pr_json_file
if [[ ! -f "${pr_json_file}" ]]; then
  echo "[github-open-pr] pr_json_file=${pr_json_file} doesn't exists"
  exit 1
fi

if [[ $LOG_LEVEL == "debug" || $LOG_LEVEL == "DEBUG" ]]; then
  echo "[github-open-pr][debug] Content of pr_json_file=${pr_json_file}"
  cat "${pr_json_file}"
fi

id="$(head -n1 $pr_json_file|jq -cr ".url"|awk -F "/" '{print $NF}')"
echo "[github-open-pr] Auto-merge pr id=${id}"
merge_endpoint="${endpoint}/${id}/merge"
merge_body='{"commit_title":"'"${PR_TITLE}"'"}'
curl ${VERBOSE_OPT} -X PUT "${merge_endpoint}" -H "${auth_header}" -H "${accept_header}" -d "${merge_body}"

exit 0
