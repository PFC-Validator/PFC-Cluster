#/usr/bin/env bash
export KEY="72C2A2A23FD55033E9FACA100A4AEEEFD51A640E"
echo "key=$KEY"

for i in *.crt *.key
do
    echo $i
    rm -f $i.gpg 
    rm -f $i.asc
    gpg2 --armor --encrypt --recipient $KEY  $i 
done
pushd etcd
for i in *.crt *.key
do
    echo $i
    rm -f $i.gpg
    rm -f $i.asc

    gpg2 --armor --encrypt --recipient $KEY  $i 
done
popd 