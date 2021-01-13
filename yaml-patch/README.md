# Yaml task in order to patch a yaml another

## Environment variables to set

* `LOG_LEVEL`: log level (`debug` or `info`)
* `YAML_INPUT_FILE_PATH`: relative path to the input yaml file (in the `TEKTON_WORKSPACE_PATH`)
* `YQ_EXPRESSION`: `yq` patch expression
* `TEKTON_WORKSPACE_PATH`: the tekton workspace path

For multiple expressions and multiple file, you can use `YQ_EXPRESSION_X` with `YAML_INPUT_FILE_PATH_X` instead of `YAML_INPUT_FILE_PATH` and `YQ_EXPRESSION`, with `X`, a number that need to match for both variables.
