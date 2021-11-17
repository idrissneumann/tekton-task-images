FROM alpine/helm

ARG CHART_MOUNT_ROOT="/sa-chart"

ENV HELM_REGISTRY="" \
    CHART_MOUNT_ROOT=${CHART_MOUNT_ROOT}\
    HELM_USER="" \
    CHART_ROOT="" \
    HELM_PASSWORD=""

RUN apk update \
    && apk upgrade \
    && apk add --no-cache bash wget curl\
    && wget "$(curl -s https://api.github.com/repos/mikefarah/yq/releases/latest | grep browser_download_url | grep -v '.tar.gz' | grep linux_amd64 | cut -d '"' -f 4)" -O /usr/bin/yq \
    && chmod +x /usr/bin/yq \
    && helm plugin install https://github.com/chartmuseum/helm-push \
    && rm -rf /var/cache/apk/*

WORKDIR ${CHART_MOUNT_ROOT}
COPY script.sh /entrypoint.sh

VOLUME "${CHART_MOUNT_ROOT}"
ENTRYPOINT /entrypoint.sh
