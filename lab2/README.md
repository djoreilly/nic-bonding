# lab2: linux bond to ovs bond


    # cat /etc/modprobe.d/bonding.conf 
    alias bond0 bonding
            options bonding mode=4 miimon=100 lacp_rate=1

    # modprobe bonding


    # ip netns exec ns1 cat /proc/net/bonding/bond0 
    Ethernet Channel Bonding Driver: v3.7.1 (April 27, 2011)

    Bonding Mode: IEEE 802.3ad Dynamic link aggregation
    Transmit Hash Policy: layer2 (0)
    MII Status: up
    MII Polling Interval (ms): 100
    Up Delay (ms): 0
    Down Delay (ms): 0

    802.3ad info
    LACP rate: fast
    Min links: 0
    Aggregator selection policy (ad_select): stable
    Active Aggregator Info:
	    Aggregator ID: 1
	    Number of ports: 2
	    Actor Key: 33
	    Partner Key: 1
	    Partner Mac Address: fe:2d:af:83:d2:46

    Slave Interface: ns1p0
    MII Status: up
    Speed: 10000 Mbps
    Duplex: full
    Link Failure Count: 0
    Permanent HW addr: 96:3c:f1:f8:d2:3f
    Aggregator ID: 1
    Slave queue ID: 0

    Slave Interface: ns1p1
    MII Status: up
    Speed: 10000 Mbps
    Duplex: full
    Link Failure Count: 0
    Permanent HW addr: 42:7a:10:ff:ac:41
    Aggregator ID: 1
    Slave queue ID: 0
    

    # ovs-appctl bond/show bond1
    ---- bond1 ----
    bond_mode: active-backup
    bond-hash-basis: 0
    updelay: 0 ms
    downdelay: 0 ms
    lacp_status: negotiated

    slave br1p0: enabled
	    may_enable: true

    slave br1p1: enabled
	    active slave
	    may_enable: true

