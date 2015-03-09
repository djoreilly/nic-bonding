ovs-vsctl --if-exists del-br br0
ovs-vsctl --if-exists del-br br1

ip link del p0ovs
ip link del p1ovs

ip netns del ns0
ip netns del ns1

ip link del br0p0
ip link del br0p1


