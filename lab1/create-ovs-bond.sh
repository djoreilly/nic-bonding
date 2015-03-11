#!/bin/bash

set -xe

function setup() {
    ns=ns$1
    nsport=p${1}ns
    ovsport=p${1}ovs
    nsmac=00:00:00:00:00:1$1
    ovsmac=00:00:00:00:1${1}:1${1}
    ip=10.0.0.1${1}/24
    br=br$1
    ip link add name $nsport type veth peer name $ovsport
    ip netns add $ns
    ip link set $nsport netns $ns
    ip netns exec $ns ip link set $nsport address $nsmac
    ip netns exec $ns ip address add $ip dev $nsport
    ip netns exec $ns sysctl -w net.ipv6.conf.${nsport}.disable_ipv6=1
    ip netns exec $ns ip link set $nsport up
    ip link set $ovsport address $ovsmac
    ip link set dev $ovsport up
    ovs-vsctl --may-exist add-br $br
    ovs-vsctl --may-exist add-port $br $ovsport
}

setup 0
setup 1

ip link add name br0p0 type veth peer name br1p0
ip link add name br0p1 type veth peer name br1p1
ip link set dev br0p0 up
ip link set dev br1p0 up
ip link set dev br0p1 up
ip link set dev br1p1 up


ovs-vsctl add-bond br0 bond0 br0p0 br0p1 lacp=active
ovs-vsctl add-bond br1 bond1 br1p0 br1p1 lacp=active

