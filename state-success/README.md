# State success

Use this image as an end task of your pipeline in order to set the final state to `success`.

(Usefull when you use the [`github-set-status`](./github-set-status) or the [`slack-result-sender`](./slack-result-sender) tasks).

## Environment variables to set

* `LOG_LEVEL`: log level (`debug` or `info`)
* `TEKTON_WORKSPACE_PATH`: the tekton workspace path which is bind to a pvc
