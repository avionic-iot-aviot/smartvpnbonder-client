#!/bin/sh

# 1. prelevo i pesi (2 posizionali) da associare al bonder
# 2. edito il file di configurazione vpn0-bonder.conf
# 3. riavvio il processo mlvpn

# 1.
W_SIM1=$1
W_SIM2=$2

# 2.
# SIM 1
sudo sed -i "0,/bandwidth_upload/s/.*bandwidth_upload.*/bandwidth_upload=$W_SIM1/" /home/pi/smart-vpn-bonder-client/cfg/vpn0-bonding.conf

# SIM 2 - ATT: e' importante verificare il numero di linea (impostato attualmente a 25,per il secondo parametro)
sudo sed -i "26,/bandwidth_upload/s/.*bandwidth_upload.*/bandwidth_upload=$W_SIM2/" /home/pi/smart-vpn-bonder-client/cfg/vpn0-bonding.conf

# 3.
sudo kill -HUP $(pidof mlvpn)
