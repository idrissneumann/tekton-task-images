FROM alpine

ENV K8S_VERSION=1.18.2

COPY init-kube-config/init-kube-config.sh /
COPY clean-old-pipelines/clean-old-pipelines.sh /

RUN apk add --no-cache curl && \
    apk add --no-cache bash && \
    curl -LO "https://storage.googleapis.com/kubernetes-release/release/v$K8S_VERSION/bin/linux/amd64/kubectl" && \
    mv ./kubectl /usr/bin/kubectl && \
    chmod +x /usr/bin/kubectl && \
    chmod +x /init-kube-config.sh && \
    chmod +x /clean-old-pipelines.sh

CMD [ "/clean-old-pipelines.sh" ]

