#!/bin/bash

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
    /sbin/route add 192.168.180.1 dev $tuntap_intf
    # setting VPN's IP address
    /sbin/ifconfig $tuntap_intf 192.168.180.2 netmask 255.255.255.0
elif [ "$newstatus" = "tuntap_down" ]; then
    echo "$tuntap_intf shutdown"
   /sbin/route del 192.168.180.1 dev $tuntap_intf
elif [ "$newstatus" = "rtun_up" ]; then
    echo "rtun [${rtun}] is up"
elif [ "$newstatus" = "rtun_down" ]; then
    echo "rtun [${rtun}] is down"
fi
) >> /var/log/mlvpn1_commands.log 2>&1

exit $errors
