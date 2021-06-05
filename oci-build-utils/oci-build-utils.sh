#!/bin/bash

[[ $VERSIONING_FROM_TAG ]] || export VERSIONING_FROM_TAG="disabled"
[[ $MULTI_ENV ]] || export MULTI_ENV="disabled"

source /env_files_utils.sh
pr_env_file="$(get_pr_env_file)"

if [[ $LOG_LEVEL == "debug" || $LOG_LEVEL == "DEBUG" ]]; then
  echo "[oci-build-utils][debug][pr_env_file] loading the file ${pr_env_file}"
fi

if [[ -f $pr_env_file ]]; then
  source "${pr_env_file}"
else
  echo "pr_env_file = ${pr_env_file} not exists"
fi

if [[ $LOG_LEVEL == "debug" || $LOG_LEVEL == "DEBUG" ]]; then
  echo "[oci-build-utils][debug] Content of the current directory"
  ls -la
fi

get_image_path() {
  DOCKER_REGISTRY_ORG="${PROJECT_STABLE}"
  is_unstable=""
  if [[ ! $GIT_BRANCH =~ ^([0-9]+.[0-9]+.x|master|develop|main|prod|qa|ppd|preprod)$ ]] || [[ $FORCE_PROJECT_UNSTABLE == "enabled" ]]; then
    DOCKER_REGISTRY_ORG="${PROJECT_UNSTABLE}"
    is_unstable="true"
  elif [[ $MULTI_ENV == "enabled" && $GIT_BRANCH == "qa" && $VERSIONING_FROM_TAG != "enabled" ]]; then
    DOCKER_REGISTRY_ORG="${PROJECT_STABLE}/qa"
  elif [[ $MULTI_ENV == "enabled" && $GIT_BRANCH == "prod" && $VERSIONING_FROM_TAG != "enabled" ]]; then
    DOCKER_REGISTRY_ORG="${PROJECT_STABLE}/prod"
  elif [[ $MULTI_ENV == "enabled" && $GIT_BRANCH =~ ^(ppd|preprod)$ && $VERSIONING_FROM_TAG != "enabled" ]]; then
    DOCKER_REGISTRY_ORG="${PROJECT_STABLE}/preprod"
  fi

  final_tag="latest"
  if [[ $VERSIONING_FROM_TAG == "enabled" && $DELIVERY_VERSION_FROM_TAG && ! $is_unstable ]]; then
    final_tag="${DELIVERY_VERSION_FROM_TAG}"
    [[ $IMAGE_TAG && $IMAGE_TAG != "latest" ]] && final_tag="${IMAGE_TAG}-${final_tag}"
  elif [[ $IMAGE_TAG ]]; then
    final_tag="${IMAGE_TAG}"
  fi

  echo "${DOCKER_REGISTRY}/${DOCKER_REGISTRY_ORG}/${IMAGE}:${final_tag}"
}

login_if_defined() {
  [[ ! $OCI_REGISTRY_AUTH_DIR ]] && export OCI_REGISTRY_AUTH_DIR=".docker"
  if [[ $OCI_REGISTRY && $OCI_REGISTRY_USERNAME && $OCI_REGISTRY_PASSWORD ]]; then
    mkdir -p "${OCI_REGISTRY_AUTH_DIR}"
    auth_file="${OCI_REGISTRY_AUTH_DIR}/config.json"
    echo "{\"auths\":{\"${OCI_REGISTRY}\":{\"username\":\"${OCI_REGISTRY_USERNAME}\",\"password\":\"${OCI_REGISTRY_PASSWORD}\"}}}" > "${auth_file}"

    if [[ $LOG_LEVEL == "debug" || $LOG_LEVEL == "DEBUG" ]]; then
      echo "[oci-build-utils][debug] auth_file=${auth_file}, content :"
      cat "${auth_file}"
    fi
  fi
}
