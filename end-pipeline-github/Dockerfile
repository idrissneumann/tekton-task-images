FROM python:3-alpine

COPY end-pipeline-github/end-pipeline.sh /
COPY env-files-utils/env_files_utils.py /
COPY github-set-status/set-status.py /
COPY slack-result-sender/slack-result-sender.py /

RUN chmod +x /env_files_utils.py && \
    chmod +x /end-pipeline.sh && \
    chmod +x /set-status.py && \
    chmod +x /slack-result-sender.py && \
    pip install requests

CMD ["/end-pipeline.sh"]
