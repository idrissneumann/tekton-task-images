FROM alpine/k8s:1.18.2

COPY init-kube-config/init-kube-config.sh /
COPY kill-redundant-pipelines/kill-redundant-pipelines.sh /

RUN chmod +x /init-kube-config.sh && \
    chmod +x /kill-redundant-pipelines.sh

CMD [ "/kill-redundant-pipelines.sh" ]
