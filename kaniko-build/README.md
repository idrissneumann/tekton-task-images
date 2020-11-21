
# Build Kaniko

Build containers images with Kaniko.

## Environment variables to set

* `LOG_LEVEL`: log level (`debug` or `info`)
* `GIT_BRANCH`: git branch name
* `ENABLE_CACHE`: enable build with cache
* `CACHE_TTL`: cache time to live
* `REGISTRY`: conatiners images registry
* `IMAGE`: image name
* `IMAGE_TAG`: image tag
* `EXTRA_ARGS`: extra args (multistage targets for example)
* `DOCKERFILE`: path to the Dockerfile
* `CONTEXT`: the build context used by Kaniko
* `TEKTON_WORKSPACE_PATH`: the tekton workspace path which is bind to a pvc
