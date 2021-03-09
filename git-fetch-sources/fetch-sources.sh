#!/bin/sh

suffix=$(echo ${HOSTNAME}|sed 's/\(.*\)-.*/\1/;s/\-init?//g')
pr_env_file="${TEKTON_WORKSPACE_PATH}/pr_env-${suffix}.sh"
git_script="${TEKTON_WORKSPACE_PATH}/git.sh"
env_script="${TEKTON_WORKSPACE_PATH}/env.sh"
log_script="${TEKTON_WORKSPACE_PATH}/log.sh"
json_manifest="${TEKTON_WORKSPACE_PATH}/manifest.json"

[ -f "${pr_env_file}" ] && source "$pr_env_file" 

echo "export LOG_LEVEL=${LOG_LEVEL}" > "${env_script}"
echo "export GIT_BRANCH=${GIT_BRANCH}" >> "${env_script}"
[ -z "${REPO_ORG}" ] || echo "export REPO_ORG=${REPO_ORG}" >> "${env_script}"
[ -z "${REPO_NAME}" ] || echo "export REPO_NAME=${REPO_NAME}" >> "${env_script}"
[ -z "${REPO_URL}" ] || echo "export REPO_URL=${REPO_URL}" >> "${env_script}"
WORKING_DIR="/workspace/git-workspace"
[ -z "${REPO_ORG}" ] || [ -z "${REPO_NAME}" ] || WORKING_DIR="/workspace/git-${REPO_ORG}-${REPO_NAME}"
echo "export WORKING_DIR=${WORKING_DIR}" >> "${env_script}"
source "${env_script}"
echo "source ${env_script}" > "${log_script}"

if [ "${LOG_LEVEL}" = "debug" ] || [ "${LOG_LEVEL}" = "DEBUG" ]; then
  echo "echo '[init][debug] Environment variables values'"  >> "${log_script}"
  echo 'env|grep -iv token|grep -iv passwd|grep -iv password' >> "${log_script}"
  echo "echo '[init][debug] Content of the current working dir'"  >> "${log_script}"
  echo 'ls -la' >> "${log_script}"
fi

echo "source ${env_script}" > "${git_script}"
[ "${LOG_LEVEL}" = "debug" ] || [ "${LOG_LEVEL}" = "DEBUG" ] && echo "echo '[git][1/3] pull'" >> "${git_script}"
echo "git pull" >> "${git_script}"
[ "${LOG_LEVEL}" = "debug" ] || [ "${LOG_LEVEL}" = "DEBUG" ] && echo "echo '[git][2/3] checkout '\$GIT_BRANCH" >> "${git_script}"
echo "git checkout \$GIT_BRANCH" >> "${git_script}"
[ "${LOG_LEVEL}" = "debug" ] || [ "${LOG_LEVEL}" = "DEBUG" ] && echo "echo '[git][3/3] pull rebase '\$GIT_BRANCH" >> "${git_script}"
echo "git pull --rebase origin \$GIT_BRANCH" >> "${git_script}"

/bin/sh "${log_script}"
/bin/sh "${git_script}"

version="$(git describe --long|sed "s/-/\./")"
[ -z "${version}" ] || export DELIVERY_VERSION_FROM_TAG="${version}"
[ -z "${version}" ] || echo "export DELIVERY_VERSION_FROM_TAG=\"${version}\"" >> "${pr_env_file}"

target_path="${TEKTON_WORKSPACE_PATH}"
ls -a . | while read REPLY; do 
  [ "${REPLY}" != "." ] && [ "${REPLY}" != ".." ] && cp -R $REPLY $target_path/; 
done

if [ "${LOG_LEVEL}" = "debug" ] || [ "${LOG_LEVEL}" = "DEBUG" ]; then
  echo "[github-fetch-sources][debug] Content of workspaces.path = ${target_path}"
  ls -la "${target_path}"
fi

echo "{\"sha\": \"$(git rev-parse HEAD)\", \"tag\": \"$(git describe --tags 2>/dev/null)\", \"branch\":\"${GIT_BRANCH}\", \"repo_org\":\"${REPO_ORG}\", \"repo_name\":\"${REPO_NAME}\"}" > "${json_manifest}" 2>/dev/null || :

echo "[fetch-sources] Content of ${json_manifest}"
cat "${json_manifest}"

