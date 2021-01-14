#!/bin/bash

SRC="${GIT_SRC_BRANCH}"
TARGET="${GIT_TARGET_BRANCH}"

export GIT_SRC_BRANCH="${TARGET}"
export GIT_TARGET_BRANCH="${SRC}"

if [[ $LOG_LEVEL == "debug" || $LOG_LEVEL == "DEBUG" ]]; then
  echo "[github-bump-pr][reverse_branches.sh] GIT_SRC_BRANCH = ${GIT_SRC_BRANCH}, GIT_TARGET_BRANCH=${GIT_TARGET_BRANCH}"
fi
