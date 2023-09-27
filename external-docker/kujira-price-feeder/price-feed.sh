#!/bin/sh
#APISERVER=$1
#RPCSERVER=$2
#GRPCSERVER=$3
#CONFIGFILE=$4
#ADDRESS=$5
#VALIDATOR=$6
#SEEDPHRASE=$7

##if [ "$#" -ne 7 ]; 
#then 
#    echo /home/user/price-feed.sh APISERVER RPCSERVER GRPCSERVER CONFIGFILE ADDRESS VALIDATOR SEEDPHRASE 
#    exit 1;
#fi

echo using the following
echo APISERVER=$APISERVER
echo RPCSERVER=$RPCSERVER
echo GRPCSERVER=$GRPCSERVER
echo CONFIGFILE=$CONFIGFILE
echo ADDRESS=$ADDRESS
echo VALIDATOR=$VALIDATOR
echo SEEDPHRASE=XXXXX

if [ "$CONFIGFILE" != "${CONFIGFILE#http://}" ] ; then
    curl -s -LO /home/user/config.original $CONFIGFILE
elif [ "$CONFIGFILE" != "${CONFIGFILE#http://}" ]  ;then
    curl -s -LO /home/user/config.original $CONFIGFILE
else
    cp $CONFIGFILE /home/user/config.original
fi

sed -e 's#\$API#'"${APISERVER}"'#g' /home/user/config.original > /home/user/config.toml
sed -i -e "s#\$RPC#${RPCSERVER}#g;"  /home/user/config.toml
sed -i -e "s#\$GRPC#${GRPCSERVER}#g;"  /home/user/config.toml

sed -i -e "s#\$ADDRESS#${ADDRESS}#g;"  /home/user/config.toml
sed -i -e "s#\$VALIDATOR#${VALIDATOR}#g;"  /home/user/config.toml

rm -rf /home/user/.kujira
kujirad init foo --chain-id bar --home /home/user/.kujira 2> /dev/null
kujirad config keyring-backend file --home /home/user/.kujira
echo $SEEDPHRASE > /home/user/makekey
echo purple123 >> /home/user/makekey
echo purple123 >> /home/user/makekey
cat /home/user/makekey | kujirad keys add price-feed --recover --keyring-backend file
echo purple123 | kujirad keys list
echo 'purple123' | /bin/price-feeder config.toml