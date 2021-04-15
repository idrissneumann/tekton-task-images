#!/bin/bash

[[ ! -d "${ROOT_WORKSPACE_DIR}" ]] && export ROOT_WORKSPACE_DIR="/workspace"
if [[ ! -d "${ROOT_WORKSPACE_DIR}" ]]; then
  echo "[fetch.sh] ROOT_WORKSPACE_DIR=${ROOT_WORKSPACE_DIR} doesn't exists as a directory"
  exit 1
fi

[[ ! -d "${GIT_WORKSPACE_PATH}" ]] && export GIT_WORKSPACE_PATH="${ROOT_WORKSPACE_DIR}/git-input"
[[ ! -d "${GITOPS_WORKSPACE_PATH}" ]] && export GITOPS_WORKSPACE_PATH="${ROOT_WORKSPACE_DIR}/git-${REPO_ORG}-${REPO_NAME}-${GIT_SRC_BRANCH}"
[[ ! -d "${GITOPS_WORKSPACE_PATH}" ]] && export GITOPS_WORKSPACE_PATH="${ROOT_WORKSPACE_DIR}/git-${REPO_ORG}-${REPO_NAME}"
[[ ! -d "${GITOPS_WORKSPACE_PATH}" ]] && export GITOPS_WORKSPACE_PATH="${ROOT_WORKSPACE_DIR}/gitops-input"

fetch() {
  git_workspace_var="${1}"
  git_workspace_val="${2}"
  git_src_branch="${3}"

  if [[ ! -d "${git_workspace_val}" ]]; then
    echo "[fetch] ${git_workspace_var}=${git_workspace_val} doesn't exists as a directory"
    exit 1
  fi

  if [[ $LOG_LEVEL == "debug" || $LOG_LEVEL == "DEBUG" ]]; then
    echo "[fetch] Content of ${git_workspace_var}=${git_workspace_val} before fetch"
    ls -la "${git_workspace_val}"
  fi

  cd "${git_workspace_val}"
  git pull

  if [[ ! $git_src_branch ]]; then
    echo "[fetch] git_src_branch=${git_src_branch} is not a valid branch"
    exit 1
  fi

  git checkout "${git_src_branch}"
  git pull --rebase origin "${git_src_branch}"

  if [[ $LOG_LEVEL == "debug" || $LOG_LEVEL == "DEBUG" ]]; then
    echo "[fetch] Content of ${git_workspace_var}=${git_workspace_val} after fetch"
    ls -la "${git_workspace_val}"
  fi
}

fetch "GIT_WORKSPACE_PATH" "${GIT_WORKSPACE_PATH}" "${GIT_BRANCH}"
fetch "GITOPS_WORKSPACE_PATH" "${GITOPS_WORKSPACE_PATH}" "${GIT_TARGET_BRANCH}"
