#!/bin/sh

cd "${GIT_WORKSPACE_PATH}"

git checkout $GIT_SRC_BRANCH
git pull --rebase origin $GIT_SRC_BRANCH
git checkout $GIT_TARGET_BRANCH
git pull --rebase origin $GIT_TARGET_BRANCH
git merge $GIT_SRC_BRANCH
git push origin $GIT_TARGET_BRANCH
