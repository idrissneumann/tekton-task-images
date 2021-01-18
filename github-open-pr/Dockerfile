FROM alpine

COPY open.sh /

RUN apk add --no-cache curl jq bash && \
    chmod +x /open.sh

CMD ["/open.sh"]
