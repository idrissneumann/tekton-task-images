FROM gcr.io/kaniko-project/executor:debug

COPY build.sh /

RUN /busybox/sh -c "chmod +x /build.sh"

CMD [ "/build.sh" ]
