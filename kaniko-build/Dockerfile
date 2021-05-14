ARG KANIKO_TAG

FROM gcr.io/kaniko-project/executor:${KANIKO_TAG} AS kaniko

FROM alpine AS image_builder

COPY --from=kaniko /kaniko /kaniko

COPY env-files-utils/env_files_utils.sh /
COPY kaniko-build/build.sh /

RUN apk add --no-cache bash coreutils && \
    chmod +x /build.sh /env_files_utils.sh

CMD [ "/build.sh" ]
