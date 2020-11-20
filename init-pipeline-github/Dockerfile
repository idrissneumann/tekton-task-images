FROM broadinstitute/python-requests:3

ENV JQ_VERSION 1.6

COPY init-pipeline-github/init-pipeline.sh /
COPY github-search-pr/search.sh /
COPY github-set-status/set-status.py /
COPY github-add-comment/add-comment.py /
COPY git-fetch-sources/fetch-sources.sh /
COPY slack-sender/slack-sender.py /

RUN chmod +x /search.sh && \
    chmod +x /fetch-sources.sh && \
    chmod +x /add-comment.py && \
    chmod +x /slack-sender.py && \
    chmod +x /set-status.py && \
    chmod +x /init-pipeline.sh && \
    apt-get update && apt-get install -y curl wget build-essential && \
    wget https://github.com/stedolan/jq/releases/download/jq-$JQ_VERSION/jq-$JQ_VERSION.tar.gz && \
    tar -zxf jq-$JQ_VERSION.tar.gz && \
    cd jq-$JQ_VERSION && \
    ./configure && make && sudo make install

CMD ["/bin/sh", "/init-pipeline.sh"]