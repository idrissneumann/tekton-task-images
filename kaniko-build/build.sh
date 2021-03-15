#!/bin/bash

source /env_files_utils.sh
pr_env_file="$(get_pr_env_file)"

if [[ $LOG_LEVEL == "debug" || $LOG_LEVEL == "DEBUG" ]]; then
  echo "[build-container-image][debug][pr_env_file] loading the file ${pr_env_file}"
fi

if [[ -f $pr_env_file ]]; then
  source "${pr_env_file}"
else
  echo "pr_env_file = ${pr_env_file} not exists"
fi

if [[ $LOG_LEVEL == "debug" || $LOG_LEVEL == "DEBUG" ]]; then
  echo "[build-container-image][debug] Content of the current directory"
  ls -la
fi

[[ $VERSIONING_FROM_TAG ]] || export VERSIONING_FROM_TAG="disabled"
[[ $MULTI_ENV ]] || export MULTI_ENV="disabled"

DOCKER_REGISTRY_ORG="${PROJECT_STABLE}"
if [[ ! $GIT_BRANCH =~ ^([0-9]+.[0-9]+.x|master|develop|main|prod|qa|ppd|preprod)$ ]] || [[ $FORCE_PROJECT_UNSTABLE == "enabled" ]]; then
  DOCKER_REGISTRY_ORG="${PROJECT_UNSTABLE}"
elif [[ $MULTI_ENV == "enabled" && $GIT_BRANCH == "qa" && $VERSIONING_FROM_TAG != "enabled" ]]; then
  DOCKER_REGISTRY_ORG="${PROJECT_STABLE}/qa"
elif [[ $MULTI_ENV == "enabled" && $GIT_BRANCH == "prod" && $VERSIONING_FROM_TAG != "enabled" ]]; then
  DOCKER_REGISTRY_ORG="${PROJECT_STABLE}/prod"
elif [[ $MULTI_ENV == "enabled" && $GIT_BRANCH =~ ^(ppd|preprod)$ && $VERSIONING_FROM_TAG != "enabled" ]]; then
  DOCKER_REGISTRY_ORG="${PROJECT_STABLE}/preprod"
fi

final_tag="latest"
[[ $IMAGE_TAG ]] && final_tag="${IMAGE_TAG}"
[[ $VERSIONING_FROM_TAG == "enabled" && $DELIVERY_VERSION_FROM_TAG ]] && final_tag="${DELIVERY_VERSION_FROM_TAG}"

IMAGE="${DOCKER_REGISTRY}/${DOCKER_REGISTRY_ORG}/${IMAGE}:${final_tag}"
echo "$IMAGE" > "$IMAGE_NAME_PERSISTENT_FILE"

echo "[build-container-image] Image to build = ${IMAGE}, extra args = ${EXTRA_ARGS}, multi env = ${MULTI_ENV}, versioning from tag = ${VERSIONING_FROM_TAG}, version from tag = ${DELIVERY_VERSION_FROM_TAG}"
if [[ $LOG_LEVEL == "debug" || $LOG_LEVEL == "DEBUG" ]]; then
  ls -la
fi

CACHE_OPTS=""
if [[ $ENABLE_CACHE == "enabled" || $ENABLE_CACHE == "ok" || $ENABLE_CACHE == "true" || $ENABLE_CACHE == "enabled" ]]; then
  CACHE_OPTS="--cache=true --cache-ttl=${CACHE_TTL} --cache-repo=${DOCKER_REGISTRY}/${PROJECT_UNSTABLE}/cache --cache-dir=$TEKTON_WORKSPACE_PATH"
fi

/kaniko/executor ${EXTRA_ARGS} $CACHE_OPTS --dockerfile=$DOCKERFILE --context=$TEKTON_WORKSPACE_PATH/$CONTEXT --destination=$IMAGE --oci-layout-path=$TEKTON_WORKSPACE_PATH/$CONTEXT/image-digest
