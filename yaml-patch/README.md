# Yaml task in order to patch a yaml

## Environment variables to set

* `YAML_INPUT_FILE_PATH`: relative path to the input yaml file (in the `TEKTON_WORKSPACE_PATH`)
* `YAML_OUTPUT_FILE_PATH`: relative path to the output yaml file (in the `TEKTON_WORKSPACE_PATH`)
* `YAML_TEMPLATE_PATCH`: relative path to the template yaml file (in the `TEKTON_WORKSPACE_PATH`)
* `VALUES_TO_REPLACE`: the value to replace in the template with `sed` format (ie: `s/foo/bar/g`)
* `TEKTON_WORKSPACE_PATH`: the tekton workspace path
