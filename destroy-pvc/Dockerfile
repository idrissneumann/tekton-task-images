FROM alpine

ENV K8S_VERSION=1.18.2

COPY init-kube-config/init-kube-config.sh /
COPY destroy-pvc/destroy-pvc.sh /

RUN chmod +x /init-kube-config.sh && \
    chmod +x /destroy-pvc.sh && \
    apk add --no-cache curl && \
    curl -L https://storage.googleapis.com/kubernetes-release/release/v${K8S_VERSION}/bin/linux/amd64/kubectl -O /usr/bin/kubectl && \
    chmod +x /usr/bin/kubectl

CMD [ "/destroy-pvc.sh" ]
