FROM alpine

ENV K8S_VERSION=1.18.2

COPY init-kube-config/init-kube-config.sh /
COPY destroy-pods/destroy-pods.sh /

RUN chmod +x /init-kube-config.sh && \
    chmod +x /destroy-pods.sh && \
    apk add --no-cache curl && \
    curl -LO "https://storage.googleapis.com/kubernetes-release/release/v$K8S_VERSION/bin/linux/amd64/kubectl" && \
    mv ./kubectl /usr/bin/kubectl && \
    chmod +x /usr/bin/kubectl

CMD [ "/destroy-pods.sh" ]
