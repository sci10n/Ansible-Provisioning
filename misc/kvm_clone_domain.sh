#!/bin/bash
set -e 
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
echo "Cloning from $1 to $2"
virt-clone --connect=qemu:///system -o "$1" -n "$2" --auto-clone
virsh -c qemu:///system start "$2"
echo "Started host $2..."
ifname=$( virsh -c qemu:///system  domiflist "$2" | grep "virtio" | awk '{ print $3 }' )
hwaddress=$( virsh -c qemu:///system  domiflist "$2" | grep "virtio" | awk '{ print $5 }' )
echo "$1 running on interface: $ifname with MAC: $hwaddress"

while true; do
	ipaddress=$(  arp-scan --interface="$ifname" -l | grep "$hwaddress" | awk '{ print $1 }' )
	if [ -z "$ipaddress" ]; then     
		echo "Waiting for ARP response..."
	else
		echo "Ip: $ipaddress found for host: $hwaddress/$2" 
		break;
	fi
done
echo "Deployment successfull!"
exit 0
