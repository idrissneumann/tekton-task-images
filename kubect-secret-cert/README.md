# Git set status

Create kubernetes secret from x509 certificate.

## Environment variables to set

* `LOG_LEVEL`: log level (`debug` or `info`)
* `CREATE_CERTIFICATE`: enables/disables the creation of a self-signed certificate for the external domain (`true` or `false`)
* `SECRET_NAME`: secret name for Ingress certificate. The Secret should not exist if the self-signed certificate creation is enabled
