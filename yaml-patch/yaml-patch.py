#!/usr/bin/env python3

import os
from subprocess import check_output
import hiyapyco

log_level = os.environ['LOG_LEVEL']

def get_script_output (cmd):
    if log_level == "debug" or log_level == "DEBUG":
        print("[yaml-patch][get_script_output][debug] cmd = {}".format(cmd))
    try:
        return check_output(cmd, shell=True, text=True)
    except:
        return check_output(cmd, shell=True, universal_newlines=True)

def merge_files (path1, path2):
    with open(path1) as fp1, open(path2) as fp2:
        return hiyapyco.load([fp1.read(), fp2.read()], method=hiyapyco.METHOD_MERGE)

def yaml_dump_to_file (input, path):
    with open(path, "w") as fp:
        fp.write(hiyapyco.dump(input))
    if log_level == "debug" or log_level == "DEBUG":
        with open(path, 'r') as f:
            print("[yaml-patch][yaml_dump_to_file][debug] content : {}".format(f.read()))

def patch_from_template(template_path):
    if os.environ.get("VALUES_TO_REPLACE") is not None:
        patch_path = "{}.patch".format(template_path)
        value_to_replaces = os.environ['VALUES_TO_REPLACE']
        get_script_output("sed '{}' {} > {}".format(value_to_replaces, template_path, patch_path))
        if log_level == "debug" or log_level == "DEBUG":
            with open(patch_path, 'r') as f:
                print("[yaml-patch][patch_from_template][debug] content : {}".format(f.read()))
        return patch_path
    else:
        return template_path

files_path = os.environ['TEKTON_WORKSPACE_PATH']
input_path = "{}/{}".format(files_path, os.environ['YAML_INPUT_FILE_PATH'])
template_path = "{}/{}".format(files_path, os.environ['YAML_TEMPLATE_PATCH'])
output_path = "{}/{}".format(files_path, os.environ['YAML_OUTPUT_FILE_PATH'])

patch_path = patch_from_template(template_path)
merged_yaml = merge_files(input_path, patch_path)
yaml_dump_to_file(merged_yaml, output_path)
