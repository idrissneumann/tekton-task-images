# Github open pull request

Open a bump pull request

## Environment variables to set

* `LOG_LEVEL`: log level (`debug` or `info`)
* `GITHUBTOKEN`: the token (from a secret)
* `TEKTON_WORKSPACE_PATH`: the workspace path
* `GIT_BRANCH`: git branch of the application repository
* `REPO_ORG`: github repo org
* `REPO_NAME`: github repo name
* `YAML_INPUT_FILE_PATH`: relative path to the input yaml file (in the `TEKTON_WORKSPACE_PATH`)
* `YQ_EXPRESSION`: `yq` patch expression (it can contain `VERSION_TO_REPLACE` that will be automatically replaced by the git tag version)
* `GIT_TARGET_BRANCH`: git target branch of the deployment/gitops repository (default: `master`)

For multiple expressions and multiple file, you can use `YQ_EXPRESSION_X` with `YAML_INPUT_FILE_PATH_X` instead of `YAML_INPUT_FILE_PATH` and `YQ_EXPRESSION`, with `X`, a number that need to match for both variables.
