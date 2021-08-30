#!/bin/bash

DEV_SIM1=$1
DEV_SIM2=$2
PINGIP=$3
SRV_IPERF=$4
PERIOD_S=$5

while :
do

    echo "inizio ciclo di monitoraggio kpi..."
    echo "attendo $PERIOD_S secondi..."
    sleep $PERIOD_S

    # compute LATENCY / JITTER
    latency_jitter_sim_1=`./latency-estimation.sh $DEV_SIM1 $PINGIP 1 4`
    if [ $? -ne 0 ]
    then
       echo "errore..."
       continue
    fi
    
    echo $?
    echo "[SIM1] latency/jitter: $latency_jitter_sim_1"


    latency_jitter_sim_2=`./latency-estimation.sh $DEV_SIM2 $PINGIP 1 4`
    if [ $? -ne 0 ]
    then
       echo "errore..."
       continue
    fi

    echo $?
    echo "[SIM2] latency/jitter: $latency_jitter_sim_2"

    # compute BANDWIDTH
    bandwidth_sim_1=`./bandwidth-estimation-iperf.sh $SRV_IPERF $DEV_SIM1 10`
    if [ $? -ne 0 ]
    then
       echo "errore..."
       continue
    fi

    echo $?
    echo "[SIM1] bandwidth: $bandwidth_sim_1"

    bandwidth_sim_2=`./bandwidth-estimation-iperf.sh $SRV_IPERF $DEV_SIM2 10`
    if [ $? -ne 0 ]
    then
       echo "errore..."
       continue
    fi
   
    echo $?
    echo "[SIM2] bandwidth: $bandwidth_sim_2"


    weights=`./weight-estimation.py --kpi-sim-1 $latency_jitter_sim_1,$bandwidth_sim_1 --kpi-sim-2 $latency_jitter_sim_2,$bandwidth_sim_2 --traffic-type realtime`
     if [ $? -ne 0 ]
    then
       echo "errore..."
       continue
    fi

    echo $?
    echo "[WEIGHTS]: $weights"

    ./set-weight-bonder.sh $weights

done
