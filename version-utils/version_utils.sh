#!/bin/bash

version_from_tag() {
  version="$(git describe --long 2>/dev/null|sed "s/-/\./")"
  sha="$(git rev-parse --short HEAD)"

  if [[ ! $version ]] && [[ $sha ]]; then
    branch=$(echo "${GIT_BRANCH}"|sed "s/\#//g;s/\///g")
    version="${branch}-${sha}"
  fi

  echo "${version}"
}

echo "[version_utils] Version from tag is : $(version_from_tag)"
