#!/bin/sh

DEV=$1
BANDWITH=$2

sudo tc qdisc add dev $DEV root tbf rate $BANDWITH burst 32kbit latency 400ms
