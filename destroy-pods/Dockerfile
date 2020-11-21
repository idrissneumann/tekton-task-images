FROM alpine/k8s:1.18.2

COPY init-kube-config/init-kube-config.sh /
COPY destroy-pods/destroy-pods.sh /

RUN chmod +x /init-kube-config.sh && \
    chmod +x /destroy-pods.sh

CMD [ "/destroy-pods.sh" ]
