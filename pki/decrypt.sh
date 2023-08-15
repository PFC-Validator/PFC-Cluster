#/usr/bin/env bash


for i in *.asc 
do
    export decryptfile=$(basename  -s .asc $i)

    if [ -f "$decryptfile" ]; then
        echo skipping $decryptfile
    else 
        gpg2 --output $decryptfile --decrypt   $i     
    fi 

done

pushd etcd
for i in *.asc 
do
    export decryptfile=$(basename  -s .asc $i)

    if [ -f "$decryptfile" ]; then
        echo skipping $decryptfile
    else 
        gpg2 --output $decryptfile --decrypt   $i     
    fi 

done
popd 