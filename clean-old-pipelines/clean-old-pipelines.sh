#!/bin/bash

/init-kube-config.sh

retention_days="${RETENTION_DAYS:-1}"
kube_namespace="${NAMESPACE:-tekton-pipelines}"
project_prefixes="${PROJECT_PREFIXES}"
wait_time="${WAIT_TIME}"
should_slack="${SHOULD_SLACK}"

if [[ ! $retention_days =~ ^[0-9]+$ ]]; then
  echo "Retention day must be an integer (number of days)"
  exit 1
fi

if [[ ! $wait_time =~ ^[0-9]+$ ]]; then
  echo "Wait time day must be an integer (time in millis)"
  exit 1
fi

log_msg() {
  msg="${1}"
  echo "${msg}"
  if [[ "${should_slack}" == "on" ]]; then
    export SLACK_MSG="${msg}"
    /slack-sender.py
  fi 
}

processing() {
  kubectl -n "$kube_namespace" get pipelinerun | while read pipeline_name pipeline_status pipeline_reason pipeline_start pipeline_completion trash; do
  age_in_days=$(echo $pipeline_completion | grep -oE "[0-9]+d" | tr -d 'd')
    if [[ $age_in_days && $age_in_days -ge $retention_days ]]; then
      log_msg "Deleting ${pipeline_name} because ${age_in_days} >= ${retention_days}"
      kubectl -n "$kube_namespace" delete pipelinerun "${pipeline_name}"
    fi
  done

  kubectl -n "$kube_namespace" get pvc | while read pvc_name pvc_status pvc_volume pvc_capacity pvc_access_mode pvc_storage_class pvc_age trash; do
    if [[ $pvc_name =~ $project_prefixes.*pvc-.*$ && $pvc_access_mode == "RWO" ]]; then
      age_in_days=$(echo $pvc_age | grep -oE "[0-9]+d" | tr -d 'd')
      if [[ $age_in_days && $age_in_days -ge $retention_days ]]; then
        log_msg "Deleting ${pvc_name} because ${age_in_days} >= ${retention_days}"
        kubectl -n "$kube_namespace" delete pvc "${pvc_name}"
      fi
    fi
  done
}

while true; do
  log_msg "Cleaning pipelines and pvc that are older than ${retention_days} days (wait_time = ${wait_time})"
  processing
  sleep "${wait_time}"
done
