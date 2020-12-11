# State success

Yarn tasks.

## Environment variables to set

* `LOG_LEVEL`: log level (`debug` or `info`)
* `TEKTON_WORKSPACE_PATH`: the tekton workspace path which is bind to a pvc
* `YARN_INSTALL`: `enabled` if you want to run `yarn install` before the target, `disabled` otherwise
* `INSTALL_EXTRA_OPT`: yarn install extra opts (for example: `--ignore-optional --frozen-lockfile`)
* `TARGET`: yarn target (for example: `test` or `affected:test --base=remotes/origin/develop --parallel`). If you want to run only a `yarn install` command, you'll have to set it with `only_install` (and use the previous environment variables above).

## Tekton example

See the [example](./yarn-ci.yaml)
