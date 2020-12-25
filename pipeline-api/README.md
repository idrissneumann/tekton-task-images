# Api to run pipelines

## How to use the api

Replace `XXXXXXX` with the right password.
### Check if it's alive

```shell
$ curl -u tekton:XXXXXXX "https://tekton-pipeline-api.k8s.yyyyyy.io"
{"alive": true}
```

### List all the available pipelines

```shell
$ curl -u tekton:XXXXXXX "https://tekton-pipeline-api.k8s.yyyyyy.io/pipeline" | jq .
{
  "status": "ok",
  "available_pipelines": [
    "my-pipeline"
  ]
}
```

### Run a pipeline on a branch

```shell
$ curl -X POST -u tekton:XXXXXXX "https://tekton-pipeline-api.k8s.yyyyyy.io/pipeline" -d '{"pipeline_name":"my-pipeline", "git_branch":"master"}'
{"status": "ok", "async": true}
```

### Show the deployed version of the api

```shell
$ curl -u tekton:XXXXXXX "https://tekton-pipeline-api.k8s.yyyyyy.io/manifest" | jq .
{
  "sha": "80d79a34c0aa65b327374980d9ddbdf845f76ce3",
  "tag": "",
  "branch": "master",
  "repo_org": "my_org",
  "repo_name": "my_project"
}
```
## Add a pipeline to the API using templates

Add `xxxx-run.tpl.yaml` template file in the `templates` directory.

The template need to contain the following kubernetes resources:
* A `PersistentVolumeClaim` (one per pipelinerun)
* A `PipelineResource` that will be created for one git branch on the repository if it doesn't already exists
* A `PipelineRun`

The template file should looks like:

```yaml
apiVersion: tekton.dev/v1alpha1
kind: PipelineResource
metadata:
  name: git-myorg-myproject-BRANCH_HASH
  namespace: tekton-pipelines
spec:
  type: git
  params:
    - name: url
      value: https://github.com/myorg/myproject
    - name: revision
      value: "BRANCH_NAME"
    - name: depth
      value: "0"
---
apiVersion: tekton.dev/v1beta1
kind: PipelineRun
metadata:
  name: "build-myorg-myproject-UNIQ_ID"
  namespace: tekton-pipelines
spec:
  pipelineRef:
    name: my-pipeline
  resources:
    - name: git-myorg-myproject
      resourceRef:
        name: git-myorg-myproject-BRANCH_HASH
  params:
    - name: buildId
      value: "UNIQ_ID"
    - name: gitBranchName
      value: "BRANCH_NAME"
    - name: logLevel
      value: LOG_LEVEL
  serviceAccountName: all-access-sa
  workspaces:
    - name: git-environment
      volumeClaimTemplate:
        metadata:
          name: myorg-myproject-pvc-UNIQ_ID
        spec:
          accessModes:
            - ReadWriteOnce
          resources:
            requests:
              storage: 1Gi
```

You need to:
* replace `yourproject` everywhere by the repo project name
* change the storage value (here `1gi`) according to your pipeline needs

## Trigger the api with github action

Here is a simple action to copy/past on your repository:

```yaml
name: creating_tekton_pipeline

on: [push]

jobs:
  tekton:
    name: 'tekton-trigger'
    runs-on: ubuntu-latest
    steps:
      - name: 'Invoke tekton pipeline api'
        uses: indiesdev/curl@v1
        with:
          url: https://tekton-pipeline-api.k8s.yyyyyy.io/pipeline
          method: 'POST'
          accept: 200,201,204
          body: "{ \"git_branch\": \"${{ github.ref }}\",\"pipeline_name\": \"my-pipeline\" }"
          basic-auth: ${{ secrets.TEKTON_USER }}:${{ secrets.TEKTON_PASSWORD }} 
```

You need to:
* add the secrets `TEKTON_USER` and `TEKTON_PASSWORD` to your target repository
* change the `pipeline_name` parameter according to your template file

## How to use the api in your localhost environment

1. Create a file `tekton-pipelines.env` with the following content:

```shell
KUBE_URL="changeit"
KUBE_ENV="changeit"
KUBE_TOKEN="changeit"
```

Replace the three `changeit` values with the K8S kubeconfig value that host tekton pipelines.

2. Build and run the api

```shell
$ cd tekton-pipelines/base/pipeline_api
$ docker-compose up --build
```

3. Use it !

```shell
$ curl "http://0.0.0.0:8080/" # check if it's alive
$ curl "http://0.0.0.0:8080/manifest" # check the manifest
$ curl http://0.0.0.0:8080/pipeline # show the available pipelines
$ curl -X POST http://0.0.0.0:8080/pipeline -H "Content-Type: application/json" -d '{"pipeline_name":"my-pipeline", "git_branch":"master"}' # run a pipeline (you can also specify the log_level in the body of the request)
```
