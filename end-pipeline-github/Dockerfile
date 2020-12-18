
FROM alpine/k8s:1.18.2 AS k8s_dep
 
FROM python:3-alpine AS end_pipeline

COPY end-pipeline-github/end-pipeline.sh /
COPY github-set-status/set-status.py /
COPY slack-result-sender/slack-result-sender.py /
COPY init-kube-config/init-kube-config.sh /
COPY destroy-pvc/destroy-pvc.sh /
COPY --from=k8s_dep /usr/bin/kubectl /usr/local/bin/kubectl

RUN chmod +x /end-pipeline.sh && \
    chmod +x /set-status.py && \
    chmod +x /slack-result-sender.py && \
    chmod +x /init-kube-config.sh && \
    chmod +x /destroy-pvc.sh && \
    pip install requests

CMD ["/end-pipeline.sh"]
