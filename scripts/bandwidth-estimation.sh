#!/bin/sh

SENDER=$1
RECEIVER=$2
TIMEOUT=$3

DATE=`date +%s`
RANDOM=`shuf -i 1-10000000 -n1`
DIR=$DATE-$RANDOM

#echo $DIR

cd /home/pi/smart_vpn/mlvpn/pathchirp-files
/bin/mkdir $DIR

cd $DIR

sudo /home/pi/smart_vpn/pathchirp-2.4.1/Bin/armv7l/pathchirp_run -S $SENDER -R $RECEIVER -t $TIMEOUT -J 4

ESTIMATION_FILE=`ls`
cat $ESTIMATION_FILE | sort | tail -n 5 | awk '{total += $2; count++} END { print total/count}'

