ARG K8S_VERSION

FROM alpine

COPY init-kube-config/init-kube-config.sh /
COPY destroy-pods/destroy-pods.sh /

RUN chmod +x /init-kube-config.sh && \
    chmod +x /destroy-pods.sh && \
    curl -L https://storage.googleapis.com/kubernetes-release/release/v${K8S_VERSION}/bin/linux/amd64/kubectl -O /usr/bin/kubectl && \
    chmod +x /usr/bin/kubectl

CMD [ "/destroy-pods.sh" ]
