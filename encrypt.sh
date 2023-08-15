#/usr/bin/env bash
export KEY="72C2A2A23FD55033E9FACA100A4AEEEFD51A640E"
echo "key=$KEY"

rm -f token.sh.asc
gpg2 --armor --encrypt --recipient $KEY token.sh


