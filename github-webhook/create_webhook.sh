#!/bin/sh

if [ -z "$GITHUB_DOMAIN" ]; then
  GITHUB_DOMAIN="github.com"
fi

if [ "${LOG_LEVEL}" = "debug" ] || [ "${LOG_LEVEL}" = "DEBUG" ]; then
  set -e
  echo "[create_webhook] Create Webhook with:"
  echo "GITHUB_DOMAIN=${GITHUB_DOMAIN}"
  echo "WEBHOOK_EVENTS=${WEBHOOK_EVENTS}"
  echo "EXTERNAL_DOMAIN=${EXTERNAL_DOMAIN}"
  echo "GITHUB_SECRET_STRING_KEY=${GITHUB_SECRET_STRING_KEY}"
  echo "REPO_ORG=${REPO_ORG}"
  echo "REPO_NAME=${REPO_NAME}"
fi

if [ "$GITHUB_DOMAIN" = "github.com" ]; then
  curl -v -d "{\"name\": \"web\",\"active\": true, \"events\": \"${WEBHOOK_EVENTS}\",\"config\": {\"url\": \"${EXTERNAL_DOMAIN}\",\"content_type\": \"json\",\"insecure_ssl\": \"1\" ,\"secret\": \"$(cat /var/secret/${GITHUB_SECRET_STRING_KEY})\"}}" -X POST -u $GITHUB_USER:$(cat /var/secret/${GITHUB_ACCESS_TOKEN_KEY}) -L "https://api.github.com/repos/${REPO_ORG}/${REPO_NAME}/hooks"
else
  curl -d "{\"name\": \"web\",\"active\": true,\"events\": \"${WEBHOOK_EVENTS}\",\"config\": {\"url\": \"${EXTERNAL_DOMAIN}\",\"content_type\": \"json\",\"insecure_ssl\": \"1\" ,\"secret\": \"$(cat /var/secret/${GITHUB_SECRET_STRING_KEY})\"}}" -X POST -u $GITHUB_USER:$(cat /var/secret/${GITHUB_ACCESS_TOKEN_KEY}) -L "https://${GITHUB_DOMAIN}/api/v3/repos/${REPO_ORG}/${REPO_NAME}/hooks"
fi
