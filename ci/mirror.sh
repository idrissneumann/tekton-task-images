#!/bin/bash

REPO_PATH="/home/centos/tekton-task-images/"

cd "${REPO_PATH}" && git pull origin master || :
git push github master 
git push pgitlab master
git push pgithub master
exit 0
