 #!/bin/sh

 if [ "${LOG_LEVEL}" = "debug" ] || [ "${LOG_LEVEL}" = "DEBUG" ]; then
  set -e
  echo "[create_secret] secret creation from x509 certificate with:"
  echo "CREATE_CERTIFICATE=${CREATE_CERTIFICATE}"
  echo "SECRET_NAME=${SECRET_NAME}"
fi

if [ "${CREATE_CERTIFICATE}" = "false" ]; then
  exit 0
fi

kubectl create secret tls "${SECRET_NAME}" --cert=/var/tmp/work/ingress/certificate.pem --key=/var/tmp/work/ingress/key.pem || :
