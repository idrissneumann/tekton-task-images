#!/bin/sh

[ -z "${TEKTON_NAMESPACE}" ] && TEKTON_NAMESPACE="tekton-pipelines"
[ -z "${BUILD_ID}" ] && BUILD_ID="not_mandatory"

kubectl -n "${TEKTON_NAMESPACE}" get pipelineruns|awk '{if ($2 = "Unknown" && $3 ~ "Running" && $1 ~ "'"${PROJECT_NAME}"'.*" && !($1 ~ ".*'"${BUILD_ID}"'")){print $1}}'|while read pipeline; do
    [ "${LOG_LEVEL}" = "debug" ] || [ "${LOG_LEVEL}" = "DEBUG" ] && echo "[kill-redundant-pipelines][debug] Checking branch for ${pipeline}..."
    branch=$(kubectl -n "${TEKTON_NAMESPACE}" get pipelineruns "${pipeline}" -o json|jq -r '.spec.params | map(select(.name ==  "gitBranchName")) | .[] .value')
    
    if [ "${branch}" = "${GIT_BRANCH}" ]; then
        echo "[kill-redundant-pipelines] Killing ${pipeline} because branch=${branch}..."
        kubectl -n "${TEKTON_NAMESPACE}" delete pipelineruns "${pipeline}"
    fi
done
