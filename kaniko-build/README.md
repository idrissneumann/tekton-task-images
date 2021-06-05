
# Build Kaniko

Build containers images with Kaniko.

## Environment variables to set

* `LOG_LEVEL`: log level (`debug` or `info`)
* `GIT_BRANCH`: git branch name
* `ENABLE_CACHE` (optional): enable build with cache
* `CACHE_TTL`: cache time to live
* `DOCKER_REGISTRY`: containers images registry
* `IMAGE`: image name
* `IMAGE_TAG` (optional): image tag
* `EXTRA_ARGS` (optional): extra args (multistage targets for example)
* `DOCKERFILE`: path to the Dockerfile
* `CONTEXT`: the build context used by Kaniko
* `PROJECT_STABLE`: path of stables images in the registry (after merge)
* `PROJECT_UNSTABLE`: path of stables images in the registry (before merge)
* `FORCE_PROJECT_UNSTABLE`: force push in the `$PROJECT_UNSTABLE` path
* `TEKTON_WORKSPACE_PATH`: the tekton workspace path which is bind to a pvc
* `MULTI_ENV` (optional): enabled mutli-env delivery (push the image in a subdir `/prod` or `/qa` if it's `enabled` and if `$GIT_BRANCH` match)
* `VERSIONING_FROM_TAG` (optional): enable versioning from git tag
* `RETRY_NUMBER` (optional): number of retry for pushing the images into the registry
* `DOCKER_USERNAME` (optional): oci registry username
* `DOCKER_PASSWORD` (optional): oci registry password

## Tekton example

See the [example](./build-container-image.yaml)
