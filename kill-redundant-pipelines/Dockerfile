ARG K8S_VERSION

FROM alpine/k8s:${K8S_VERSION} AS k8s_dep

FROM alpine AS tekton_utils

COPY --from=k8s_dep /usr/bin/kubectl /usr/bin/kubectl
COPY init-kube-config/init-kube-config.sh /
COPY kill-redundant-pipelines/kill-redundant-pipelines.sh /

RUN chmod +x /init-kube-config.sh && \
    chmod +x /kill-redundant-pipelines.sh

CMD [ "/kill-redundant-pipelines.sh" ]
