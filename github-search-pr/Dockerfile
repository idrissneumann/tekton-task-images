FROM alpine

COPY search.sh /

RUN apk add --no-cache jq && \
    apk add --no-cache curl && \
    chmod +x /search.sh

CMD ["/search.sh"]