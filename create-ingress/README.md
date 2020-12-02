# Git set status

Create ingress.

## Environment variables to set

* `LOG_LEVEL`: log level (`debug` or `info`)
* `NAMESPACE`: namespace of the ingress
* `SERVICE_UID`: the uid of the service. If set, this creates an owner reference on the service
* `SERVICE_NAME`: the name of the Service used in the Ingress. This will also be the name of the Ingress
* `SERVICE_PORT`: the service port that the ingress is being created on
* `EXTERNAL_DOMAIN`: the external domain for the EventListener (ex: `$(params.EventListenerName).PROXYIP.nip.io`)
* `CERTIFICATE_SECRET_NAME`: cecret name for Ingress certificate. The Secret should not exist if the self-signed certificate creation is enabled

## Tekton example

See the [example](./create-ingress.yaml)
