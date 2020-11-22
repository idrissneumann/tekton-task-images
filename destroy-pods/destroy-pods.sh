#!/bin/bash

/init-kube-config.sh

if [[ $GIT_BRANCH != "develop" && $GIT_BRANCH != "master" ]] && ! echo "$GIT_BRANCH"|grep -E "^[0-9]+.[0-9]+.x$" > /dev/null; then
  echo "[destroy-pods] No pod to remove because KUBE_ENV=${KUBE_ENV} and GIT_BRANCH=${GIT_BRANCH}"
  exit 0
fi

kubectl -n "$NAMESPACE" get pods|grep -E "^${POD_PREFIX}"|awk '{print $1}'|xargs kubectl -n "$NAMESPACE" delete pod || :
[[ -f ~/.kube/config.old ]] && cp -f ~/.kube/config.old ~/.kube/config
