#!/bin/sh

apk add --no-cache jq
apk add --no-cache curl

# Constants
API_VERSION="v3"
GITHUB_HOST_URL="api.github.com"
STATE="open"

suffix=$(echo ${HOSTNAME}|sed 's/\(.*\)-.*/\1/;s/\-sear//g')
pr_json_file="${TEKTON_WORKSPACE_PATH}/prs-${suffix}.json"
pr_env_file="${TEKTON_WORKSPACE_PATH}/pr_env-${suffix}.sh"

export LAST_COMMIT=$(curl -H "Authorization: Bearer ${GITHUBTOKEN}" -H "Accept: application/vnd.github.${API_VERSION}+json" "https://${GITHUB_HOST_URL}/repos/${REPO_ORG}/${REPO_NAME}/commits?sha=${GIT_BRANCH}"|jq -cr ".[0].url"|awk -F "/" '{print $NF}')

curl -H "Authorization: Bearer ${GITHUBTOKEN}"  -H "Accept: application/vnd.github.${API_VERSION}+json" "${GITHUB_HOST_URL}/search/issues?q=type:pr+repo:${REPO_ORG}%2F${REPO_NAME}+state:${STATE}+head:${GIT_BRANCH}+${GIT_SHA}"|jq -cr ".items[]|{title: .title,internal_id :.id,sha:\"$LAST_COMMIT\",url: .url}" > $pr_json_file
sed -i "s/${GITHUB_HOST_URL}\/repos\(\/${REPO_ORG}\/${REPO_NAME}\)\/issues/github\.com\1\/pull/g" $pr_json_file
export LAST_PULL_REQUEST_URL="$(head -n1 $pr_json_file|jq -cr ".url")"

if [[ ! $LAST_COMMIT && ! $LAST_PULL_REQUEST_URL ]]; then
  echo "[github-search-pr] No need to continue this pipeline, no pull request or commit found: LAST_COMMIT=$LAST_COMMIT, LAST_PULL_REQUEST_URL=$LAST_PULL_REQUEST_URL"
  exit 1
fi

echo "export LAST_COMMIT=$LAST_COMMIT" > $pr_env_file
echo "export LAST_PULL_REQUEST_URL=\"${LAST_PULL_REQUEST_URL}\"" >> $pr_env_file
echo "export LAST_PULL_REQUEST_TITLE=\"$(head -n1 $pr_json_file|jq -cr ".title")\"" >> $pr_env_file
echo "export LAST_PULL_REQUEST_ID=\"$(head -n1 $pr_json_file|jq -cr ".url"|awk -F "/" '{print $NF}')\"" >> $pr_env_file
echo "export LAST_PULL_REQUEST_INTERNAL_ID=\"$(head -n1 $pr_json_file|jq -cr ".internal_id")\"" >> $pr_env_file
echo "export PIPELINE_STATE=\"failure\"" >> $pr_env_file

if [[ $LOG_LEVEL == "debug" || $LOG_LEVEL == "DEBUG" ]]; then
  echo "[github-search-pr][debug] Content of $pr_json_file :"
  cat $pr_json_file
fi

echo "[github-search-pr][info] Content of $pr_env_file :"
cat $pr_env_file

if [[ $LOG_LEVEL == "debug" || $LOG_LEVEL == "DEBUG" ]]; then
  echo "[github-search-pr][debug] Environment variables values"
  env|grep -iv token|grep -iv password
fi
