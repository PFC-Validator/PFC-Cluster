#!/bin/sh

echo "-- using the following"
echo 'CONFIGFILE='${CONFIGFILE}
if [ "$CONFIGFILE" != "${CONFIGFILE#http://}" ] ; then
    curl -s -L $CONFIGFILE -o /home/hermes/config.original
elif [ "$CONFIGFILE" != "${CONFIGFILE#https://}" ]  ;then
    curl  -L $CONFIGFILE -o /home/hermes/config.original
elif [ -d "$CONFIGFILE" ] ;then
    cat $CONFIGFILE/*toml > /home/hermes/config.original
else
    cp $CONFIGFILE /home/hermes/config.original
fi

# todo variable replacement
cp /home/hermes/config.original /home/hermes/config.toml
/home/hermes/init_keys.sh  /init  /home/hermes/config.toml
echo "--"
echo "-- wallet balances -- "
echo "--"
/home/hermes/balances.sh /init  /home/hermes/config.toml
echo "--"
echo "-- health check -- "
echo "--"
/usr/bin/hermes --config /home/hermes/config.toml health-check
echo "--"
echo "-- starting -- "
echo "--"
/usr/bin/hermes --config /home/hermes/config.toml start
