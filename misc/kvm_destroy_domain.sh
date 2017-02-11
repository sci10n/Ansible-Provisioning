#!/bin/bash
set -e 
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
echo "Destroying host $1..."
virsh -c qemu:///system destroy "$1"
storage=$( virsh -c qemu:///system domstats $1 | grep -oP 'block.0.path=\K.*' )
if [ -e "$storage" ]
then
	rm -f "$storage"
else
	echo "Storage file: $storage not found!"
	exit 2
fi
virsh -c qemu:///system undefine "$1"
echo "Destruction of host $1 successfull!"
exit 0
