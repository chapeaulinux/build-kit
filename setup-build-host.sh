!/bin/sh
#
#	build_host_setup.sh
#
#	Script to quickly setup a Fedora install for
#	building a Fedora live image.
#

packages="git hardlink livecd-tools fedora-kickstarts spin-kickstarts nfs-utils dnf-utils @development-tools fedora-packager createrepo kde-filesystem libicns-utils automake gnome-common gettext glib2-devel intltool"
br=/build-kit
rpmbdir=~/rpmbuild
rpmuser=$(whoami)


test -f /etc/fedora-release
if [ $? = 1 ]
then
	echo "This script is for Fedora releases only"
	exit 1
fi

if [ $(id -u) = 0 ]
then
	echo "Don't run this script as root"
	exit 1
fi

echo "Installing required packages; $packages"
sudo dnf -y install $packages
if [ $? = 0 ]
then
	echo "Packages \"$packages\" installed"
else
	echo "Package installation failed"
	echo "Retry installation manually using dnf, e.g."
	echo
	echo "   sudo dnf install $packages"
fi

if [ ! -h $br ] && [ ! -d $br ]
then
	echo "Creating build-kit directory $br..."
	sudo mkdir -p $br
	test -d $br
	if [ $? = 0 ]
	then
		echo "\"$br\" created."
	else
		echo "Creation of \"$br\" failed!"
		echo "You will need to set this up manually"
	fi
		echo "This is where the contents of Chapeau's build-kit distributable goes, if you prefer not to have the actual buildkit in your root volume then you can mount \"$br\" to a remote share or create a symlink in it's place to another location"
		echo "The Chapeau live image build script and kickstart files uses this path as the root path to required working directories"
fi

if [ -z "$(grep ^${rpmuser}: /etc/passwd)" ]
then
	echo "Creating user \"${rpmuser}\""
	sudo /usr/sbin/useradd $rpmuser
	if [ $? = 0 ]
	then
		echo "User $rpmuser created"
		sudo usermod -a -G mock $rpmuser
		if [ $? = 0 ]
		then
			echo "New user added to the \"mock\" group"
		else
			echo "Couldn't add new user to the \"mock\" group"
		fi
		echo "Enter a password for the new user \"${rpmuser}\".."
		sudo passwd $rpmuser
	else
		echo "ERROR: User creation failed"
	fi
fi

if [ ! -h $rpmbdir ] && [ ! -d $rpmbdir ]
then
	su -c rpmdev-setuptree - $rpmuser
fi

