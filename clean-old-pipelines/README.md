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

## Kubernetes configuration examples

* The [deployment](./deployment.yaml)
* The [configmap](./configmap.yaml)
