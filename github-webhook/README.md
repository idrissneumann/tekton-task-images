# Git set status

Set a status to the last commit (you need to play the task [`github-search-pr`](../github-search-pr) before this one).

## Environment variables to set

* `LOG_LEVEL`: log level (`debug` or `info`)
* `REPO_ORG`: github repo org
* `REPO_NAME`: github repo name
* `GITHUB_DOMAIN`: domain of github (to override for github enterprise, default )
* `WEBHOOK_EVENTS`: array webhook events (for example `[\"push\",\"pull_request\"]`)
* `EXTERNAL_DOMAIN`: the external domain for the EventListener (ex: `$(params.EventListenerName).<PROXYIP>.nip.io`)
* `GITHUB_SECRET_STRING_KEY`: the github secret string key name
* `GITHUB_USER`: the github user
* `GITHUB_ACCESS_TOKEN_KEY`: the github access token key name

## Tekton example

See the [example](./github-webhook.yaml)
