#!/bin/bash

[[ ! -d ~/.kube ]] && mkdir ~/.kube
[[ -f ~/.kube/config ]] && cp -f ~/.kube/config ~/.kube/config.old

echo 'apiVersion: v1
kind: Config
clusters:
- name: "'$KUBE_ENV'"
    cluster:
    server: "'$KUBE_URL'"

users:
- name: "'$KUBE_ENV'"
    user:
    token: "'$KUBE_TOKEN'"

contexts:
- name: "'$KUBE_ENV'"
    context:
    user: "'$KUBE_ENV'"
    cluster: "'$KUBE_ENV'"

current-context: "'$KUBE_ENV'"' > ~/.kube/config
