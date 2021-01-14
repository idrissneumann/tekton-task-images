#!/bin/sh

if [ "${LOG_LEVEL}" = "debug" ] || [ "${LOG_LEVEL}" = "DEBUG" ]; then
  set -x
fi

if [ -z "${GIT_WORKSPACE_PATH}" ] || [ ! -d "${GIT_WORKSPACE_PATH}" ]; then
  echo "[git-push-changes] GIT_WORKSPACE_PATH=${GIT_WORKSPACE_PATH} is not a valid directory"
  exit 1
fi

cd "${GIT_WORKSPACE_PATH}"

if [ -z "${GIT_SRC_BRANCH}" ] || [ -z "${GIT_TARGET_BRANCH}" ]; then
  echo "[git-push-changes] at least one of the branches are not valid. GIT_SRC_BRANCH=${GIT_SRC_BRANCH}, GIT_TARGET_BRANCH=${GIT_TARGET_BRANCH}"
  exit 1
fi

if [ -z "${GIT_USER_EMAIL}" ]; then
  export GIT_USER_EMAIL="tekton@tekton.dev"
fi

if [ -z "${GIT_USER_NAME}" ]; then
  export GIT_USER_NAME="tekton"
fi

git checkout "${GIT_SRC_BRANCH}"
git add .
git config --global user.email "${GIT_USER_EMAIL}"
git config --global user.name "${GIT_USER_NAME}"
git commit -m "${GIT_COMMIT_MSG}"

git branch -D "${GIT_TARGET_BRANCH}" || :
git push -d origin "${GIT_TARGET_BRANCH}" || :
git checkout -b "${GIT_TARGET_BRANCH}"
git push origin "${GIT_TARGET_BRANCH}"
