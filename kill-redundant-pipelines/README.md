# Check running pipeline

Check if a pipeline is already running on the pull request.

## Environment variables to set

* `LOG_LEVEL`: log level (`debug` or `info`)
* `GIT_BRANCH`: git branch
* `TEKTON_NAMESPACE`: namespace of tekton pipelines
* `PROJECT_NAME`: project name (prefix of the pipelineruns name)
* `BUILD_ID`: build id (suffix of the pipelineruns name) to filter
* `KUBE_ENV`: kubernetes env name
* `KUBE_URL`: kubernetes cluster url
* `KUBE_TOKEN`: kubernetes token

## Tekton example

See the [example](./kill-redundant-pipelines.yaml)
