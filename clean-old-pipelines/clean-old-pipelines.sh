#!/bin/bash

/init-kube-config.sh

retention_days="${RETENTION_DAYS:-1}"
kube_namespace="${NAMESPACE:-tekton-pipelines}"
project_prefixes="${PROJECT_PREFIXES}"
wait_time="${WAIT_TIME}"
should_slack="${SHOULD_SLACK}"
max_pipelines="${MAX_PIPELINES_KEEP}"
enable_destroy_pvc="${ENABLE_DESTROY_PVC}"

if [[ ! $max_pipelines =~ ^[0-9]+$ && $max_pipelines != "disabled" ]]; then
  echo "Max pipelines to keep must be an integer"
  exit 1
fi

if [[ ! $retention_days =~ ^[0-9]+$ && $retention_days != "disabled" ]]; then
  echo "Retention day must be an integer (number of days)"
  exit 1
fi

if [[ ! $wait_time =~ ^[0-9]+$ && $wait_time != "disabled" ]]; then
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
  log_msg "Cleaning pipelines and pvc with max_pipelines=${max_pipelines}, retention_days=${retention_days}, enable_destroy_pvc=${enable_destroy_pvc}, wait_time=${wait_time}"

  if [[ $max_pipelines =~ ^[0-9]+$ ]]; then
    log_msg "Keeping only the ${max_pipelines} more recent pipelines"
    tkn -n "$kube_namespace" pipelinerun delete --keep "${max_pipelines}" -f
  fi

  if [[ $retention_days =~ ^[0-9]+$ ]]; then
    kubectl -n "$kube_namespace" get pipelinerun | while read pipeline_name pipeline_status pipeline_reason pipeline_start pipeline_completion trash; do
    age_in_days=$(echo $pipeline_completion | grep -oE "[0-9]+d" | tr -d 'd')
      if [[ $age_in_days && $age_in_days -ge $retention_days ]]; then
        log_msg "Deleting ${pipeline_name} because ${age_in_days} >= ${retention_days}"
        tkn -n "$kube_namespace" pipelinerun delete "${pipeline_name}" -f
      fi
    done
  fi

  if [[ $enable_destroy_pvc == "enabled" && $retention_days =~ ^[0-9]+$ ]]; then
    kubectl -n "$kube_namespace" get pvc | while read pvc_name pvc_status pvc_volume pvc_capacity pvc_access_mode pvc_storage_class pvc_age trash; do
      if [[ $pvc_name =~ $project_prefixes.*pvc-.*$ && $pvc_access_mode == "RWO" ]]; then
        age_in_days=$(echo $pvc_age | grep -oE "[0-9]+d" | tr -d 'd')
        if [[ $age_in_days && $age_in_days -ge $retention_days ]]; then
          log_msg "Deleting ${pvc_name} because ${age_in_days} >= ${retention_days}"
          kubectl -n "$kube_namespace" delete pvc "${pvc_name}"
        fi
      fi
    done
  fi
}

if [[ $wait_time =~ ^[0-9]+$ ]]; then
  while true; do
    processing
    sleep "${wait_time}"
  done
else
  processing
fi
