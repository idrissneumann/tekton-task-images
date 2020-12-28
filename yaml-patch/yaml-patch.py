#!/usr/bin/env python3

import os
from subprocess import check_output
from ruamel.yaml import YAML

yaml = YAML()
log_level = os.environ['LOG_LEVEL']

def get_script_output (cmd):
    if log_level == "debug" or log_level == "DEBUG":
        print("[yaml-patch][get_script_output][debug] cmd = {}".format(cmd))

    try:
        return check_output(cmd, shell=True, text=True)
    except:
        return check_output(cmd, shell=True, universal_newlines=True)

def yaml_load_from_file (path):
    with open(path) as fp:
        return yaml.load(fp)

def yaml_dump_to_file (input, path):
    with open(path, "w") as fp:
        yaml.dump(input, fp)
    if log_level == "debug" or log_level == "DEBUG":
        with open(path, 'r') as f:
            print("[yaml-patch][yaml_dump_to_file][debug] content : {}".format(f.read()))

def patch_from_template(template_path):
    if os.environ.get("VALUES_TO_REPLACE") is not None:
        patch_path = "{}.patch".format(template_path)
        value_to_replaces = os.environ['VALUES_TO_REPLACE']
        get_script_output("sed -i.patch \"{}\" {}".format(value_to_replaces, template_path))
        if log_level == "debug" or log_level == "DEBUG":
            with open(patch_path, 'r') as f:
                print("[yaml-patch][patch_from_template][debug] content : {}".format(f.read()))
        return patch_path
    else:
        return template_path

file_path = os.environ['TEKTON_WORKSPACE_PATH']
input_path = "{}/{}".format(file_path, os.environ['YAML_INPUT_FILE_PATH'])
template_path = "{}/{}".format(file_path, os.environ['YAML_TEMPLATE_PATCH'])
output_path = "{}/{}".format(file_path, os.environ['YAML_OUTPUT_FILE_PATH'])
root_key = os.environ['ROOT_KEY']

patch_path = patch_from_template(template_path)
input_yaml = yaml_load_from_file(input_path)
patch_yaml = yaml_load_from_file(patch_path)

for i in patch_yaml[root_key]:
    if log_level == "debug" or log_level == "DEBUG":
        print ("{} => {}".format(i ,patch_yaml[root_key][i]))
    input_yaml[root_key].update({i:patch_yaml[root_key][i]})

yaml_dump_to_file(input_yaml, output_path)
