FROM alpine

COPY env-files-utils/env_files_utils.sh /
COPY github-search-pr/search.sh /

RUN apk add --no-cache jq curl bash && \
    chmod +x /search.sh /env_files_utils.sh

CMD ["/search.sh"]
