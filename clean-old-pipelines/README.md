# Clean old pipelines

This tekton utils image can be used as a simple deployment/pod on your `tekton-pipelines` namespace.

It clean the pipelineruns and associated pvc that are older than a configurable retention.

## Environment variables to set

* `NAMESPACE`: the namespace
* `PROJECT_PREFIXES`: list of pvc prefixes with the following format: `(project1|project2|...)`
* `RETENTION_DAYS`: number of days to keep the pipelineruns
* `WAIT_TIME`: sleep time in millis
* `KUBE_ENV`: kubernetes env name
* `KUBE_URL`: kubernetes cluster url
* `KUBE_TOKEN`: kubernetes token
* `SHOULD_SLACK`: should slack (`on` or `off`)
* `SLACK_TOKEN`: slack token
* `SLACK_USERNAME`: username
* `SLACK_EMOJI_AVATAR`: an emoji code that will be used as an avatar
* `SLACK_CHANNEL`: channel where the message will be posted
* `SLACK_COLOR`: border color of the message

## Kubernetes configuration examples

* The [deployment](./deployment.yaml)
* The [configmap](./configmap.yaml)
