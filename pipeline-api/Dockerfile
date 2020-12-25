FROM python:3-alpine

ENV K8S_VERSION=1.18.2 \
    FLASK_APP=/api.py \
    FLASK_RUN_HOST=0.0.0.0 \
    FLASK_RUN_PORT=8080 \
    WERKZEUG_RUN_MAIN=true \
    MANIFEST_FILE_PATH=/manifest.json

COPY ./tekton-pipelines/base/pipeline_api/api/start.sh ./tekton-pipelines/base/pipeline_api/api/list.sh ./tekton-pipelines/base/pipeline_api/api/init_kube_config.sh ./tekton-pipelines/base/pipeline_api/api/api.py ./manifest.json ./tekton-pipelines/base/pipeline_api/api/run_pipeline.sh / 
COPY ./tekton-pipelines/base/pipeline_api/templates /

RUN apk add --no-cache jq && \
    apk add --no-cache curl && \
    apk add --no-cache bash && \
    apk add --no-cache util-linux && \
    curl -LO "https://storage.googleapis.com/kubernetes-release/release/v$K8S_VERSION/bin/linux/amd64/kubectl" && \
    mv ./kubectl /usr/bin/kubectl && \
    chmod +x /usr/bin/kubectl && \
    pip3 install flask-restful && \
    chmod +x /run_pipeline.sh && \
    chmod +x /start.sh && \
    chmod +x /list.sh && \
    chmod +x /init_kube_config.sh

EXPOSE 8080

CMD ["/start.sh"]
