#!/bin/sh

# 1.
IP_SIM1=$1

echo "IP SIM2: $IP_SIM1"
#echo "IP SIM2: $IP_SIM2"


# 2.
# 2.1 rimuovo le vecchie regole (qualora ci siano)

# SIM 1
#OLD_IP_SIM1=`ip rule | grep sim1 | awk '{print\$3}'`
#ip rule del from $OLD_IP_SIM1

# SIM 2
#OLD_IP_SIM2=`ip rule | grep sim2 | awk '{print\$3}'`
#ip rule del from $OLD_IP_SIM2
#sudo /home/pi/smart_vpn/mlvpn/cfg/source_routing.sh $IP_SIM1 $IP_SIM2


# 3.
sudo sed -e "s/ip_sim1/$IP_SIM1/g" /home/pi/smart_vpn/mlvpn/cfg/vpn2-support.template > /home/pi/smart_vpn/mlvpn/cfg/vpn2-support.conf
#sudo sed -e "s/ip_sim2/$IP_SIM2/g" /home/pi/smart_vpn/mlvpn/cfg/vpn0-bonding.conf > /home/pi/smart_vpn/mlvpn/cfg/vpn0-bonding-tmp.conf
#mv /home/pi/smart_vpn/mlvpn/cfg/vpn1-support-tmp.conf /home/pi/smart_vpn/mlvpn/cfg/vpn1-support.conf
sudo chmod 700 /home/pi/smart_vpn/mlvpn/cfg/vpn2-support.conf


# 4.
#
#if pgrep -x "mlvpn" > /dev/null
#then
#    echo "Reload VPN Bonding configuration..."
#    #sudo kill -HUP $(pidof mlvpn)
#    sudo kill -9 $(pidof mlvpn)
#    sudo /home/pi/smart_vpn/mlvpn/sbin/mlvpn -c /home/pi/smart_vpn/mlvpn/cfg/vpn0-bonding.conf --user root --debug -v
#else
#    echo "launching VPN Bonding..."
    sudo /home/pi/smart_vpn/mlvpn/sbin/mlvpn -c /home/pi/smart_vpn/mlvpn/cfg/vpn2-support.conf --user root --debug -v
#fi
