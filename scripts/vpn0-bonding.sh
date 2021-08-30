#!/bin/bash

source /home/pi/drone.cfg

echo "ciao1"
error=0; trap "error=$((error|1))" ERR

tuntap_intf="$1"
newstatus="$2"
rtun="$3"

echo "ciao2"

[ -z "$newstatus" ] && exit 1

(
if [ "$newstatus" = "tuntap_up" ]; then
    echo "$tuntap_intf setup"
    /sbin/ip link set dev $tuntap_intf mtu 1400 up
    sudo /usr/sbin/ifconfig $tuntap_intf $mlvpn_ip
    #/sbin/route add 192.168.100.2 dev $tuntap_intf
    #/sbin/route del default
    /sbin/route add default $tuntap_intf

    #/sbin/route add 172.31.40.72 dev $tuntap_intf
elif [ "$newstatus" = "tuntap_down" ]; then
    echo "$tuntap_intf shutdown"
    #/sbin/route del 192.168.100.2 dev $tuntap_intf
    /sbin/route del default
    #/sbin/route del 172.31.40.72 dev $tuntap_intf
elif [ "$newstatus" = "rtun_up" ]; then
    echo "rtun [${rtun}] is up"
elif [ "$newstatus" = "rtun_down" ]; then
    echo "rtun [${rtun}] is down"
fi
) >> /var/log/mlvpn_commands.log 2>&1

exit $errors
