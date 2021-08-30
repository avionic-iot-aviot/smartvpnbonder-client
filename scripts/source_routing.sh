#!/bin/sh

IP_SIM1=$1
IP_SIM2=$2

/sbin/ip route add $IP_SIM1/32  dev ppp0 scope link table sim1
/sbin/ip route add default via 10.64.64.64 dev ppp0 table sim1

/sbin/ip route add $IP_SIM2/32 dev ppp1 scope link table sim2
/sbin/ip route add default via 10.64.64.65 dev ppp1 table sim2

/sbin/ip rule add from $IP_SIM1/32 table sim1
/sbin/ip rule add from $IP_SIM2/32 table sim2



#/sbin/ip route add 10.148.139.132/32  dev ppp0 scope link table sim1
#/sbin/ip route add default via 10.64.64.64 dev ppp0 table sim1

#/sbin/ip route add 10.61.13.63/32 dev ppp1 scope link table sim2
#/sbin/ip route add default via 10.64.64.65 dev ppp1 table sim2

#/sbin/ip rule add from 10.148.139.132/32 table sim1
#/sbin/ip rule add from 10.61.13.63/32 table sim2
