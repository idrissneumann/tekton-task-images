FROM alpine

COPY git-fetch-sources/fetch-sources.sh /
COPY state-success/state-success.sh /

RUN apk add --no-cache bash && \
    chmod +x /state-success.sh /env_files_utils.sh

CMD ["/state-success.sh"]
