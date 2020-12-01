# Git set status

Create x509 certificate.

## Environment variables to set

* `CREATE_CERTIFICATE`: enables/disables the creation of a self-signed certificate for the external domain (`true` or `false`)
* `CERTIFICATE_KEY_PASSPHRASE`: phrase that protects private key. This must be provided when the self-signed certificate is created
* `EXTERNAL_DOMAIN`: the external domain for the EventListener (ex: `$(params.EventListenerName).PROXYIP.nip.io`)
