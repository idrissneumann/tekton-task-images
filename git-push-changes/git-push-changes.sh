#!/bin/sh

if [ "${LOG_LEVEL}" = "debug" ] || [ "${LOG_LEVEL}" = "DEBUG" ]; then
  set -x
fi

if [ -z "${GIT_WORKSPACE_PATH}" ] || [ ! -d "${GIT_WORKSPACE_PATH}" ]; then
  echo "[git-push-changes] GIT_WORKSPACE_PATH=${GIT_WORKSPACE_PATH} is not a valid directory"
  exit 1
fi

cd "${GIT_WORKSPACE_PATH}"
git checkout "${GIT_SRC_BRANCH}"
git pull --rebase origin "${GIT_SRC_BRANCH}"
git branch -D "${GIT_TARGET_BRANCH}" || :
git checkout 
git add .
git commit -m "${GIT_COMMIT_MSG}"
git push origin "${GIT_TARGET_BRANCH}"
