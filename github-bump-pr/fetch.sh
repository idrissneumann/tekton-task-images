#!/bin/bash

cd "${TEKTON_WORKSPACE_PATH}"

git pull
git checkout "${GIT_SRC_BRANCH}"
git pull --rebase origin "${GIT_SRC_BRANCH}"

if [[ $LOG_LEVEL == "debug" || $LOG_LEVEL == "debug" ]]; then
  echo "[github-bump-pr][fetch.sh] Content of workspaces.path = ${TEKTON_WORKSPACE_PATH}"
  ls -la "${TEKTON_WORKSPACE_PATH}"
fi
