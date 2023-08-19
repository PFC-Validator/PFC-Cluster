#/usr/bin/env bash


for i in config.yaml.asc 
do
    export decryptfile=$(basename  -s .asc $i)

    if [ -f "$decryptfile" ]; then
        echo skipping $decryptfile
    else 
        gpg2 --output $decryptfile --decrypt   $i     
    fi 

done
 