# Git push changes

Sync a git branch from another

## Environment variables to set

* `GIT_WORKSPACE_PATH`: the git workspace path which is bind to a tekton pipeline resource
* `GIT_SRC_BRANCH`: git source branch name (ie: `master` or `develop`)
* `GIT_TARGET_BRANCH`: git target branch (ie: `develop`)
