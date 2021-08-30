#!/bin/sh

DEV=$1
IP=$2
INTERVAL=$3
COUNT=$4

ping -c$COUNT -I$DEV -i $INTERVAL $IP > /tmp/$DEV

if [ $? -ne 0 ]
then
   exit 1
fi

latency=`cat /tmp/$DEV | tail -n 1 | awk '{split($4,a,"/"); print a[3]}'`
mdev=`cat /tmp/$DEV | tail -n 1 | awk '{split($4,a,"/"); print a[4]}'`

echo "$latency,$mdev"
