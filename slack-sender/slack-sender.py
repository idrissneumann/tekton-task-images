#!/usr/bin/env python3

import os
import requests

SLACK_TOKEN = os.environ['SLACK_TOKEN']
SLACK_USERNAME = os.environ['SLACK_USERNAME']
SLACK_AVATAR = os.environ['SLACK_EMOJI_AVATAR']
SLACK_CHANNEL = os.environ['SLACK_CHANNEL']
SLACK_COLOR = os.environ['SLACK_COLOR']
SLACK_MSG = os.environ['SLACK_MSG']

def slack_message(emoji, channel, color, message, token, user):
  r = requests.post("https://hooks.slack.com/services/{}".format(token), json = {"channel": channel, "username": user, "icon_emoji": emoji, "attachments": [{"color": color, "text": message}]})
  print(r.content)

slack_message(SLACK_AVATAR, SLACK_CHANNEL, SLACK_COLOR, SLACK_MSG, SLACK_TOKEN, SLACK_USERNAME)
