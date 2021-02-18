#!/bin/bash

kubedir=~/.kube
kubeconf="${kubedir}/config"

[[ ! -d $kubedir ]] && mkdir $kubedir
[[ -f $kubeconf ]] && cp -f "${kubeconf}" "${kubeconf}.old"
[[ ! $MULTI_ENV ]] && export MULTI_ENV="disabled"
[[ ! $LOG_LEVEL ]] && export LOG_LEVEL="info"

export KUBE_ENV="dev"
export KUBE_CERTIFICATE=""

if [[ $MULTI_ENV == "enabled" ]]; then
  if [[ $GIT_BRANCH == "qa" ]]; then
    export KUBE_TOKEN="${KUBE_QA_TOKEN}"
    export KUBE_URL="${KUBE_QA_URL}"
    [[ $KUBE_QA_ENV ]] && export KUBE_ENV="${KUBE_QA_ENV}"
    [[ $KUBE_QA_CERTIFICATE ]] && export KUBE_CERTIFICATE="${KUBE_QA_CERTIFICATE}"
  elif [[ $GIT_BRANCH == "prod" ]]; then
    export KUBE_TOKEN="${KUBE_PROD_TOKEN}"
    export KUBE_URL="${KUBE_PROD_URL}"
    [[ $KUBE_PROD_ENV ]] && export KUBE_ENV="${KUBE_PROD_ENV}"
    [[ $KUBE_PROD_CERTIFICATE ]] && export KUBE_CERTIFICATE="${KUBE_PROD_CERTIFICATE}"
  elif [[ $GIT_BRANCH == "ppd" || $GIT_BRANCH == "preprod" ]]; then
    export KUBE_TOKEN="${KUBE_PPD_TOKEN}"
    export KUBE_URL="${KUBE_PPD_URL}"
    [[ $KUBE_PPD_ENV ]] && export KUBE_ENV="${KUBE_PPD_ENV}"
    [[ $KUBE_PPD_CERTIFICATE ]] && export KUBE_CERTIFICATE="${KUBE_PPD_CERTIFICATE}"
  else
    export KUBE_TOKEN="${KUBE_DEV_TOKEN}"
    export KUBE_URL="${KUBE_DEV_URL}"
    [[ $KUBE_DEV_ENV ]] && export KUBE_ENV="${KUBE_DEV_ENV}"
    [[ $KUBE_DEV_CERTIFICATE ]] && export KUBE_CERTIFICATE="${KUBE_DEV_CERTIFICATE}"
  fi
fi

if [[ ! $KUBE_CERTIFICATE =~ [A-Za-z0-9]+ ]]; then
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

current-context: "'$KUBE_ENV'"' > "${kubeconf}"
else
echo 'apiVersion: v1
clusters:
- name: k8s-"'$KUBE_ENV'"
  cluster:
    certificate-authority-data: "'$KUBE_CERTIFICATE'"
    server: "'$KUBE_URL'"
contexts:
- name: admin@k8s-"'$KUBE_ENV'"
  context:
    cluster: k8s-"'$KUBE_ENV'"
    user: k8s-"'$KUBE_ENV'"-admin
current-context: admin@k8s-"'$KUBE_ENV'"
kind: Config
preferences: {}
users:
- name: k8s-"'$KUBE_ENV'"-admin
  user:
    token: "'$KUBE_TOKEN'"'  > "${kubeconf}"
fi

if [[ $LOG_LEVEL == "debug" || $LOG_LEVEL == "DEBUG" ]]; then
  echo "[init-kube-config][debug] KUBE_ENV=${KUBE_ENV}"
  echo "[init-kube-config][debug] content of ${kubeconf}"
  cat "${kubeconf}"
fi
