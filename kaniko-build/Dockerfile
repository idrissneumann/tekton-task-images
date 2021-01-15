FROM gcr.io/kaniko-project/executor AS kaniko

FROM alpine AS image_builder

COPY --from=kaniko /kaniko /kaniko

COPY build.sh /

RUN apk add --no-cache bash && \
    chmod +x /build.sh

CMD [ "/build.sh" ]
