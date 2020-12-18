ARG K8S_VERSION

FROM alpine

COPY init-kube-config/init-kube-config.sh /
COPY kill-redundant-pipelines/kill-redundant-pipelines.sh /

RUN chmod +x /init-kube-config.sh && \
    chmod +x /kill-redundant-pipelines.sh && \
    apk add --no-cache curl && \
    curl -L https://storage.googleapis.com/kubernetes-release/release/v${K8S_VERSION}/bin/linux/amd64/kubectl -O /usr/bin/kubectl && \
    chmod +x /usr/bin/kubectl

CMD [ "/kill-redundant-pipelines.sh" ]
