FROM lachlanevenson/k8s-kubectl:latest

COPY create_ingress.sh ingress-service-uid.tpl.yaml ingress.tpl.yaml /

RUN chmod +x /create_ingress.sh

CMD ["/create_ingress.sh"]
