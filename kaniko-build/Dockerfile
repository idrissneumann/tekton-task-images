ARG KANIKO_TAG

FROM gcr.io/kaniko-project/executor:${KANIKO_TAG} AS kaniko

FROM alpine AS image_builder

COPY --from=kaniko /kaniko /kaniko

COPY env-files-utils/env_files_utils.sh oci-build-utils/oci-build-utils.sh kaniko-build/build.sh /

RUN apk add --no-cache bash coreutils && \
    chmod +x /build.sh /oci-build-utils.sh /env_files_utils.sh

CMD [ "/build.sh" ]
