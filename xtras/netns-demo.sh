#!/bin/bash

function log() {
    printf "\n\n------------------\n%s\n------------------\n" "$*"
}

function checkns() {
    ns=$1
    log "Networking state of $ns"
    echo "Addresses"
    ip netns exec $ns ip addr show
    echo "IPv4 routes"
    ip netns exec $ns ip route
    echo "IPv6 routes"
    ip netns exec $ns ip -6 route
    echo "IPv6 neighbours before tests"
    ip netns exec $ns ip -6 neigh show
    log "IPv4 test from $ns"    
    for ip in 10.1.1.1 10.1.1.2 10.1.2.1 10.1.2.2
    do
	ip netns exec $ns ping -c4 $ip
    done
    log "IPv6 tests from $ns"
    for ip6 in 2020:caca::1 2020:caca::2 2020:caca:1::1  2020:caca:1::2
    do
	ip netns exec $ns ping6 -c4 $ip6
    done
    log "IPv6 neighbours in $ns after tests"
    ip netns exec $ns ip -6 neigh show
    log "iptables in $ns"
    ip netns exec $ns iptables -L
    log "sysctl ipv6 forwarding"
    ip netns exec netns1 sysctl net.ipv6.conf | grep forward 2> /dev/null
}

[ $UID -ne 0 ] && echo "Run as root!"
[ $UID -ne 0 ] && exit
log "Activating routing"
IP4_FORW=$(cat /proc/sys/net/ipv4/ip_forward)
IP6_FORW=$(cat /proc/sys/net/ipv6/conf/all/forwarding)
IP6_DFORW=$(cat /proc/sys/net/ipv6/conf/default/forwarding)
sysctl -w net.ipv4.ip_forward=1
sysctl -w net.ipv6.conf.all.forwarding=1
sysctl -w net.ipv6.conf.default.forwarding=1
for ns in netns1 netns2 netns3
do
    ip netns del $ns >> /dev/null
done
log "creating namespaces"
for ns in netns1 netns2 netns3
do
    ip netns add $ns >> /dev/null
    ip netns exec $ns sysctl -w net.ipv4.ip_forward=1
    ip netns exec $ns sysctl -w net.ipv6.conf.all.forwarding=1
    ip netns exec $ns sysctl -w net.ipv6.conf.default.forwarding=1

done
log "Net namespaces are:"
ip netns list
log "Creating links...."
ip link add veth0 type veth peer name veth1
sleep 2
ip link add veth2 type veth peer name veth3
sleep 2
log "Created links:"
ip link list
log "activating interfaces"
ip link set dev veth0 up
ip link set dev veth1 up
ip link set dev veth2 up
ip link set dev veth3 up
log "Trying to activate IPv6 routing in interfaces"
for vif in veth0 veth1 veth2 veth3
do
    sysctl -w net.ipv6.conf.$vif.forwarding=1
done
log "link state now:"
ip link list
log " assigning to namespaces"
ip link set veth0 netns netns1
ip link set veth1 netns netns2
ip link set veth2 netns netns2
ip link set veth3 netns netns3
log "activating in netspaces"
ip netns exec netns1 ip link set dev veth0 up
ip netns exec netns2 ip link set dev veth1 up
ip netns exec netns2 ip link set dev veth2 up
ip netns exec netns3 ip link set dev veth3 up
log "configuring IPv4"
ip netns exec netns1 ip addr add 10.1.1.1/24 dev veth0
ip netns exec netns2 ip addr add 10.1.1.2/24 dev veth1
ip netns exec netns2 ip addr add 10.1.2.1/24 dev veth2
ip netns exec netns3 ip addr add 10.1.2.2/24 dev veth3
log "configuring IPv6"
ip netns exec netns1 ip addr add 2020:caca::1/64 dev veth0
ip netns exec netns2 ip addr add 2020:caca::2/64 dev veth1
ip netns exec netns2 ip addr add 2020:caca:1::1/64 dev veth2
ip netns exec netns3 ip addr add 2020:caca:1::2/64 dev veth3
log "configuring IPv4 routing"
ip netns exec netns1 ip route add 10.1.2.0/24 via 10.1.1.2
ip netns exec netns3 ip route add 10.1.1.0/24 via 10.1.2.1
log "configuring IPv6 routing"
ip netns exec netns1 ip -6 route add 2020:caca::/32 via 2020:caca::2
ip netns exec netns3 ip -6 route add 2020:caca::/32 via 2020:caca:1::1
#
# test
#
for ns in netns1 netns2 netns3
do
    checkns $ns
done

exit
#
# clean
#
for ns in netns1 netns2 netns3
do
    ip netns del $ns >> /dev/null
done
sysctl -w net.ipv6.conf.default.forwarding=$IP6_DFORW
sysctl -w net.ipv6.conf.all.forwarding=$IP6_FORW
sysctl -w net.ipv4.ip_forward=$IP4_FORW

