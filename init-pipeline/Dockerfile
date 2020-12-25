FROM python:3-alpine

COPY init-pipeline/init-pipeline.sh /
COPY git-fetch-sources/fetch-sources.sh /
COPY slack-sender/slack-sender.py /

RUN chmod +x /fetch-sources.sh && \
    chmod +x /slack-sender.py && \
    chmod +x /init-pipeline.sh && \
    apk add --no-cache jq && \
    apk add --no-cache curl && \
    apk add --no-cache git && \
    pip install requests && \
    pip install git+git://github.com/broadinstitute/cromwell-tools.git@v0.3.1

CMD ["/init-pipeline.sh"]