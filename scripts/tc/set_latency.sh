#!/bin/sh

DEV=$1
DELAY=$2

sudo tc qdisc add dev $DEV root netem delay $DELAY
