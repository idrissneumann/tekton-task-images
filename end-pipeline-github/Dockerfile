FROM python:3-alpine

COPY end-pipeline-github/end-pipeline.sh /
COPY github-set-status/set-status.py /
COPY slack-result-sender/slack-result-sender.py /
COPY --from=k8s_dep /usr/bin/kubectl /usr/bin/kubectl

RUN chmod +x /end-pipeline.sh && \
    chmod +x /set-status.py && \
    chmod +x /slack-result-sender.py && \
    pip install requests

CMD ["/end-pipeline.sh"]
