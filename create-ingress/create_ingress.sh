#!/bin/bash

if [ "${LOG_LEVEL}" = "debug" ] || [ "${LOG_LEVEL}" = "DEBUG" ]; then
  set -e
  echo "[create_ingress] ingress creation with:"
  echo "SERVICE_UID=${SERVICE_UID}"
  echo "SERVICE_NAME=${SERVICE_NAME}"
  echo "SERVICE_PORT=${SERVICE_PORT}"
  echo "EXTERNAL_DOMAIN=${EXTERNAL_DOMAIN}"
  echo "CERTIFICATE_SECRET_NAME=${CERTIFICATE_SECRET_NAME}"
fi

ingress_file="/ingress.yaml"
if [ -n "${SERVICE_UID}" ]; then
  sed "s/##SERVICE_UID/$SERVICE_UID/g;s/##NAMESPACE/$NAMESPACE/g;s/##SERVICE_NAME/$SERVICE_NAME/g;s/##SERVICE_PORT/$SERVICE_PORT/g;s/##EXTERNAL_DOMAIN/$EXTERNAL_DOMAIN/g;s/##CERTIFICATE_SECRET_NAME/$CERTIFICATE_SECRET_NAME/g" "/ingress-service-uid.tpl.yaml" > "${ingress_file}"
else
  sed "s/##SERVICE_NAME/$SERVICE_NAME/g;s/##NAMESPACE/$NAMESPACE/g;s/##SERVICE_PORT/$SERVICE_PORT/g;s/##EXTERNAL_DOMAIN/$EXTERNAL_DOMAIN/g;s/##CERTIFICATE_SECRET_NAME/$CERTIFICATE_SECRET_NAME/g" "/ingress.tpl.yaml" > "${ingress_file}"    
fi

if [ "${LOG_LEVEL}" = "debug" ] || [ "${LOG_LEVEL}" = "DEBUG" ]; then
  echo "[create_ingress] Content of the yaml ingress that will be applied"
  cat "${ingress_file}"
fi

kubectl apply -n "${NAMESPACE}" -f "${ingress_file}"
