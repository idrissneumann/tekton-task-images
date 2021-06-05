#!/bin/bash

source /oci-build-utils.sh

export IMAGE="$(get_image_path)"
echo "$IMAGE" > "$IMAGE_NAME_PERSISTENT_FILE"

login_if_defined

echo "[build-container-image] Image to build = ${IMAGE}, extra args = ${EXTRA_ARGS}, multi env = ${MULTI_ENV}, versioning from tag = ${VERSIONING_FROM_TAG}, version from tag = ${DELIVERY_VERSION_FROM_TAG}"
if [[ $LOG_LEVEL == "debug" || $LOG_LEVEL == "DEBUG" ]]; then
  ls -la
fi

CACHE_OPTS=""
if [[ $ENABLE_CACHE == "enabled" || $ENABLE_CACHE == "ok" || $ENABLE_CACHE == "true" || $ENABLE_CACHE == "enabled" ]]; then
  CACHE_OPTS="--cache=true --cache-ttl=${CACHE_TTL} --cache-repo=${DOCKER_REGISTRY}/${PROJECT_UNSTABLE}/cache --cache-dir=$TEKTON_WORKSPACE_PATH"
fi

[[ $RETRY_NUMBER =~ ^[0-9]+$ ]] || export RETRY_NUMBER="5"

RETRY_OPT=""
[[ $RETRY_NUMBER =~ ^[0-9]+$ && $RETRY_NUMBER -gt 0 ]] && RETRY_OPT="--push-retry ${RETRY_NUMBER}"

/kaniko/executor $EXTRA_ARGS $CACHE_OPTS $RETRY_OPT --dockerfile=$DOCKERFILE --context=$TEKTON_WORKSPACE_PATH/$CONTEXT --destination=$IMAGE --oci-layout-path=$TEKTON_WORKSPACE_PATH/$CONTEXT/image-digest
