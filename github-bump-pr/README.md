# Github open pull request

Open a bump pull request to upgrade yaml manifests with a version number from a git tag.

## Environment variables to set

* `LOG_LEVEL`: log level (`debug` or `info`)
* `GITHUBTOKEN`: the token (from a secret)
* `GIT_BRANCH`: git branch of the application repository
* `ONLY_ON_GIT_BRANCH` (optional): if it's set, the task will apply only if `GIT_BRANCH` has the same value
* `AUTO_MERGE_GIT_BRANCH` (optional): auto-merge only if `GIT_BRANCH` has the same value
* `REPO_ORG`: github repo org
* `REPO_NAME`: github repo name
* `PROJECT_NAME`: project name that will appear on the pull request title
* `GIT_USER_EMAIL`: the git email you want to use for commit
* `GIT_USER_NAME`: the git name you want to use for commit
* `YAML_INPUT_FILE_PATH`: relative path to the input yaml file (in the `TEKTON_WORKSPACE_PATH`)
* `YQ_EXPRESSION`: `yq` patch expression (it can contain `VERSION_TO_REPLACE` that will be automatically replaced by the git tag version)
* `GIT_TARGET_BRANCH`: git target branch of the deployment/gitops repository (default: `master`)

For multiple expressions and multiple file, you can use `YQ_EXPRESSION_X` with `YAML_INPUT_FILE_PATH_X` instead of `YAML_INPUT_FILE_PATH` and `YQ_EXPRESSION`, with `X`, a number that need to match for both variables.

## Tekton example

See the [example](./myproject-bump.yaml)
