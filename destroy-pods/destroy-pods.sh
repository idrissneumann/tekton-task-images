#!/bin/sh

/init-kube-config.sh

if [ -z "$DESTROY_MODE" ]; then 
  echo DESTROY_MODE="rollout"
fi

if [ "${GIT_BRANCH}" != "develop" ] && [ "${GIT_BRANCH}" != "master" ] && ! echo "${GIT_BRANCH}"|grep -E "^[0-9]+.[0-9]+.x$" > /dev/null; then
  echo "[destroy-pods] No pod to remove because KUBE_ENV=${KUBE_ENV} and GIT_BRANCH=${GIT_BRANCH}"
  exit 0
fi

echo "[destroy-pods] Destroy pods on namespace ${NAMESPACE} that begins with ${POD_PREFIX} with mode = ${DESTROY_MODE}, delete_jobs = ${DELETE_JOBS}"

kubectl -n "$NAMESPACE" get pods|grep -E "^${POD_PREFIX}"|awk '{print $1}'|xargs kubectl -n "$NAMESPACE" "${DESTROY_MODE}" pod || :
[ "${DELETE_JOBS}" = "true" ] || [ "${DELETE_JOBS}" = "enabled" ] && kubectl -n "${NAMESPACE}" get jobs|grep -E "^${POD_PREFIX}"|awk '{print $1}'|xargs kubectl -n "${NAMESPACE}" delete job || :
[ -f ~/.kube/config.old ] && cp -f ~/.kube/config.old ~/.kube/config
