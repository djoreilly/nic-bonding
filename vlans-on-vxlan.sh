#!/bin/bash

set -xe

function setup() {
    br=br0
    ns=ns$1
    nsport=p${1}ns
    ovsport=p${1}ovs
    nsmac=00:00:00:00:00:1$1
    ovsmac=00:00:00:00:1${1}:1${1}
    ip=10.0.0.1${1}/24
    ipvxlan=10.0.1.1${1}/24
    ipvlan=10.0.2.1${1}/24
    
    ip link add name $nsport type veth peer name $ovsport
    ip netns add $ns
    ip netns exec $ns ip link set lo up
    ip link set $nsport netns $ns
    ip netns exec $ns ip link set $nsport address $nsmac
    ip netns exec $ns ip address add $ip dev $nsport
    ip netns exec $ns sysctl -w net.ipv6.conf.${nsport}.disable_ipv6=1
    ip netns exec $ns ip link set $nsport up
    ip link set $ovsport address $ovsmac
    ip link set dev $ovsport up

    # create linux vxlan using multicast group for broadcasts.
    # vxlan mtu is automatically set 50 lower than dev
    ip netns exec $ns ip link add vxlan1000 type vxlan id 1000 dev $nsport group 224.0.0.1
    ip netns exec $ns ip link set dev vxlan1000 up
    ip netns exec $ns ip address add $ipvxlan dev vxlan1000

    # linux vlan over the vxlan
    ip netns exec $ns ip link add link vxlan1000 name vxlan1000.10 type vlan id 10
    ip netns exec $ns ip link set dev vxlan1000.10 up
    ip netns exec $ns ip address add $ipvlan dev vxlan1000.10

    ovs-vsctl --may-exist add-br $br
    ovs-vsctl --may-exist add-port $br $ovsport
}

function cleanup() {
    ip netns delete ns0
    ip netns delete ns1
    ip netns delete ns2
    ovs-vsctl del-br br0
}


setup 0
setup 1
setup 2


