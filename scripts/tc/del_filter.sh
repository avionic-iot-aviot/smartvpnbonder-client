#!/bin/sh

DEV=$1

sudo tc qdisc del dev $DEV root
