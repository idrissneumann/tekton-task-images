#!/bin/bash

SRC_PATH="/home/centos/tekton-task-images/"
TARGET_PATH="/home/centos/tekton-catalog/"

cd "${TARGET_PATH}" && git pull origin master || :
cd "${SRC_PATH}" && git pull origin master || :

for i in *; do
  if [[ $i != "ci" ]] && [[ -d "${i}" ]]; then
    rm -rf "${TARGET_PATH}/${i}"
    cp -R "${i}" "${TARGET_PATH}"
  fi
done

cp docker-compose.yml "${TARGET_PATH}"
cp README.md "${TARGET_PATH}"
cp .gitignore "${TARGET_PATH}"

commit_msg=$(git log -1 --pretty=%B|sed '$ d')
[[ $commit_msg ]] || commit_msg="Automatic update"

cd "${TARGET_PATH}" && git pull origin master || :
sed -i "11,25d" README.md

git add .
git commit -m "${commit_msg}"
git push origin master 

exit 0
