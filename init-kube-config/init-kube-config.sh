#!/bin/sh

[ ! -d "~/.kube" ] && mkdir ~/.kube
[ -f "~/.kube/config" ] && cp -f ~/.kube/config ~/.kube/config.old

if [ -z "${MULTI_ENV}" ]; then
  export MULTI_ENV="disabled"
fi

if [ "${MULTI_ENV}" = "enabled" ]; then
  if [ "${GIT_BRANCH}" = "qa" ]; then
    export KUBE_ENV="${KUBE_QA_ENV}"
    export KUBE_TOKEN="${KUBE_QA_TOKEN}"
    export KUBE_URL="${KUBE_QA_URL}"
  elif [ "${GIT_BRANCH}" = "prod" ]; then
    export KUBE_ENV="${KUBE_PROD_ENV}"
    export KUBE_TOKEN="${KUBE_PROD_TOKEN}"
    export KUBE_URL="${KUBE_PROD_URL}"
  else
    export KUBE_ENV="${KUBE_DEV_ENV}"
    export KUBE_TOKEN="${KUBE_DEV_TOKEN}"
    export KUBE_URL="${KUBE_DEV_URL}"
  fi
fi

echo 'apiVersion: v1
kind: Config
clusters:
- name: "'$KUBE_ENV'"
  cluster:
    server: "'$KUBE_URL'"

users:
- name: "'$KUBE_ENV'"
  user:
    token: "'$KUBE_TOKEN'"

contexts:
- name: "'$KUBE_ENV'"
  context:
    user: "'$KUBE_ENV'"
    cluster: "'$KUBE_ENV'"

current-context: "'$KUBE_ENV'"' > ~/.kube/config
