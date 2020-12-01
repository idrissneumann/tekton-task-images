#!/bin/sh

if [ "${LOG_LEVEL}" = "debug" ] || [ "${LOG_LEVEL}" = "DEBUG" ]; then
  set -e
  echo "[generate_certificate] x509 certificate creation with:"
  echo "CREATE_CERTIFICATE=${CREATE_CERTIFICATE}"
  echo "EXTERNAL_DOMAIN=${EXTERNAL_DOMAIN}"
fi

if [ "${CREATE_CERTIFICATE}" = "false" ]; then
  exit 0
fi

mkdir /var/tmp/work/ingress
openssl genrsa -des3 -out /var/tmp/work/ingress/key.pem -passout pass:$CERTIFICATE_KEY_PASSPHRASE 2048
openssl req -x509 -new -nodes -key /var/tmp/work/ingress/key.pem -sha256 -days 1825 -out /var/tmp/work/ingress/certificate.pem -passin pass:$CERTIFICATE_KEY_PASSPHRASE -subj /CN=$EXTERNAL_DOMAIN
openssl rsa -in /var/tmp/work/ingress/key.pem -out /var/tmp/work/ingress/key.pem -passin pass:$CERTIFICATE_KEY_PASSPHRASE
