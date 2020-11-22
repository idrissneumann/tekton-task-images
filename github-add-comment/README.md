# Github add comment to PR

Github add comment to a pull request (you need to play the task [`github-search-pr`](../github-search-pr) before this one).

## Environment variables to set

* `LOG_LEVEL`: log level (`debug` or `info`)
* `TEKTON_WORKSPACE_PATH`: the tekton workspace path which is bind to a pvc
* `COMMENT`: the comment content

## Tekton example

See the [example](./github-add-comment.yaml)
