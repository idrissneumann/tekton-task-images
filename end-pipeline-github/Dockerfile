FROM python:3-alpine

COPY end-pipeline-github/end-pipeline.sh /
COPY github-set-status/set-status.py /
COPY slack-result-sender/slack-result-sender.py /
COPY init-kube-config/init-kube-config.sh /
COPY destroy-pvc/destroy-pvc.sh /

RUN chmod +x /end-pipeline.sh && \
    chmod +x /set-status.py && \
    chmod +x /slack-result-sender.py && \
    chmod +x /init-kube-config.sh && \
    chmod +x /destroy-pvc.sh && \
    pip install requests

CMD ["/end-pipeline.sh"]
