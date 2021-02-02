#!/bin/bash

/init-kube-config.sh

[[ $DESTROY_MODE ]] || export DESTROY_MODE="rollout"

if [[ ! $GIT_BRANCH =~ ^([0-9]+.[0-9]+.x|master|develop|main|prod|qa)$ ]]; then
  echo "[destroy-pods] No pod to remove because KUBE_ENV=${KUBE_ENV} and GIT_BRANCH=${GIT_BRANCH}"
  exit 0
fi

echo "[destroy-pods] Destroy pods on namespace ${NAMESPACE} that begins with ${POD_PREFIX} with mode = ${DESTROY_MODE}, delete_jobs = ${DELETE_JOBS}"

kind="deployments"
cmd=("rollout" "restart" "${kind}")
if [[ "${DESTROY_MODE}" = "delete" ]]; then
  kind="pods"
  cmd=("delete" "${kind}")
fi

kubectl -n "${NAMESPACE}" get "${kind}"|grep -E "^${POD_PREFIX}"|while read -r res trash; do
  kubectl -n "${NAMESPACE}" ${cmd[@]} "${res}" || :
done

if [[ $DELETE_JOBS = "true" || $DELETE_JOBS = "enabled" ]]; then
  kubectl -n "${NAMESPACE}" get jobs|grep -E "^${POD_PREFIX}"|while read -r res trash; do
    kubectl -n "${NAMESPACE}" delete job "${res}" || :
  done
fi

[[ -f ~/.kube/config.old ]] && cp -f ~/.kube/config.old ~/.kube/config

exit 0
