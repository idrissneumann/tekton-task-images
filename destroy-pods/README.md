# Github search pull requests

Task for destroy pods in order to let ArgoCD redeploy them with new images.

## Environment variables to set

* `NAMESPACE`: the namespace
* `POD_PREFIX`: the pod prefix (begin of the name)
* `KUBE_ENV`: kubernetes env name
* `KUBE_URL`: kubernetes cluster url
* `KUBE_TOKEN`: kubernetes token
* `DELETE_JOBS`: delete jobs (`enabled` or `disabled`)
* `DESTROY_MODE`: `rollout` or `delete`(default is `rollout`)