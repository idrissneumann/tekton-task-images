# Init a pipeline from github

Composite task that will use:

* [`github-search-pr`](./github-search-pr)
* [`github-set-status`](./github-set-status)
* [`github-add-comment`](./github-add-comment)
* [`slack-sender`](./slack-sender)
* [`git-fetch-sources`](./git-fetch-sources)

## Environment variables to set

* `LOG_LEVEL`: log level (`debug` or `info`)
* `PIPELINE_URL`: pipeline url
* `REPO_ORG`: github repo org
* `REPO_NAME`: github repo name
* `GIT_BRANCH`: git branch name
* `GITHUBTOKEN`: github token (from a secret)
* `SLACK_TOKEN`: slack token (from a secret)
* `SLACK_CHANNEL`: slack channel
* `TEKTON_WORKSPACE_PATH`: the tekton workspace path which is bind to a pvc

## Tekton example

See the [example](./init-pipeline-github.yaml)
