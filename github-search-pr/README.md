# Github search pull requests

Search the opened pull requests from a branch on github.

## Environment variables to set

* `LOG_LEVEL`: log level (`debug` or `info`)
* `GITHUBTOKEN`: the token (from a secret)
* `TEKTON_WORKSPACE_PATH`: the tekton workspace path which is bind to a pvc
* `REPO_ORG`: github repo org
* `REPO_NAME`: github repo name
* `GIT_BRANCH`: git branch name
* `GIT_SHA`: git sha (you can put an empty string if you want to search the prs only from the branch)

## Tekton example

See the [example](./github-search-pr.yaml)
