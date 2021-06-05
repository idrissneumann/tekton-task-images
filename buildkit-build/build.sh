#!/bin/bash

source /oci-build-utils.sh

export IMAGE="$(get_image_path)"

[[ ! $OCI_REGISTRY_AUTH_DIR ]] && export OCI_REGISTRY_AUTH_DIR=".docker"
if [[ $OCI_REGISTRY && $OCI_REGISTRY_USERNAME && $OCI_REGISTRY_PASSWORD ]]; then
  mkdir -p "${OCI_REGISTRY_AUTH_DIR}"
  echo "{\"auths\":{\"${OCI_REGISTRY}\":{\"auth\":\"$(echo -n ${OCI_REGISTRY_USERNAME}:${OCI_REGISTRY_PASSWORD} | base64 | tr -d \\n)\"}}}" > "${OCI_REGISTRY_AUTH_DIR}/config.json"
fi

echo "[build-container-image] Image to build = ${IMAGE}, extra args = ${EXTRA_ARGS}, multi env = ${MULTI_ENV}, versioning from tag = ${VERSIONING_FROM_TAG}, version from tag = ${DELIVERY_VERSION_FROM_TAG}"
DEBUG_OPT=""
[[ ! $BASE_OPTS ]] && export BASE_OPTS="--progress=plain --frontend=dockerfile.v0"
[[ ! $PUSH_OPTS ]] && export PUSH_OPTS="--output type=image,name=$IMAGE,push=true"
[[ ! $EXTRA_ARGS ]] && export EXTRA_ARGS=""
DOCKER_CONTEXT="${TEKTON_WORKSPACE_PATH}/${CONTEXT}"

if [[ $LOG_LEVEL == "debug" || $LOG_LEVEL == "DEBUG" ]]; then
  ls -la
  DEBUG_OPT="--debug"
fi

CACHE_OPTS=""
if [[ $ENABLE_CACHE == "enabled" || $ENABLE_CACHE == "ok" || $ENABLE_CACHE == "true" || $ENABLE_CACHE == "enabled" ]]; then
  CACHE_OPTS="--export-cache type=inline --import-cache type=registry,ref=$IMAGE"
fi

[[ $RETRY_NUMBER =~ ^[0-9]+$ ]] || export RETRY_NUMBER="100"
export BUILDCTL_CONNECT_RETRIES_MAX="${RETRY_NUMBER}"

/usr/bin/buildctl-daemonless.sh $DEBUG_OPT build $BASE_OPTS --opt filename=$DOCKERFILE --local context=$DOCKER_CONTEXT --local dockerfile=$DOCKER_CONTEXT $PUSH_OPTS $CACHE_OPTS $EXTRA_ARGS
