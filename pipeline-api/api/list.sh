#!/bin/bash

cd /
v=$(ls *.tpl.yaml | sed "s/\-run.tpl.yaml//g")
jq -nc '$ARGS.positional' --args ${v[@]}
