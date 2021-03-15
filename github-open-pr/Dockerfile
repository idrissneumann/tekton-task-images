FROM alpine

COPY github-open-pr/open.sh /
COPY env-files-utils/env_files_utils.sh /

RUN apk add --no-cache curl jq bash && \
    chmod +x /open.sh /env_files_utils.sh

CMD ["/open.sh"]
