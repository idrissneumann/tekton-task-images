#!/bin/bash

if [[ $GIT_BRANCH == "master" || $GIT_BRANCH == "develop" ]]; then
    cd "${TEKTON_WORKSPACE_PATH}"
    export VERSION="${GIT_BRANCH}" # maybe pick a tag
    export GIT_SRC_BRANCH="bump_${VERSION}"
    source /reverse_branches.sh
    /git-push-changes.sh
    source /reverse_branches.sh
    /open.sh
fi
