FROM alpine

COPY version-utils/version_utils.sh /
COPY env-files-utils/env_files_utils.sh /
COPY git-fetch-sources/fetch-sources.sh /

RUN apk add --no-cache git bash && \
    chmod +x /fetch-sources.sh /env_files_utils.sh /version_utils.sh

CMD ["/fetch-sources.sh"]
