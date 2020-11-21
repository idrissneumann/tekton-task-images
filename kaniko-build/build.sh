#!/busybox/sh

[ "${LOG_LEVEL}" == "debug" ] || [ "${LOG_LEVEL}" == "DEBUG" ] && set -x

if [ "${LOG_LEVEL}" == "debug" ] || [ "${LOG_LEVEL}" == "DEBUG" ]; then
    echo "[build-container-image][debug] Content of the current directory"
    ls -la
fi

DOCKER_REGISTRY_ORG=$PROJECT_STABLE
if [ "${GIT_BRANCH}" != "develop" ] && [ "${GIT_BRANCH}" != "main" ] && [ "${GIT_BRANCH}" != "master" ] && ! echo "${GIT_BRANCH}"|grep -E "^[0-9]+.[0-9]+.x$" > /dev/null || [ "${FORCE_PROJECT_UNSTABLE}" == "enabled" ]; then
    DOCKER_REGISTRY_ORG=$PROJECT_UNSTABLE
fi

IMAGE="${DOCKER_REGISTRY}/${DOCKER_REGISTRY_ORG}/${IMAGE}:${IMAGE_TAG}"
echo "$IMAGE" > "$IMAGE_NAME_PERSISTENT_FILE"

if [ "${LOG_LEVEL}" == "debug" ] || [ "${LOG_LEVEL}" == "DEBUG" ]; then
    echo "[build-container-image][debug] Image to build = ${IMAGE}, extra args = ${EXTRA_ARGS}"
    ls -la
fi

CACHE_OPTS=""
if [ "${ENABLE_CACHE}" == "enabled" ] || [ "${ENABLE_CACHE}" == "ok" ] || [ "${ENABLE_CACHE}" == "true" ] || [ "${ENABLE_CACHE}" == "enabled" ]; then
    CACHE_OPTS="--cache=true --cache-ttl=${CACHE_TTL} --cache-repo=${DOCKER_REGISTRY}/${PROJECT_UNSTABLE}/cache --cache-dir=$TEKTON_WORKSPACE_PATH"
fi

/kaniko/executor ${EXTRA_ARGS} $CACHE_OPTS --dockerfile=$DOCKERFILE --context=$TEKTON_WORKSPACE_PATH/$CONTEXT --destination=$IMAGE --oci-layout-path=$TEKTON_WORKSPACE_PATH/$CONTEXT/image-digest