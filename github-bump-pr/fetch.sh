#!/bin/bash

[[ ! -d "${GIT_WORKSPACE_PATH}" ]] && export GIT_WORKSPACE_PATH="/workspaces/gitops-input"
[[ ! -d "${GIT_WORKSPACE_PATH}" ]] && export GIT_WORKSPACE_PATH="/workspaces/git-${REPO_ORG}-${REPO_NAME}-${GIT_SRC_BRANCH}"
[[ ! -d "${GIT_WORKSPACE_PATH}" ]] && export GIT_WORKSPACE_PATH="/workspaces/git-${REPO_ORG}-${REPO_NAME}"

if [[ ! -d "${GIT_WORKSPACE_PATH}" ]]; then
  echo "[github-bump-pr][fetch.sh] GIT_WORKSPACE_PATH=${GIT_WORKSPACE_PATH} doesn't exists as a directory"
  exit 1
fi

if [[ $LOG_LEVEL == "debug" || $LOG_LEVEL == "debug" ]]; then
  echo "[github-bump-pr][fetch.sh] Content of GIT_WORKSPACE_PATH=${GIT_WORKSPACE_PATH} before fetch"
  ls -la "${GIT_WORKSPACE_PATH}"
fi

git pull
git checkout "${GIT_SRC_BRANCH}"
git pull --rebase origin "${GIT_SRC_BRANCH}"

if [[ $LOG_LEVEL == "debug" || $LOG_LEVEL == "debug" ]]; then
  echo "[github-bump-pr][fetch.sh] Content of GIT_WORKSPACE_PATH=${GIT_WORKSPACE_PATH} after fetch"
  ls -la "${GIT_WORKSPACE_PATH}"
fi
