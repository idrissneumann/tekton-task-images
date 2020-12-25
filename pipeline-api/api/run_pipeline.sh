#!/bin/bash

root_dir="/"
pipeline="$1"

if [[ $pipeline == "-h" || $pipeline == "--help" || ! $pipeline ]]; then
  echo "Usage: ./run_pipeline.sh {pipeline name} {git branch name} {loglevel}"
  [[ ! $pipeline || ! $root_dir ]] && exit 1 || exit 0
fi

branch="$2"
[[ ! $branch ]] && branch="develop"
branch=$(echo $branch|sed "s/^.*refs\/heads\///g"|sed "s/^.*remotes\/origin\///g")

loglevel="$3"
[[ ! $loglevel ]] && env="info"

pipeline="${pipeline}-run.tpl.yaml"
uuid=$(uuidgen|tr '[:upper:]' '[:lower:]')
branch_hash="$(echo $branch|md5sum|awk '{print $1}')"
echo "branch=${branch}, branch_hash=${branch_hash}, uuid=${uuid}, loglevel=${loglevel}"
sed "s/UNIQ_ID/${uuid}/g;s/LOG_LEVEL/${loglevel}/g;s/BRANCH_HASH/$branch_hash/g;s/BRANCH_NAME/$(echo $branch|sed "s/\//\\\\\//g")/g" $pipeline > "${pipeline}.run"
kubectl -n tekton-pipelines apply -f "${pipeline}.run"
rm -rf "${pipeline}.run"
