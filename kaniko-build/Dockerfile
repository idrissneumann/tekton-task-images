ARG KANIKO_TAG

FROM gcr.io/kaniko-project/executor:${KANIKO_TAG} AS kaniko

FROM alpine AS image_builder

COPY --from=kaniko /kaniko /kaniko

COPY git-fetch-sources/fetch-sources.sh /
COPY kaniko-build/build.sh /

RUN apk add --no-cache bash && \
    chmod +x /build.sh /env_files_utils.sh

CMD [ "/build.sh" ]
