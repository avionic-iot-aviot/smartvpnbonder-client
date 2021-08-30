#!/bin/sh

VIDEO_PATH=$1
JANUS_SRV=$2
JANUS_PORT_FEED=$3

# last test: SampleVideo_720x480_5mb.mp4
gst-launch-1.0 -v filesrc location=$VIDEO_PATH ! decodebin ! videoconvert ! x264enc tune=zerolatency bitrate=500 speed-preset=superfast ! rtph264pay ! udpsink host=$JANUS_SRV  port=$JANUS_PORT_FEED
