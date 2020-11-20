#!/bin/sh

suffix=$(echo ${HOSTNAME}|sed 's/\(.*\)-.*/\1/')
pr_env_file="${TEKTON_WORKSPACE_PATH}/pr_env-${suffix}.sh"
git_script="${TEKTON_WORKSPACE_PATH}/git.sh"
env_script="${TEKTON_WORKSPACE_PATH}/env.sh"
log_script="${TEKTON_WORKSPACE_PATH}/log.sh"

[ -f "${pr_env_file}" ] && source "$pr_env_file" 

echo "export LOG_LEVEL=${LOG_LEVEL}" > "${env_script}"
echo "export GIT_BRANCH=${GIT_BRANCH}" >> "${env_script}"
echo "export REPO_ORG=${REPO_ORG}" >> "${env_script}"
echo "export REPO_NAME=${REPO_NAME}" >> "${env_script}"
echo "export WORKING_DIR=/workspace/git-\$REPO_ORG-\$REPO_NAME" >> "${env_script}"
source "${env_script}"
echo "source ${env_script}" > "${log_script}"

if [ "${LOG_LEVEL}" = "debug" ] || [ "${LOG_LEVEL}" = "DEBUG" ]; then
  echo "echo '[init][debug] Environment variables values'"  >> "${log_script}"
  echo 'env|grep -iv token|grep -iv passwd|grep -iv password' >> "${log_script}"
  echo "echo '[init][debug] Content of the current working dir'"  >> "${log_script}"
  echo 'ls -la' >> "${log_script}"
fi

echo "source ${env_script}" > "${git_script}"
[ "${LOG_LEVEL}" = "debug" ] || [ "${LOG_LEVEL}" = "DEBUG" ] && echo "echo '[git][1/4] installation'" >> "${git_script}"
echo "apk add --no-cache git" >> "${git_script}"
[ "${LOG_LEVEL}" = "debug" ] || [ "${LOG_LEVEL}" = "DEBUG" ] && echo "echo '[git][2/4] pull'" >> "${git_script}"
echo "git pull" >> "${git_script}"
[ "${LOG_LEVEL}" = "debug" ] || [ "${LOG_LEVEL}" = "DEBUG" ] && echo "echo '[git][3/4] checkout '\$GIT_BRANCH" >> "${git_script}"
echo "git checkout \$GIT_BRANCH" >> "${git_script}"
[ "${LOG_LEVEL}" = "debug" ] || [ "${LOG_LEVEL}" = "DEBUG" ] && echo "echo '[git][4/4] pull rebase '\$GIT_BRANCH" >> "${git_script}"
echo "git pull --rebase origin \$GIT_BRANCH" >> "${git_script}"

/bin/sh "${log_script}"
/bin/sh "${git_script}"

target_path="${TEKTON_WORKSPACE_PATH}"
ls -a . | while read REPLY; do 
  [ "${REPLY}" != "." ] && [ "${REPLY}" != ".." ] && cp -R $REPLY $target_path/; 
done

if [ "${LOG_LEVEL}" = "debug" ] || [ "${LOG_LEVEL}" = "DEBUG" ]; then
  echo "[github-fetch-sources][debug] Content of workspaces.path = ${target_path}"
  ls -la "${target_path}"
fi
