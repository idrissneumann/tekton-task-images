FROM python:3-alpine

COPY init-pipeline-github/init-pipeline.sh /
COPY github-search-pr/search.sh /
COPY github-set-status/set-status.py /
COPY github-add-comment/add-comment.py /
COPY git-fetch-sources/fetch-sources.sh /
COPY slack-sender/slack-sender.py /
COPY slack-start-pipeline/slack-start.sh /

RUN chmod +x /search.sh && \
    chmod +x /fetch-sources.sh && \
    chmod +x /add-comment.py && \
    chmod +x /slack-sender.py && \
    chmod +x /slack-start.sh && \
    chmod +x /set-status.py && \
    chmod +x /init-pipeline.sh && \
    apk add --no-cache jq && \
    apk add --no-cache curl && \
    apk add --no-cache git && \
    pip install requests && \
    pip install git+git://github.com/broadinstitute/cromwell-tools.git@v0.3.1

CMD ["/init-pipeline.sh"]
