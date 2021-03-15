#!/usr/bin/env python3

import os
import requests
import shlex
import re
import subprocess
import sys

from env_files_utils import *

SLACK_TOKEN = os.environ['SLACK_TOKEN']
SLACK_USERNAME = os.environ['SLACK_USERNAME']
SLACK_AVATAR = os.environ['SLACK_EMOJI_AVATAR']
SLACK_CHANNEL = os.environ['SLACK_CHANNEL']
LOG_LEVEL = os.environ['LOG_LEVEL']
GIT_REPO = "{}/{}".format(os.environ['REPO_ORG'], os.environ['REPO_NAME'])
GIT_BRANCH = os.environ['GIT_BRANCH']
PIPELINE_URL = os.environ['PIPELINE_URL']
STATE_FAIL_TPL = " state = {}, "
MSG_RESULT_TPL = "[{} - {}] {}{}pr_url = {}, pipeline_url = {}"
PIPELINE_STATE = os.environ['DEFAULT_PIPELINE_STATE']
ONLY_ON_FAILURE = os.environ['ONLY_ON_FAILURE']
SUCCESS_MESSAGE = os.environ['SUCCESS_MESSAGE']
FAILURE_MESSAGE = os.environ['FAILURE_MESSAGE']

SUCCESS_COLOR = "#00e600"
FAILURE_COLOR = "#CC0000"

def slack_message(emoji, channel, color, message, token, user):
    r = requests.post("https://hooks.slack.com/services/{}".format(token), json = {"channel": channel, "username": user, "icon_emoji": emoji, "attachments": [{"color": color, "text": message}]})
    print(r.content)

def str2bool(v):
    return v.lower() in ("yes", "true", "t", "1")

env_file = get_pr_env_file()

if LOG_LEVEL == "debug" or LOG_LEVEL == "DEBUG":
    print("[slack-result-sender][debug] env_file = {}, pre-state = {}".format(env_file, PIPELINE_STATE));

command = shlex.split("env -i sh -c 'source {} && env'".format(env_file))
proc = subprocess.Popen(command, stdout = subprocess.PIPE, stderr = subprocess.STDOUT, encoding = 'utf8')

for line in proc.stdout:
    (key, _, value) = line.partition("=")
    os.environ[key] = value.strip();
    if LOG_LEVEL == "debug" or LOG_LEVEL == "DEBUG":
        print("[slack-result-sender][debug] set env variable key={}, value={}".format(key, value.strip()))
proc.communicate()

if PIPELINE_STATE == "toguess":
    if os.environ.get("PIPELINE_STATE") is None:
        PIPELINE_STATE = "success"
        if LOG_LEVEL == "debug" or LOG_LEVEL == "DEBUG":
            print("[slack-result-sender][debug] no environment variable PIPELINE_STATE set, set the state to success...")
    else:
        PIPELINE_STATE = os.environ['PIPELINE_STATE']
        if LOG_LEVEL == "debug" or LOG_LEVEL == "DEBUG":
            print("[slack-result-sender][debug] environment variable PIPELINE_STATE is set with {}".format(os.environ['PIPELINE_STATE']))

last_pr = ""
if os.environ.get("LAST_PULL_REQUEST_URL") is not None:
    last_pr = os.environ['LAST_PULL_REQUEST_URL']

if os.environ.get("LAST_COMMIT") is not None and (LOG_LEVEL == "debug" or LOG_LEVEL == "DEBUG"):
    print("[slack-result-sender][debug] last_commit = " + os.environ['LAST_COMMIT'] + ", state = " + PIPELINE_STATE);

if PIPELINE_STATE == "success":
    state_str = " "
    publish = not str2bool(ONLY_ON_FAILURE)
    msg_result = MSG_RESULT_TPL.format(GIT_REPO, GIT_BRANCH, SUCCESS_MESSAGE, state_str, last_pr, PIPELINE_URL)
    color_result = SUCCESS_COLOR
else:
    state_str = STATE_FAIL_TPL.format(PIPELINE_STATE)
    publish = True
    msg_result = MSG_RESULT_TPL.format(GIT_REPO, GIT_BRANCH, FAILURE_MESSAGE, state_str, last_pr, PIPELINE_URL)
    color_result = FAILURE_COLOR

if LOG_LEVEL == "debug" or LOG_LEVEL == "DEBUG":
    print("[slack-result-sender][debug] publish = {}, msg = {}, color = {}".format(publish, msg_result, color_result))

if publish == True:
    slack_message(SLACK_AVATAR, SLACK_CHANNEL, color_result, msg_result, SLACK_TOKEN, SLACK_USERNAME)