#!/bin/bash
if [ "$#" -ne 2 ]; then echo "usage: $0 init-directory config-file " >&2; exit 1; fi
init="$1"
config="$2"

export IFS=
seeds=$(yq < ${init}/init.toml -ptoml e .seeds -o yaml)
paths=$(yq < ${init}/init.toml -ptoml e .paths -o yaml)
keys=$(yq < ${init}/init.toml -ptoml e .keys -o yaml)

yq < ${init}/init.toml -ptoml e .keys -o yaml |
while read -r line
do
    chain=$(echo $line|cut -d : -f1 | tr -d '[:space:]')
    keyval=$(echo $line|cut -d : -f2 | tr -d '[:space:]')
    path=$(echo $paths | grep $chain | cut -d : -f2 | tr -d '[:space:]')
    seed=$(echo $seeds | grep $keyval | cut -d : -f2 | tr -d '[:space:]')
    if [ "$path" == "\"\"" ];
    then
        hermes --config ${config} keys add --overwrite --chain ${chain} --mnemonic-file ${seed}
    else
        hermes --config ${config} keys add --overwrite --hd-path "${path}" --chain ${chain} --mnemonic-file ${seed}
    fi
done 