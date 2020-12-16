ARG NODE_VERSION

FROM node:$NODE_VERSION-alpine

COPY yarn-checks.sh /

RUN apk add --no-cache git && \
    chmod +x /yarn-checks.sh

CMD [ "/yarn-checks.sh" ]
