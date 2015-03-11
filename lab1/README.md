# link agg between 2 switches

Script creates a couple of OVS bridges br0 and br1, and connects each one to a namespace using a veth. The namespaces have an IP address. Then two more veths are created and used to create a bonded link between the two bridges. See [diagram.](https://drive.google.com/file/d/0B0HB7skV7D-AX1RUX3pUMU5XaDQ/view?usp=sharing)


    root@node1:/# ovs-vsctl show
    
        Bridge "br1"
            Port "p1ovs"
                Interface "p1ovs"
            Port "br1"
                Interface "br1"
                    type: internal
            Port "bond1"
                Interface "br1p1"
                Interface "br1p0"
        Bridge "br0"
            Port "p0ovs"
                Interface "p0ovs"
            Port "bond0"
                Interface "br0p1"
                Interface "br0p0"
            Port "br0"
                Interface "br0"
                    type: internal


    root@node1:/# ovs-appctl bond/show bond0
    ---- bond0 ----
    bond_mode: active-backup
    bond-hash-basis: 0
    updelay: 0 ms
    downdelay: 0 ms
    lacp_status: negotiated

    slave br0p0: enabled
	    may_enable: true

    slave br0p1: enabled
	    active slave
	    may_enable: true


    root@node1:/# ovs-appctl bond/show bond1
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

