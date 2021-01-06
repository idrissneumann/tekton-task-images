FROM alpine

COPY open.sh /

RUN apk add --no-cache curl && \
    chmod +x /open.sh

CMD ["/open.sh"]
