# Helm Packager

Helm Packager, lints, packages, and delivers your Helm chart to a registry. 

## Configuration

The following environment variables are used to configure the application:

- `VERSION_PATH`:
  - _Type:_ String
  - _Description:_ The path for the version you want to bump inside your `Chart.yml`.
  - _Required:_ No
  - _Default:_ `.version`
- `CHART_MOUNT_ROOT`:
  - _Type:_ String
  - _Description:_ The path into which you have mounted your project into.
  - _Required:_ Yes
  - _Default:_ `/sa-chart`
- `CHART_ROOT`:
  - _Type:_ String
  - _Description:_ The directory of your chart root under `CHART_MOUNT_ROOT`
  - _Required:_ Yes
- `HELM_REGISTRY`:
  - _Type:_ String
  - _Description:_ The path for your Helm Registry
  - _Required:_ Yes
- `HELM_USER`:
  - _Type:_ String
  - _Description:_ The user of your Helm Registry
  - _Required:_ Yes
- `HELM_PASSWORD`:
  - _Type:_ String
  - _Description:_ The password for your Helm Registry
  - _Required:_ Yes
- `CONSERVE_CURRENT_TAG`:
  - _Type:_ Boolean
  - _Description:_ Whether to conserve the current tag or not.
  - _Required:_ No
- `OVERRIDE_TAG`:
  - _Type:_ String
  - _Description:_ The value with which you want to override the tag.
  - _Required:_ if `BUMP_TYPE` is not set.
- `BUMP_TYPE`:
  - _Type:_ Enum
    - `patch`
    - `minor`
    - `major`
  - _Description:_ The type of bump to perform
  - _Required:_ if `OVERRIDE_TAG` is not set.
- `TAG_SUFFIX`:
  - _Type:_ String
  - _Description:_ A suffix to the SemVer tag
  - _Required:_ No
- `VERBOSE`:
  - _Type:_ String
  - _Description:_ Verbosity level
  - _Required:_ No
  - _Default:_ false

## Exit Codes

* `1` : Bad environment variable configurations.
* `2` : The target is not a valid Helm Chart.
* `3` : Bad configuration on Bump Type.
* `4` : The script was unable to login to Chart Museum. 
* `5` : The script was unable to download dependencies.
* `6` : The script was unable to lint chart.
* `7` : The script was unable to packaging chart.
* `8` : The script was unable to push chart.
