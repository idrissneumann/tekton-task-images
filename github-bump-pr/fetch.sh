#!/bin/bash

[[ ! -d "${ROOT_WORKSPACE_DIR}" ]] && export ROOT_WORKSPACE_DIR="/workspace"
if [[ ! -d "${ROOT_WORKSPACE_DIR}" ]]; then
  echo "[fetch.sh] ROOT_WORKSPACE_DIR=${ROOT_WORKSPACE_DIR} doesn't exists as a directory"
  exit 1
fi

[[ ! -d "${GIT_WORKSPACE_PATH}" ]] && export GIT_WORKSPACE_PATH="${ROOT_WORKSPACE_DIR}/git-${REPO_ORG}-${REPO_NAME}-${GIT_SRC_BRANCH}"
[[ ! -d "${GIT_WORKSPACE_PATH}" ]] && export GIT_WORKSPACE_PATH="${ROOT_WORKSPACE_DIR}/git-${REPO_ORG}-${REPO_NAME}"
[[ ! -d "${GIT_WORKSPACE_PATH}" ]] && export GIT_WORKSPACE_PATH="${ROOT_WORKSPACE_DIR}/gitops-input"

if [[ ! -d "${GIT_WORKSPACE_PATH}" ]]; then
  echo "[fetch] GIT_WORKSPACE_PATH=${GIT_WORKSPACE_PATH} doesn't exists as a directory"
  exit 1
fi

if [[ $LOG_LEVEL == "debug" || $LOG_LEVEL == "DEBUG" ]]; then
  echo "[fetch] Content of GIT_WORKSPACE_PATH=${GIT_WORKSPACE_PATH} before fetch"
  ls -la "${GIT_WORKSPACE_PATH}"
fi

cd "${GIT_WORKSPACE_PATH}"
git pull

if [[ ! $GIT_SRC_BRANCH ]]; then
  echo "[fetch] GIT_SRC_BRANCH=${GIT_SRC_BRANCH} is not a valid branch"
  exit 1
fi

git checkout "${GIT_SRC_BRANCH}"
git pull --rebase origin "${GIT_SRC_BRANCH}"

if [[ $LOG_LEVEL == "debug" || $LOG_LEVEL == "DEBUG" ]]; then
  echo "[fetch] Content of GIT_WORKSPACE_PATH=${GIT_WORKSPACE_PATH} after fetch"
  ls -la "${GIT_WORKSPACE_PATH}"
fi
