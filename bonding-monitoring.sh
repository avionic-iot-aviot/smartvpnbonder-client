#!/bin/bash

source ~/drone.cfg

F_IPSIM1=ip_sim1
F_IPSIM2=ip_sim2
IF_SIM1=ppp0
IF_SIM2=ppp1
PERIOD_S=$1

# delete rules from a previous execution
sudo ip rule flush table sim1
sudo ip rule flush table sim2

# empty sim ips
echo > ip_sim1
echo > ip_sim2

while :
do
    sleep $PERIOD_S

    OLD_IPSIM1="`cat $F_IPSIM1`"
    OLD_IPSIM2="`cat $F_IPSIM2`"

    echo OLD_IPSIM1: $OLD_IPSIM1
    echo OLD_IPSIM2: $OLD_IPSIM2

    NEW_IPSIM1="`/sbin/ifconfig $IF_SIM1 | awk '/inet / {print $2}'`"
    NEW_IPSIM2="`/sbin/ifconfig $IF_SIM2 | awk '/inet / {print $2}'`"

    echo NEW_IPSIM1: $NEW_IPSIM1
    echo NEW_IPSIM2: $NEW_IPSIM2

    if [ "$OLD_IPSIM1" != "$NEW_IPSIM1" ] || [ "$OLD_IPSIM2" != "$NEW_IPSIM2" ]; then
        echo "IP is not the same, reload VPN bonder configuration..."
        echo $NEW_IPSIM1 > ip_sim1
        echo $NEW_IPSIM2 > ip_sim2
        
    	#sudo ./launch-bonder.sh $NEW_IPSIM1 $NEW_IPSIM2

        # 1.
        # 1.1 rimuovo le vecchie regole (qualora ci siano)

        # # SIM 1
        # OLD_IP_SIM1=`ip rule | grep sim1 | awk '{print\$3}'`
        # sudo ip rule del from $OLD_IP_SIM1

        # # SIM 2
        # OLD_IP_SIM2=`ip rule | grep sim2 | awk '{print\$3}'`
        # sudo ip rule del from $OLD_IP_SIM2

        sudo ip rule flush table sim1
        sudo ip rule flush table sim2

        sudo ./scripts/source_routing.sh "$NEW_IPSIM1" "$NEW_IPSIM2"


        # 2.
        sudo sed -e "s/ip_sim1/$NEW_IPSIM1/g" ./cfg/vpn0-bonding.template > ./cfg/vpn0-bonding-tmp1.conf
        sudo sed -e "s/ip_sim2/$NEW_IPSIM2/g" ./cfg/vpn0-bonding-tmp1.conf > ./cfg/vpn0-bonding-tmp2.conf
        sudo sed -e "s/remoteport1/$mlvpn_port1/g" ./cfg/vpn0-bonding-tmp2.conf > ./cfg/vpn0-bonding-tmp3.conf
        sudo sed -e "s/remoteport2/$mlvpn_port2/g" ./cfg/vpn0-bonding-tmp3.conf > ./cfg/vpn0-bonding-tmp4.conf
        mv ./cfg/vpn0-bonding-tmp4.conf ./cfg/vpn0-bonding.conf
        sudo chmod 700 ./cfg/vpn0-bonding.conf

        # 3.
        #
        if pgrep -x "mlvpn" > /dev/null
        then
           echo "Reload VPN Bonding configuration..."
           #sudo kill -HUP $(pidof mlvpn)
           # verificare altri processi MLVPN associati alle VPN di supporto
           sudo kill -9 $(pidof mlvpn)
	   sleep 1
           sudo /home/pi/mlvpn/sbin/mlvpn -c ./cfg/vpn0-bonding.conf --user root --debug -Dwrr -v &
        else
           echo "launching VPN Bonding..."
           sudo /home/pi/mlvpn/sbin/mlvpn -c ./cfg/vpn0-bonding.conf --user root --debug -Dwrr -v &
        fi
    
    else
      # 4.
      #
      echo "IP is the same, checking if mlvpn process is running..."
      if pgrep -x "mlvpn" > /dev/null
       then
           echo "mlvpn is running... "
       else
           echo "mlvpn is not running, launching VPN Bonding..."
           sudo /home/pi/mlvpn/sbin/mlvpn -c ./cfg/vpn0-bonding.conf --user root --debug -Dwrr -v &
      fi
    fi 
done
