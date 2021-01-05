# Git push changes

Push a branch with some changes

## Environment variables to set

* `LOG_LEVEL`: log level (`debug` or `info`)
* `TEKTON_WORKSPACE_PATH`: the tekton workspace path which is bind to a pvc
* `GIT_SRC_BRANCH`: git source branch name (ie: `master` or `develop`)
* `GIT_TARGET_BRANCH`: git target branch (ie: `bump_1.3.4`)
* `GIT_COMMIT_MSG`: git commit message (ie: `bump to 1.3.4`)
