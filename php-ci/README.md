# State success

Php ci tasks (composer, phpunit, phpcs, psalm).

## Environment variables to set

* `LOG_LEVEL`: log level (`debug` or `info`)
* `TEKTON_WORKSPACE_PATH`: the tekton workspace path which is bind to a pvc
* `SRC_DIR`: relative path containing the php sources (default: `src/`)
* `ENABLE_COMPOSER_INSTALL`: `enabled` if you want to run `composer install --prefer-dist --no-progress --no-suggest`, `disabled` otherwise
* `ENABLE_PHPCS`: `enabled` if you want to run `./vendor/bin/phpcs src/`, `disabled` otherwise
* `ENABLE_PSALM`: `enabled` if you want to run `./vendor/bin/psalm -c=psalm.xml`, `disabled` otherwise
* `PSALM_FILE`: psalm xml file (default `psalm.xml`)
* `ENABLE_PHPUNIT`: `enabled` if you want to run `../vendor/bin/phpunit`, `disabled` otherwise

## Tekton example

See the [example](./php-ci.yaml)
