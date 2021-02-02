# Github search pull requests

Task for destroy the binded pvc at the end of the pipeline.

## Environment variables to set

* `NAMESPACE`: the namespace
* `PVC_NAME`: the pvc name
* `KUBE_ENV`: kubernetes env name
* `KUBE_URL`: kubernetes cluster url
* `KUBE_TOKEN`: kubernetes token
* `MULTI_ENV`: multi env `enabled` or `disabled`. If it's enabled, you'll have to set `GIT_BRANCH` and `KUBE_{ENV}_ENV`, `KUBE_{ENV}_URL`, `KUBE_{ENV}_TOKEN` variables for each env.

## Tekton example

See the [example](./destroy-pvc.yaml)
