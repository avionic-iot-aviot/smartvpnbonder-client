#!/bin/sh

DEV=$1
LOSS=$2

sudo tc qdisc add dev $DEV root netem loss $LOSS
