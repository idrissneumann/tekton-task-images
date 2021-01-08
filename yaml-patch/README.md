# Yaml task in order to patch a yaml another

## Environment variables to set

* `LOG_LEVEL`: log level (`debug` or `info`)
* `YAML_INPUT_FILE_PATH`: relative path to the input yaml file (in the `TEKTON_WORKSPACE_PATH`)
* `YQ_EXPRESSION`: `yq` patch expression
* `TEKTON_WORKSPACE_PATH`: the tekton workspace path
