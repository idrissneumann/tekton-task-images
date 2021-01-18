# Github open pull request

Open a pull request.
## Environment variables to set

* `LOG_LEVEL`: log level (`debug` or `info`)
* `GITHUBTOKEN`: the token (from a secret)
* `GIT_BRANCH`: git branch name on the original repo (ie: `master`)
* `GIT_SRC_BRANCH`: git source branch name on the gitops repo (ie: `bump_1.3.4`)
* `GIT_TARGET_BRANCH`: git target branch on the gitops repo (ie: `master` or `develop` or `1.3.x`)
* `AUTO_MERGE_GIT_BRANCH`: conditional auto-merging if `GIT_BRANCH` has the same value
* `PR_TITLE`: git commit message (ie: `bump to 1.3.4`)
* `REPO_ORG`: github repo org
* `REPO_NAME`: github repo name
