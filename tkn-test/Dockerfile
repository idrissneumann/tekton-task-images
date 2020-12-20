FROM alpine

ENV TKN_VERSION=0.15.0

COPY tkn-test.sh /

RUN curl -LO "https://github.com/tektoncd/cli/releases/download/v${TKN_VERSION}/tkn_${TKN_VERSION}_Linux_x86_64.tar.gz" && \
    sudo tar xvzf "tkn_${TKN_VERSION}_Linux_x86_64.tar.gz" -C /usr/bin/ tkn && \
    mv ./tkn /usr/bin/tkn && \
    chmod +x /usr/bin/tkn

CMD [ "/tkn-test.sh" ]
