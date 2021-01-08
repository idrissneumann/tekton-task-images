FROM alpine

ENV YQ_VERSION=v4.2.1 \
    YQ_BINARY=yq_linux_amd64
    
COPY ./yaml-patch.sh /

RUN chmod +x /yaml-patch.sh && \
    apk add --no-cache moreutils curl && \
    curl -LO "https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/${YQ_BINARY}.tar.gz" && \
    tar xvzf ${YQ_BINARY}.tar.gz && \
    mv ${YQ_BINARY} /usr/bin/yq && \ 
    chmod +x /usr/bin/yq

CMD [ "/yaml-patch.sh" ]
