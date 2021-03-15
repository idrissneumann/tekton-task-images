import os
import re

def extract_pipeline_id():
    pattern = "[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{8}"
    match = re.search(pattern, os.environ['HOSTNAME'])
    return match.group(0)

def get_pr_json_file():
    return "{}/prs-{}.json".format(os.environ['TEKTON_WORKSPACE_PATH'], extract_pipeline_id())

def get_pr_env_file():
    return "{}/pr_env-{}.sh".format(os.environ['TEKTON_WORKSPACE_PATH'], extract_pipeline_id())
