#!/usr/bin/env python3

import json
import os
import http.client
import urllib.parse
import subprocess
import shlex
import re
import sys

log_level = os.environ['LOG_LEVEL']
tekton_workspace_path = os.environ['TEKTON_WORKSPACE_PATH']
comment = os.environ['COMMENT']

api_version = "v3"
github_host_url = "api.github.com"

env_file = tekton_workspace_path + "/pr_env-" + re.sub("-foll", "", re.sub(r"-[^-]*$", "", os.environ['HOSTNAME'])) + ".sh"

if log_level == "debug" or log_level == "DEBUG":
    print("[github-add-comment][debug] env_file = " + env_file);

command = shlex.split("env -i bash -c 'source " + env_file + " && env'")
proc = subprocess.Popen(command, stdout = subprocess.PIPE, stderr = subprocess.STDOUT, text = True, encoding = 'utf8')

for line in proc.stdout:
    (key, _, value) = line.partition("=")
    os.environ[key] = value.strip();
proc.communicate()

if os.environ.get("LAST_PULL_REQUEST_URL") is None:
    print("[github-add-comment] There is no PR to set a comment")
    sys.exit(0)

pull_request_url = os.environ['LAST_PULL_REQUEST_URL'];
if log_level == "debug" or log_level == "DEBUG":
    print("[github-add-comment][debug] pull_request_url = " + pull_request_url);

split_url = urllib.parse.urlparse(pull_request_url).path.split("/")

# This will convert https://github.com/foo/bar/pull/202 to api url path /repos/foo/issues/202
api_url = "/repos/" + "/".join(split_url[1:3]) + "/issues/" + split_url[-1] + "/comments"

if log_level == "debug" or log_level == "DEBUG":
    print("[github-add-comment][debug] api_url = " + api_url);

# Trying to avoid quotes issue as much as possible by using triple quotes
comment = """{}""".format(comment)
data = {
    "body": comment,
}
print("Sending this data to GitHub: ")
print(data)
conn = http.client.HTTPSConnection(github_host_url)
r = conn.request(
    "POST",
    api_url,
    body=json.dumps(data),
    headers={
        "User-Agent": "TektonCD, the peaceful cat",
        "Authorization": "Bearer " + os.environ["GITHUBTOKEN"],
        "Accept": "Accept: application/vnd.github.{}+json".format(api_version)
    })
resp = conn.getresponse()
if not str(resp.status).startswith("2"):
    print("Error: %d" % (resp.status))
    print(resp.read())
else:
    print("a GitHub comment has been added to " + pull_request_url)
