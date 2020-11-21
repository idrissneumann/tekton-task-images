# Slack result sender

Send a result message to a Slack channel.

## Environment variables to set

* `LOG_LEVEL`: log level (`debug` or `info`)
* `SLACK_TOKEN`: slack token
* `SLACK_USERNAME`: username
* `SLACK_EMOJI_AVATAR`: an emoji code that will be used as an avatar
* `SLACK_CHANNEL`: channel where the message will be posted
* `REPO_ORG`: github repo org
* `REPO_NAME`: github repo name
* `TEKTON_WORKSPACE_PATH`: the tekton workspace path which is bind to a pvc
* `GIT_BRANCH`: git branch name
* `PIPELINE_URL`: the pipeline url
* `DEFAULT_PIPELINE_STATE`: default state (`pending`, `toguess` or `success`)
* `ONLY_ON_FAILURE`: slack only on failure (`yes` or `no`)
* `SUCCESS_MESSAGE`: message displayed in case of success
* `FAILURE_MESSAGE`: message displayed in case of failure

## Tekton example

See the [example](./slack-sender-result.yaml)
