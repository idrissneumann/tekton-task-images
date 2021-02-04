# Github search pull requests

Task for destroy pods in order to let ArgoCD redeploy them with new images.

## Environment variables to set

* `NAMESPACE`: the namespace
* `POD_PREFIX`: the pod prefix (begin of the name)
* `KUBE_ENV`: kubernetes env name (default `dev`)
* `KUBE_CERTIFICATE`(optional): certificate (not mandatory for rancher kubeconfig) 
* `KUBE_URL`: kubernetes cluster url
* `KUBE_TOKEN`: kubernetes token
* `DELETE_JOBS`: delete jobs (`enabled` or `disabled`)
* `DESTROY_MODE`: `rollout` or `delete`(default is `rollout`)
* `GIT_BRANCH`: the git branch
* `MULTI_ENV`: multi env `enabled` or `disabled`. If it's enabled, you'll have to set `KUBE_{ENV}_ENV`, `KUBE_{ENV}_URL`, `KUBE_{ENV}_TOKEN` variables for each env.

## Tekton example

See the [example](./destroy-pods.yaml)
