ARG K8S_VERSION

FROM alpine/k8s:${K8S_VERSION} AS k8s_dep

FROM alpine AS tekton_utils

COPY init-kube-config/init-kube-config.sh /
COPY destroy-pods/destroy-pods.sh /
COPY --from=k8s_dep /usr/bin/kubectl /usr/bin/kubectl

RUN chmod +x /init-kube-config.sh && \
    chmod +x /destroy-pods.sh

CMD [ "/destroy-pods.sh" ]
