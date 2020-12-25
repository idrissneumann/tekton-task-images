FROM alpine

COPY fetch-sources.sh /

RUN apk add --no-cache git && \
    chmod +x /fetch-sources.sh

CMD ["/fetch-sources.sh"]
