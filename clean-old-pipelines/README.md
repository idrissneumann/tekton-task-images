# Clean old pipelines

This tekton utils image can be used as a simple deployment/pod on your `tekton-pipelines` namespace.

It clean the pipelineruns and associated pvc that are older than a configurable retention.

## Environment variables to set

* `NAMESPACE`: the namespace
* `PROJECT_PREFIXES`: list of pvc prefixes with the following format: `(project1|project2|...)`
* `MAX_PIPELINES_KEEP`: max pipelinerun to keep (you can set `disabled` if you want to keep all the job that are younger than `RETENTION_DAYS`)
* `RETENTION_DAYS`: number of days to keep the pipelineruns (you can set `disabled` if you want to only keep `MAX_PIPELINES_KEEP` regardless of the age of the pipelines)
* `ENABLE_DESTROY_PVC`: `enabled` if you need to also destroy the pvc (because you're not using `volumeClaimTemplate` directly), `disabled` otherwise
* `WAIT_TIME`: sleep time in millis (you can set `disabled` if you doesn't want to use this apps as a daemon but as a cron job instead for example)
* `KUBE_ENV`: kubernetes env name (default `dev`)
* `KUBE_DEV_CERTIFICATE`(optional): certificate (not mandatory for rancher kubeconfig) 
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
