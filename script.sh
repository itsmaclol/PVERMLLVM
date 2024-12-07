#!/bin/bash
if [[ -f /etc/pve/.version || -d /etc/pve ]]; then
    echo "" >> /dev/null
else
    echo "You're running this script on a non-Proxmox machine, why are you even here?"
    exit 1
fi
echo "PLEASE MAKE SURE YOU HAVENT CREATED ANY CONTAINERS OR VIRTUAL MACHINES BEFORE DOING THIS!!"
echo "First, you need to remove your local-lvm volume from Datacenter -> Storage -> local-lvm."
read -r -p "If you've already  done this, press y now. (y/n) " choice_1

case $choice_1 in
	y|Y|Yes|YES|yes )
	if pvesm status | grep -q "^local-lvm"; then
		echo "local-lvm still exists, please go and delete it using the before steps."
	else
		lvremove /dev/pve/data -y
		lvresize -l +100%FREE /dev/pve/root
		resize2fs /dev/mapper/pve-root
	fi
	;;
	n|N|No|NO|no )
		exit 1
	;;
esac
