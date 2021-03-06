#!/usr/bin/env python3

import json
import os
import http.client
import shlex
import re
import subprocess
import sys

from env_files_utils import *

log_level = os.environ['LOG_LEVEL']
state = os.environ['DEFAULT_PIPELINE_STATE']
repo_org = os.environ['REPO_ORG']
repo_name = os.environ['REPO_NAME']
target_url = os.environ['PIPELINE_TARGET_URL']
description = os.environ['STATUS_DESCRIPTION']
context = os.environ['STATUS_CONTEXT']

api_version = "v3"
github_host_url = "api.github.com"

env_file = get_pr_env_file()

if log_level == "debug" or log_level == "DEBUG":
    print("[github-set-status][debug] env_file = {}, pre-state = {}".format(env_file, state));

command = shlex.split("env -i sh -c 'source {} && env'".format(env_file))
proc = subprocess.Popen(command, stdout = subprocess.PIPE, stderr = subprocess.STDOUT, text = True, encoding = 'utf8')

for line in proc.stdout:
    (key, _, value) = line.partition("=")
    os.environ[key] = value.strip();
    if log_level == "debug" or log_level == "DEBUG":
        print("[github-set-status][debug] set env variable key={}, value={}".format(key, value.strip()))
proc.communicate()

if os.environ.get("LAST_COMMIT") is None:
    print("[github-set-status] There is no commit to set a state")
    sys.exit(0)

if state == "toguess":
    if os.environ.get("PIPELINE_STATE") is not None:
        state = os.environ['PIPELINE_STATE']
        if log_level == "debug" or log_level == "DEBUG":
            print("[github-set-status][debug] environment variable PIPELINE_STATE is set with {}".format(os.environ['PIPELINE_STATE']))
    else:
        state = "success"
        if log_level == "debug" or log_level == "DEBUG":
            print("[github-set-status][debug] no environment variable PIPELINE_STATE set, set the state to success...")

if log_level == "debug" or log_level == "DEBUG":
    print("[github-set-status][debug] last_commit = " + os.environ['LAST_COMMIT'] + ", state = " + state);

status_url = "/repos/" + repo_org + "/" + repo_name + "/statuses/" + os.environ['LAST_COMMIT']
data = {
    "state": state,
    "target_url": target_url,
    "description": description,
    "context": context
}

print("Sending this data to GitHub: ")
print(data)
conn = http.client.HTTPSConnection(github_host_url)

r = conn.request(
    "POST",
    status_url,
    body=json.dumps(data),
    headers={
    "User-Agent": "TektonCD, the peaceful cat",
    "Authorization": "Bearer " + os.environ["GITHUBTOKEN"],
    "Accept": "Accept: application/vnd.github.{}+json".format(api_version)
    }
)

resp = conn.getresponse()
if not str(resp.status).startswith("2"):
    print("Error: %d" % (resp.status))
    print(resp.read())
else:
    print("GitHub status '" + state + "' has been set on " + repo_org + "/" + repo_name + "#" + os.environ["LAST_COMMIT"])
