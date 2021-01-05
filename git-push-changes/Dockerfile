FROM alpine

COPY git-push-changes.sh /

RUN apk add --no-cache git && \
    chmod +x /git-push-changes.sh

CMD ["/git-push-changes.sh"]
