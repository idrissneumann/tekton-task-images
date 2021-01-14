#!/bin/bash

if [[ $GIT_BRANCH != "master" && $GIT_BRANCH != "develop" ]] && [[ ! $GIT_BRANCH =~ ^[0-9]+.[0-9]+.x$ ]]; then
  echo "[github-bump-pr] No need to bump because GIT_BRANCH=${GIT_BRANCH}"
  exit 0
fi

[[ ! $GIT_TARGET_BRANCH ]] && GIT_TARGET_BRANCH="master"

cd "${TEKTON_WORKSPACE_PATH}"
/yaml-patch.sh

export VERSION="$(git describe --long|sed "s/-/\./")"

if [[ ! $VERSION ]]; then
  export VERSION="${GIT_BRANCH}"
  echo "[github-bump-pr] There is no tag that fit a version number, pick VERSION=${VERSION}"
else
  echo "[github-bump-pr] pick VERSION=${VERSION}"
fi

export GIT_SRC_BRANCH="bump_${VERSION}"
export PR_TITLE="Bump ${REPO_ORG}/${REPO_NAME} to ${VERSION}"
source /reverse_branches.sh
/git-push-changes.sh
source /reverse_branches.sh
/open.sh
