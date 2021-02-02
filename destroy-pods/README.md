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
* `MULTI_ENV`: multi env `enabled` or `disabled`. If it's enabled, you'll have to set `GIT_BRANCH` and `KUBE_{ENV}_ENV`, `KUBE_{ENV}_URL`, `KUBE_{ENV}_TOKEN` variables for each env.
