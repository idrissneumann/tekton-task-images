#!/bin/sh

[ -z "${TEKTON_NAMESPACE}" ] && TEKTON_NAMESPACE="tekton-pipelines"
[ -z "${BUILD_ID}" ] && BUILD_ID="not_mandatory"
[ -z "${DESTROY_PVC}" ] && DESTROY_PVC="disabled"

/init-kube-config.sh

kubectl -n "${TEKTON_NAMESPACE}" get pipelineruns|awk '{if ($2 = "Unknown" && $3 ~ "Running" && $1 ~ "'"${PROJECT_NAME}"'.*" && !($1 ~ ".*'"${BUILD_ID}"'")){print $1}}'|while read pipeline; do
  if [ "${LOG_LEVEL}" = "debug" ] || [ "${LOG_LEVEL}" = "DEBUG" ]; then
    echo "[kill-redundant-pipelines][debug] Checking branch for ${pipeline}..."
  fi
  
  branch=$(kubectl -n "${TEKTON_NAMESPACE}" get pipelineruns "${pipeline}" -o json|jq -r '.spec.params | map(select(.name ==  "gitBranchName")) | .[] .value')
    
  if [ "${branch}" = "${GIT_BRANCH}" ]; then
    echo "[kill-redundant-pipelines] Killing ${pipeline} because branch=${branch}..."
    tkn -n "${TEKTON_NAMESPACE}" pipelinerun cancel "${pipeline}"
  fi
done

[[ -f ~/.kube/config.old ]] && cp -f ~/.kube/config.old ~/.kube/config

exit 0
