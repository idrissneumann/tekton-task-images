#!/bin/bash

replace_version() {
  yq_expr_full_var="${1}"
  yq_expr_var="$(echo ${yq_expr_full_var}|cut -d= -f1)"
  yq_expr_val_wt=$(eval "echo \$${yq_expr_var}")

  echo "[github-bump-pr][replace_version] try to replace ${yq_expr_var} = ${yq_expr_val_wt} with VERSION_TO_REPLACE => ${VERSION}"
  if [[ $yq_expr_val_wt && $yq_expr_var ]]; then
    yq_expr_val=$(echo "${yq_expr_val_wt}"|sed "s/VERSION_TO_REPLACE/${VERSION}/g")
    if [[ $yq_expr_val ]]; then 
      echo "[github-bump-pr][replace_version] ${yq_expr_var} = ${yq_expr_val}"
      export "${yq_expr_var}=${yq_expr_val}"
    fi
  fi
}

yamls_patch() {
  export TEKTON_WORKSPACE_PATH="${GITOPS_WORKSPACE_PATH}"
  if [[ ! $TEKTON_WORKSPACE_PATH ]] || [[ ! -d $TEKTON_WORKSPACE_PATH ]]; then
    echo "[github-bump-pr][yamls_patch] TEKTON_WORKSPACE_PATH=${TEKTON_WORKSPACE_PATH} is not a valid directory"
    exit 1
  fi

  replace_version "YQ_EXPRESSION=${YQ_EXPRESSION}"
  while read -r; do
    replace_version "${REPLY}"
  done < <(env|grep -E "YQ_EXPRESSION_[0-9]+")

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
  [[ ! $PROJECT_NAME ]] && export PROJECT_NAME="${REPO_ORG}_${REPO_NAME}"

  export GIT_SRC_BRANCH="bump_${PROJECT_NAME}_${VERSION}"
  export PR_TITLE="Bump ${PROJECT_NAME} to ${VERSION}"
  export GIT_COMMIT_MSG="${PR_TITLE}"

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
  export GIT_WORKSPACE_PATH="${GITOPS_WORKSPACE_PATH}"
  reverse_branches
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
}

delete_src_branch() {
  cd "${GIT_WORKSPACE_PATH}"
  
  if [[ $GIT_SRC_BRANCH =~ ^bump_.*$ ]]; then
    git push -d origin "${GIT_SRC_BRANCH}" || :
  else
    echo "[github-bump-pr] Error, bump branch is not named right: GIT_SRC_BRANCH=${GIT_SRC_BRANCH}"
    exit 1
  fi
}

if [[ ! $GIT_BRANCH =~ ^([0-9]+.[0-9]+.x|master|develop|main|prod|qa|ppd|preprod)$ ]]; then
  echo "[github-bump-pr] No need to bump because GIT_BRANCH=${GIT_BRANCH}"
  exit 0
fi

if [[ $ONLY_ON_GIT_BRANCH && $GIT_BRANCH != $ONLY_ON_GIT_BRANCH ]]; then
  echo "[github-bump-pr] No need to bump because GIT_BRANCH=${GIT_BRANCH} != ONLY_ON_GIT_BRANCH=${ONLY_ON_GIT_BRANCH}"
  exit 0
fi

git_fetch
set_version
set_branches_and_pr
yamls_patch
git_push
open_pr
delete_src_branch
