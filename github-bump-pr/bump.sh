#!/bin/bash

replace_version() {
  yq_expr_full_var="${1}"
  yq_expr_var="$(echo ${yq_expr_full_var}|cut -d= -f1)"

  if [[ "${yq_expr_var}" ]]; then
    yq_expr_val=$(eval "echo \$yq_expr_var"|sed "s/VERSION_TO_REPLACE/${VERSION}/g")
    [[ "${yq_expr_val}" ]] && export "${yq_expr_var}=${yq_expr_val}"
    if [[ $LOG_LEVEL == "debug" || $LOG_LEVEL == "DEBUG" ]]; then
      echo "[github-bump-pr][replace_version] ${yq_expr_var} = ${yq_expr_val}"
    fi
  fi
}

yamls_patch() {
  export TEKTON_WORKSPACE_PATH="${GIT_WORKSPACE_PATH}"
  if [[ ! $TEKTON_WORKSPACE_PATH ]] || [[ ! -d $TEKTON_WORKSPACE_PATH ]]; then
    echo "[yamls_patch] TEKTON_WORKSPACE_PATH=${TEKTON_WORKSPACE_PATH} is not a valid directory"
    exit 1
  fi

  replace_version "YQ_EXPRESSION=${YQ_EXPRESSION}"
  env|grep -E "YQ_EXPRESSION_[0-9]+"|while read -r; do
    replace_version "${REPLY}"
  done

  /yaml-patch.sh
}

set_version() {
  if [[ ! $GIT_WORKSPACE_PATH ]] || [[ ! -d $GIT_WORKSPACE_PATH ]]; then
    echo "[github-bump-pr][set_version] GIT_WORKSPACE_PATH=${GIT_WORKSPACE_PATH} is not a valid directory"
    exit 1
  fi

  cd "${GIT_WORKSPACE_PATH}"
  export VERSION="$(git describe --long|sed "s/-/\./")"
  if [[ ! $VERSION ]]; then
    echo "[github-bump-pr][set_version] There is no tag that fit a version number, pick VERSION=${VERSION}"
    exit 1
  fi

  echo "[github-bump-pr][set_version] pick VERSION=${VERSION}"
}

set_branches_and_pr() {
  [[ ! $GIT_TARGET_BRANCH ]] && export GIT_TARGET_BRANCH="master"
  export GIT_SRC_BRANCH="bump_${VERSION}"
  export PR_TITLE="Bump ${REPO_ORG}/${REPO_NAME} to ${VERSION}"

  if [[ $LOG_LEVEL == "debug" || $LOG_LEVEL == "DEBUG" ]]; then
    echo "[git-bump-pr][set_branches_and_pr] GIT_TARGET_BRANCH=${GIT_TARGET_BRANCH}, GIT_SRC_BRANCH=${GIT_SRC_BRANCH}, PR_TITLE=${PR_TITLE}"
  fi
}

git_fetch() {
  [[ ! $GIT_SRC_BRANCH ]] && export GIT_SRC_BRANCH="master"
  source /fetch.sh
  [[ $? -ne 0 ]] && exit 1
}

git_push() {
  /git-push-changes.sh
  [[ $? -ne 0 ]] && exit 1
}

reverse_branches() {
  src="${GIT_SRC_BRANCH}"
  target="${GIT_TARGET_BRANCH}"
  export GIT_TARGET_BRANCH="${src}"
  export GIT_SRC_BRANCH="${target}"
}

open_pr() {
  reverse_branches
  /open.sh
  [[ $? -ne 0 ]] && exit 1
}

if [[ $GIT_BRANCH != "master" && $GIT_BRANCH != "develop" ]] && [[ ! $GIT_BRANCH =~ ^[0-9]+.[0-9]+.x$ ]]; then
  echo "[github-bump-pr] No need to bump because GIT_BRANCH=${GIT_BRANCH}"
  exit 0
fi

git_fetch
set_version
set_branches_and_pr
yamls_patch
git_push
open_pr
