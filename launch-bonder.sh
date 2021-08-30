#!/bin/sh

# 1.
IP_SIM1=$1
IP_SIM2=$2

echo "IP SIM1: $IP_SIM1"
echo "IP SIM2: $IP_SIM2"


# 2.
# 2.1 rimuovo le vecchie regole (qualora ci siano)

# SIM 1
OLD_IP_SIM1=`ip rule | grep sim1 | awk '{print\$3}'`
ip rule del from $OLD_IP_SIM1

# SIM 2
OLD_IP_SIM2=`ip rule | grep sim2 | awk '{print\$3}'`
ip rule del from $OLD_IP_SIM2
sudo ./scripts/source_routing.sh $IP_SIM1 $IP_SIM2


# 3.
sudo sed -e "s/ip_sim1/$IP_SIM1/g" ./cfg/vpn0-bonding.template > ./cfg/vpn0-bonding.conf
sudo sed -e "s/ip_sim2/$IP_SIM2/g" ./cfg/vpn0-bonding.conf > ./cfg/vpn0-bonding-tmp.conf
mv ./cfg/vpn0-bonding-tmp.conf ./cfg/vpn0-bonding.conf
sudo chmod 700 ./cfg/vpn0-bonding.conf


# 4.
#
if pgrep -x "mlvpn" > /dev/null
then
    echo "Reload VPN Bonding configuration..."
    #sudo kill -HUP $(pidof mlvpn)
    # verificare altri processi MLVPN associati alle VPN di supporto
    sudo kill -9 $(pidof mlvpn)
    sudo /home/pi/mlvpn/sbin/mlvpn -c ./cfg/vpn0-bonding.conf --user root --debug -Dwrr -v
else
    echo "launching VPN Bonding..."
    sudo /home/pi/mlvpn/sbin/mlvpn -c ./cfg/vpn0-bonding.conf --user root --debug -Dwrr -v
fi
