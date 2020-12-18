FROM alpine

ENV K8S_VERSION=1.18.2

RUN apk add --no-cache curl && \
    curl -L https://storage.googleapis.com/kubernetes-release/release/v${K8S_VERSION}/bin/linux/amd64/kubectl -O /usr/bin/kubectl && \
    chmod +x /usr/bin/kubectl
