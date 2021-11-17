#!/bin/bash

ALLOWED_BUMP_TYPES=("major minor patch")

exit_with_error_message() {
  echo "${1}"
  exit "${2}"
}

#####################################
####### ENV CHECKS ##################
#####################################

[ -z "$VERSION_PATH" ] && VERSION_PATH=".version"
[ -z "$CONSERVE_CURRENT_TAG" ] && current_tag="false"
[ -z "$CHART_MOUNT_ROOT" ] && exit_with_error_message "'CHART_MOUNT_ROOT' not set. Aborting." 1
[ -z "$CHART_ROOT" ] && exit_with_error_message "'CHART_ROOT' not set. Aborting." 1
[ -d "${CHART_MOUNT_ROOT}/$CHART_ROOT" ] || exit_with_error_message "'CHART_ROOT[${CHART_MOUNT_ROOT}/$CHART_ROOT]' does not exist. Aborting." 1
[ -z "$HELM_REGISTRY" ] && exit_with_error_message "'HELM_REGISTRY' not set. Aborting." 1
[ -z "$HELM_USER" ] && exit_with_error_message "'HELM_USER' not set. Aborting." 1
[ -z "$HELM_PASSWORD" ] && exit_with_error_message "'HELM_PASSWORD' not set. Aborting." 1

if [[ ! -f "${CHART_MOUNT_ROOT}/${CHART_ROOT}/Chart.yaml" ]]; then
  exit_with_error_message "'CHART_ROOT'[$CHART_ROOT] does not contain a valid Helm Chart. Aborting." 2
fi

current_tag="$(yq eval "${VERSION_PATH}" "${CHART_MOUNT_ROOT}/${CHART_ROOT}/Chart.yaml")"

if [[ -z $OVERRIDE_TAG && -n $CONSERVE_CURRENT_TAG && $CONSERVE_CURRENT_TAG == "true" ]]; then
  OVERRIDE_TAG="$current_tag"
fi

if [[ -z $OVERRIDE_TAG && -z $BUMP_TYPE ]]; then
  BUMP_TYPE="patch"
  echo "Defaulting to '${BUMP_TYPE}' bump"
fi

if [[ ! $OVERRIDE_TAG && ! " ${ALLOWED_BUMP_TYPES[*]} " =~ " ${BUMP_TYPE} " ]]; then
  exit_with_error_message "'BUMP_TYPE' must be one of the following values : ${ALLOWED_BUMP_TYPES}." 3
fi

#####################################
######## FUNCTIONS ##################
#####################################

generate_new_version() {
  # Transform version to array of numbers
  IFS=' ' read -r -a current_version <<<"$(echo "${1}" | grep -Eo '^([0-9]+(\-|\_|\.)[0-9]+(\-|\_|\.)[0-9]+)' | tr -d \" | tr "." ' ')"
  # Extract minor and major version numbers
  patch_version=${current_version[${#current_version[@]} - 1]}
  minor_version=${current_version[${#current_version[@]} - 2]}
  major_version=${current_version[${#current_version[@]} - 3]}

  if [[ $BUMP_TYPE == "major" ]]; then
    major_version="$((major_version + 1))"
  fi
  if [[ $BUMP_TYPE == "minor" ]]; then
    minor_version="$((minor_version + 1))"
  fi
  if [[ $BUMP_TYPE == "patch" ]]; then
    patch_version="$((patch_version + 1))"
  fi

  echo "${major_version}.${minor_version}.${patch_version}"
}

echo "Packaging chart under : ${CHART_MOUNT_ROOT}/${CHART_ROOT}"

if [[ -n $OVERRIDE_TAG ]]; then
  target_tag="${OVERRIDE_TAG}"
else
  echo "Performing '$BUMP_TYPE' bump."
  target_tag=$(generate_new_version "$current_tag")
fi

if [[ -n $TAG_SUFFIX ]]; then
  target_tag="${target_tag}-${TAG_SUFFIX}"
fi

echo "Bumping tag from $(yq eval "${VERSION_PATH}" "${CHART_MOUNT_ROOT}/${CHART_ROOT}/Chart.yaml") to ${target_tag}"
yq e "${VERSION_PATH} = \"${target_tag}\"" -i "${CHART_MOUNT_ROOT}/${CHART_ROOT}/Chart.yaml"

echo "Adding repo."
echo "${HELM_PASSWORD}" | helm repo add library "${HELM_REGISTRY}" --username="${HELM_USER}" --password-stdin
echo "Installing chart dependencies."
helm dependency update "${CHART_MOUNT_ROOT}/${CHART_ROOT}/."
echo "Linting chart."
helm lint "${CHART_MOUNT_ROOT}/${CHART_ROOT}/."
echo "Adding packaging chart."
helm package "${CHART_MOUNT_ROOT}/${CHART_ROOT}"
echo "Adding pushing chart."
helm cm-push "${CHART_MOUNT_ROOT}/${CHART_ROOT}" library
