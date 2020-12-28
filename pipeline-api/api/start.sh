#!/bin/sh

/init_kube_config.sh

python3 -m flask run
