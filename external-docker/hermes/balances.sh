#!/bin/bash
export IFS=
if [ "$#" -ne 2 ]; then echo "usage: $0 init-directory config-file " >&2; exit 1; fi
init="$1"
config="$2"

yq < ${init}/init.toml -ptoml e .keys -o yaml |
while read -r line
do
    chain=$(echo $line|cut -d : -f1 | tr -d '[:space:]')
    echo "-- chain ${chain}"
    hermes --config ${config} keys balance --chain ${chain} 
done 