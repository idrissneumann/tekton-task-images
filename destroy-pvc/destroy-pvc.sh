#!/bin/sh

/init-kube-config.sh

kubectl -n "${NAMESPACE}" delete pvc "${PVC_NAME}" > kubectl.log 2>&1 &
sleep 5
cat kubectl.log

[ -f ~/.kube/config.old ] && cp -f ~/.kube/config.old ~/.kube/config

