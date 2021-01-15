
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
* `PROJECT_STABLE`: path of stables images in the registry (after merge)
* `PROJECT_UNSTABLE`: path of stables images in the registry (before merge)
* `FORCE_PROJECT_UNSTABLE`: force push in the `$PROJECT_UNSTABLE` path
* `TEKTON_WORKSPACE_PATH`: the tekton workspace path which is bind to a pvc
* `MULTI_ENV`: enabled mutli-env delivery (push the image in a subdir `/prod` or `/qa` if it's `enabled` and if `$GIT_BRANCH` match)
* `VERSIONING_FROM_TAG`: enable versioning from git tag

## Tekton example

See the [example](./build-container-image.yaml)
