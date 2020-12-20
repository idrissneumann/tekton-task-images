#!/bin/sh


tkn -n tekton-pipelines pipelinerun list

echo "===== Test delete"
tkn -n tekton-pipelines pipelinerun list|awk '{if($NF == "Succeeded") {print $1}}'|tail -n1|xargs tkn -n tekton-pipelines pipelinerun delete

echo "==== Test cancel"
tkn -n tekton-pipelines pipelinerun list|awk '{if($NF == "Succeeded") {print $1}}'|tail -n1|xargs tkn -n tekton-pipelines pipelinerun cancel
