ARG BUILDKIT_TAG

FROM docker.io/moby/buildkit:${BUILDKIT_TAG}

COPY env-files-utils/env_files_utils.sh oci-build-utils/oci-build-utils.sh buildkit-build/build.sh /

RUN apk add --no-cache bash coreutils && \
    chmod +x /usr/bin/buildctl-daemonless.sh /build.sh /oci-build-utils.sh /env_files_utils.sh

CMD [ "/build.sh" ]
