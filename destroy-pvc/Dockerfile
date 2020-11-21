FROM alpine/k8s:1.18.2

COPY init-kube-config/init-kube-config.sh /
COPY destroy-pvc/destroy-pvc.sh /

RUN chmod +x /init-kube-config.sh && \
    chmod +x /destroy-pvc.sh

CMD [ "/destroy-pvc.sh" ]
