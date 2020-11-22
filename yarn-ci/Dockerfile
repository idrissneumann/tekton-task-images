ARG NODE_VERSION

FROM node:$NODE_VERSION-alpine

COPY yarn-ci.sh /

RUN apk add --no-cache git && \
    chmod +x /yarn-ci.sh

CMD [ "/yarn-ci.sh" ]
