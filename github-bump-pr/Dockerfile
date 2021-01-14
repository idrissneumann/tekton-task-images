FROM alpine

ENV YQ_VERSION=v4.2.1 \
    YQ_BINARY=yq_linux_amd64
    
COPY yaml-patch/yaml-patch.sh /
COPY github-bump-pr/bump.sh /
COPY github-bump-pr/reverse_branches.sh /
COPY github-bump-pr/fetch.sh /
COPY github-open-pr/open.sh /
COPY git-push-changes/git-push-changes.sh /

RUN chmod +x /yaml-patch.sh && \
    chmod +x /fetch.sh && \
    chmod +x /bump.sh && \
    chmod +x reverse_branches.sh && \
    chmod +x /open.sh && \
    chmod +x /git-push-changes.sh && \
    apk add --no-cache bash curl git && \
    curl -LO "https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/${YQ_BINARY}.tar.gz" && \
    tar xvzf ${YQ_BINARY}.tar.gz && \
    mv ${YQ_BINARY} /usr/bin/yq && \ 
    chmod +x /usr/bin/yq && \
    rm -rf ${YQ_BINARY}.tar.gz

CMD [ "/bump.sh" ]
