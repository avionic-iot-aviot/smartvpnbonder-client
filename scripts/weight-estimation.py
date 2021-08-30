#!/usr/bin/python3

import argparse
import math

parser = argparse.ArgumentParser(
    description='Compute links weight of round robin algorithm'
)


parser.add_argument(
    '--kpi-sim-1',
    metavar="kpi_sim_1",
    type=str,
    action="store",
    dest="kpi_sim_1",
    required=True,
    help="indicates the kpi of sim_1: 'latency,jitter,bandwidth'"
)


parser.add_argument(
    '--kpi-sim-2',
    metavar="kpi_sim_2",
    type=str,
    action="store",
    dest="kpi_sim_2",
    required=True,
    help="indicates the kpi of sim_2: 'latency,jitter,bandwidth'"
)

parser.add_argument(
    '--traffic-type',
    metavar="traffic_type",
    type=str,
    action="store",
    dest="traffic_type",
    required=True,
    help="indicates the type of traffic for which weights must be calculated"
)


args = parser.parse_args()
traffic_type = args.traffic_type

# Table
# columns: W-bandwidth, W-latency, W-jitter, W-packet_loss
reference_weights = {
    'realtime': [3, 3, 3, 1],
    'telemetry': [1, 3, 3, 3],
    'file-download': [7, 1, 1, 1]
}

kpi_sim_1 = args.kpi_sim_1.split(',')
kpi_sim_1_d = {
    'latency': float(kpi_sim_1[0]),
    'jitter': float(kpi_sim_1[1]),
    'bandwidth': float(kpi_sim_1[2])
}

kpi_sim_2 = args.kpi_sim_2.split(',')
kpi_sim_2_d = {
    'latency': float(kpi_sim_2[0]),
    'jitter': float(kpi_sim_2[1]),
    'bandwidth': float(kpi_sim_2[2])
}

# WEIGHTS computation
W_bandwidth_sim_1 = 1 if kpi_sim_1_d['bandwidth'] < kpi_sim_2_d['bandwidth'] else \
    math.ceil(kpi_sim_1_d['bandwidth'] / kpi_sim_2_d['bandwidth'])

W_bandwidth_sim_2 = 1 if kpi_sim_2_d['bandwidth'] < kpi_sim_1_d['bandwidth'] else \
    math.ceil(kpi_sim_2_d['bandwidth'] / kpi_sim_1_d['bandwidth'])

W_latency_sim_1 = 1 if kpi_sim_1_d['latency'] > kpi_sim_2_d['latency'] else \
    math.ceil(kpi_sim_2_d['latency'] / kpi_sim_1_d['latency'])

W_latency_sim_2 = 1 if kpi_sim_2_d['latency'] > kpi_sim_1_d['latency'] else \
    math.ceil(kpi_sim_1_d['latency'] / kpi_sim_2_d['latency'])

W_jitter_sim_1 = 1 if kpi_sim_1_d['jitter'] > kpi_sim_2_d['jitter'] else \
    math.ceil(kpi_sim_2_d['jitter'] / kpi_sim_1_d['jitter'])

W_jitter_sim_2 = 1 if kpi_sim_2_d['jitter'] > kpi_sim_1_d['jitter'] else \
    math.ceil(kpi_sim_1_d['jitter'] / kpi_sim_2_d['jitter'])


W_sim_1 = W_bandwidth_sim_1 * reference_weights[traffic_type][0] + \
          W_latency_sim_1 * reference_weights[traffic_type][1] + W_jitter_sim_1 * reference_weights[traffic_type][2]
W_sim_2 = W_bandwidth_sim_2 * reference_weights[traffic_type][0] + \
          W_latency_sim_2 * reference_weights[traffic_type][1] + W_jitter_sim_2 * reference_weights[traffic_type][2]

print(W_sim_1, W_sim_2)
