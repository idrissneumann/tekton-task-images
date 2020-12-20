FROM alpine

ENV K8S_VERSION=1.18.2 \
    TKN_VERSION=0.15.0

COPY init-kube-config/init-kube-config.sh /
COPY kill-redundant-pipelines/kill-redundant-pipelines.sh /

RUN chmod +x /init-kube-config.sh && \
    chmod +x /kill-redundant-pipelines.sh && \
    apk add --no-cache curl && \
    apk add --no-cache jq && \
    curl -LO "https://github.com/tektoncd/cli/releases/download/v${TKN_VERSION}/tkn_${TKN_VERSION}_Linux_x86_64.tar.gz" && \
    tar xvzf "tkn_${TKN_VERSION}_Linux_x86_64.tar.gz" -C /usr/bin/ tkn && \
    curl -LO "https://storage.googleapis.com/kubernetes-release/release/v$K8S_VERSION/bin/linux/amd64/kubectl" && \
    mv ./kubectl /usr/bin/kubectl && \
    chmod +x /usr/bin/tkn && \
    chmod +x /usr/bin/kubectl

CMD [ "/kill-redundant-pipelines.sh" ]
