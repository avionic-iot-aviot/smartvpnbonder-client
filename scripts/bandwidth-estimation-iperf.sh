#!/bin/bash

SRV_IPERF=$1
DEV_PPP=$2
TIME=$3
NUMBER_RE='^[0-9]+$'

IPSIM="`/sbin/ifconfig $DEV_PPP | awk '/inet / {print $2}'`"
if [ $? -ne 0 ]
then
   exit 1
fi

iperf -c $SRV_IPERF -t $TIME -f K -B $IPSIM > /tmp/$DEV_PPP
if [ $? -ne 0 ]
then
   exit 1
fi

BANDWIDTH=`cat /tmp/$DEV_PPP | tail -n1 | awk '{print$8}'`

if ! [[ $BANDWIDTH =~ $re ]] ; then
   exit 1
fi

if [ -z "$BANDWIDTH" ]
then
    exit 1
fi

echo $BANDWIDTH
