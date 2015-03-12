#!/bin/sh
#
#	rawhide_upgrade.sh
#
#	Script to upgrade your Fedora installation to rawhide
#

packages="fedup"


test -f /etc/fedora-release
if [ $? = 1 ]
then
	echo "This script is for Fedora releases only"
	exit 1
fi

if [ $(id -u) != 0 ]
then
	echo "Run this script as root. e.g."
	echo
	echo "    sudo ./$0"
	exit 1
fi

echo "Installing required package; $packages"
yum -y install $packages
if [ $? = 0 ]
then
	echo "Package \"$packages\" installed"
else
	echo "Package installation failed"
	echo "Retry installation manually using yum, e.g."
	echo
	echo "   sudo yum install $packages"
	exit 1
fi

echo
echo
echo "Now ready to start the update with fedup"
echo "Press [Enter] to proceed or [Ctrl]+[C] to abort."
read input

fedup --network rawhide --nogpgcheck --instrepo http://download.fedoraproject.org/pub/fedora/linux/development/rawhide/$(uname -i)/os/.

echo
echo
echo

if [ $? = 0 ]
then
	echo "Process completed successfully"
else
	echo "Process exited with an error!"
fi

