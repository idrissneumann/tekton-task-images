# Init a pipeline from github

Composite task that will use:

* [`slack-sender`](./slack-sender)
* [`git-fetch-sources`](./git-fetch-sources)

## Environment variables to set

* `LOG_LEVEL`: log level (`debug` or `info`)
* `TEKTON_WORKSPACE_PATH`: the tekton workspace path which is bind to a pvc
* `PIPELINE_URL`: pipeline url
* `REPO_URL`: git url
* `GIT_BRANCH`: git branch name
* `SLACK_TOKEN`: slack token (from a secret)
* `SLACK_CHANNEL`: slack channel

## Tekton example

See the [example](./init-pipeline.yaml)
