ARG BUILDKIT_TAG
ARG BUILDKIT_SHA

FROM docker.io/moby/buildkit:@sha256:${BUILDKIT_SHA} AS buildkit

FROM alpine AS image_builder

COPY --from=buildkit /usr/bin/buildctl /usr/bin/buildctl
COPY --from=buildkit /usr/bin/buildctl-daemonless.sh /usr/bin/buildctl-daemonless.sh

COPY env-files-utils/env_files_utils.sh oci-build-utils/oci-build-utils.sh kaniko-build/build.sh /

RUN apk add --no-cache bash coreutils && \
    chmod +x /usr/bin/buildctl-daemonless.sh /build.sh /oci-build-utils.sh /env_files_utils.sh

CMD [ "/build.sh" ]
