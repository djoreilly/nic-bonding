#!/bin/bash

set -xe

ip link add name br1p0 type veth peer name ns1p0
ip link add name br1p1 type veth peer name ns1p1

ip link set dev br1p0 up
ip link set dev br1p1 up

ovs-vsctl --may-exist add-br br1
ovs-vsctl add-bond br1 bond1 br1p0 br1p1 lacp=passive

ip netns add ns1
ip link set ns1p0 netns ns1
ip link set ns1p1 netns ns1
ip netns exec ns1 ip link set dev ns1p0 up
ip netns exec ns1 ip link set dev ns1p1 up


ip link set bond0 netns ns1
ip netns exec ns1 ifenslave bond0 ns1p0 ns1p1
ip netns exec ns1 ip address add 10.0.0.1/24 dev bond0
ip netns exec ns1 ip link set dev bond0 up


ovs-vsctl add-port br1 p2 -- set Interface p2 type=internal
ip address add 10.0.0.2/24 dev p2
