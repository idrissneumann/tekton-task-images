#!/bin/bash

replace_version() {
  yq_expr_full_var="${1}"
  yq_expr_var="$(echo ${yq_expr_full_var}|cut -d= -f1)"

  if [[ "${yq_expr_var}" ]]; then
    yq_expr_val=$(eval "echo \$YQ_EXPRESSION_${digit}"|sed "s/VERSION_TO_REPLACE/${VERSION}/g")
    [[ "${yq_expr_val}" ]] && export "${yq_expr_var}=${yq_expr_val}"
    if [[ $LOG_LEVEL == "debug" || $LOG_LEVEL == "debug" ]]; then
      echo "[github-bump-pr][replace_version] ${yq_expr_var} = ${yq_expr_val}"
    fi
  fi
}

yamls_patch() {
  replace_version "YQ_EXPRESSION=${YQ_EXPRESSION}"
  env|grep -E "YQ_EXPRESSION_[0-9]+"|while read -r; do
    replace_version "${REPLY}"
  done
  /yaml-patch.sh
}

set_version() {
  export VERSION="$(git describe --long|sed "s/-/\./")"
  if [[ ! $VERSION ]]; then
    export VERSION="${GIT_BRANCH}"
    echo "[github-bump-pr] There is no tag that fit a version number, pick VERSION=${VERSION}"
  else
    echo "[github-bump-pr] pick VERSION=${VERSION}"
  fi
}

set_branches_and_pr() {
  [[ ! $GIT_TARGET_BRANCH ]] && GIT_TARGET_BRANCH="master"
  export GIT_SRC_BRANCH="bump_${VERSION}"
  export PR_TITLE="Bump ${REPO_ORG}/${REPO_NAME} to ${VERSION}"

  if [[ $LOG_LEVEL == "debug" || $LOG_LEVEL == "debug" ]]; then
    echo "[git-bump-pr][set_branches_and_pr] GIT_TARGET_BRANCH=${GIT_TARGET_BRANCH}, GIT_SRC_BRANCH=${GIT_SRC_BRANCH}, PR_TITLE=${PR_TITLE}"
  fi
}

git_fetch() {
  source /reverse_branches.sh
  /fetch.sh
}

git_push() {
  /git-push-changes.sh
}

open_pr() {
  source /reverse_branches.sh
  /open.sh
}

if [[ $GIT_BRANCH != "master" && $GIT_BRANCH != "develop" ]] && [[ ! $GIT_BRANCH =~ ^[0-9]+.[0-9]+.x$ ]]; then
  echo "[github-bump-pr] No need to bump because GIT_BRANCH=${GIT_BRANCH}"
  exit 0
fi

cd "${TEKTON_WORKSPACE_PATH}"

set_version
set_branches_and_pr
git_fetch
yamls_patch
git_push
open_pr
