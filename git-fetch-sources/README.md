# Git fetch sources

Fetch the up to date sources and init environment variables for the other tasks.

## Environment variables to set

* `LOG_LEVEL`: log level (`debug` or `info`)
* `TEKTON_WORKSPACE_PATH`: the tekton workspace path which is bind to a pvc
* `REPO_ORG`: github repo org
* `REPO_NAME`: github repo name
* `REPO_URL`: repo url (instead of `REPO_ORG` AND `REPO_NAME`)
* `GIT_BRANCH`: git branch name

## Tekton example

See the [example](./git-fetch-sources.yaml)
