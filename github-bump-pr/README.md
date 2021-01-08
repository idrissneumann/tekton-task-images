# Github open pull request

Open a bump pull request

## Environment variables to set

* `LOG_LEVEL`: log level (`debug` or `info`)
* `GITHUBTOKEN`: the token (from a secret)
* `TEKTON_WORKSPACE_PATH`: the workspace path
* `GIT_BRANCH`: git branch of the application repository
* `GIT_TARGET_BRANCH`: git target branch of the deployment/gitops repository (ie: `master` or `develop`)
* `PR_TITLE`: git commit message (ie: `bump to 1.3.4`)
* `REPO_ORG`: github repo org
* `REPO_NAME`: github repo name
