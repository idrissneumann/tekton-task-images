FROM alpine

COPY version-utils/sync.sh /

RUN apk add --no-cache git && \
    chmod +x /sync.sh

CMD ["/sync.sh"]
