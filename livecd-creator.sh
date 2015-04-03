#!/bin/sh
creator_fslabel=Chapeau
creator_releasever=21
buildroot=/build-kit
creator_cache=${buildroot}/buildcache${creator_releasever}
creator_config=${buildroot}/kickstart/chapeau-${creator_releasever}.ks
log=${buildroot}/$(basename $0|cut -d. -f1)_$(date +%Y%m%d%H%M).log
extras=${buildroot}/extras

sestatus=$(sestatus)
seenabled=$(echo "$sestatus" | grep -i "^SELinux status:.*enabled")
seenforcing=$(echo "$sestatus" | grep -i "^Current mode:.*enforcing")
gnomever=$(rpm -q --info gnome-shell | awk '/^Version/ {print $3}' | cut -d. -f1-2)

echo "$sestatus"|grep '^SELinux status:'
echo "$sestatus"|grep '^Current mode:'
echo

if [[ -n "$seenabled" ]] && [[ -n "$seenforcing" ]]
then
	echo "SELinux is currently enabled and in Enforcing mode"
	echo "Need to run \"setenforce 0\" before starting, enter your password to raise privilege..."
	sudo echo
	if [[ $? = 0 ]]
	then
		sudo setenforce 0
		if [[ $? != 0 ]]
		then
			echo "Couldn't set SELinux to permissive mode. Aborting."
			echo
			exit 1
		else
			echo "Succeeded..."
			sestatus
			echo
		fi
	else
		echo "sudo failed. Aborting."
		exit 1
	fi
fi

if [[ ! -d $buildroot ]]
then
	echo "$buildroot does not exist! Cannot continue." 
	exit 1
else
	touch ${buildroot}/afile 2>/dev/null
	if [[ $? != 0 ]]
	then
		echo "Could not write to $buildroot! Cannot continue."
		exit 1
	else
		rm -f ${buildroot}/afile
	fi
fi

for dir in $creator_cache $extras
do
	if [[ ! -d $dir ]]
	then
		mkdir $dir
		if [[ $? != 0 ]]
	        then
	                echo "$dir does not exist and could not create it. Cannot continue."
	                exit 1
	        fi
	else
		touch ${dir}/afile 2>/dev/null
		if [[ $? != 0 ]]
		then
			echo "Could not write to $dir! Trying to fix..."
			sudo chmod 777 $dir
			touch ${dir}/afile 2>/dev/null
			if [[ $? = 0 ]]
			then
				echo "Fixed"
			else
				echo "Could not write to $dir! Cannot continue."
				exit 1
			fi
		else
			rm -f ${dir}/afile
		fi
	fi
done

#Download external packages
packagelist="http://www.lwfinger.com/b43-firmware/broadcom-wl-5.100.138.tar.bz2
http://extensions.gnome.org/static/extension-data/mediaplayer%40patapon.info.v33.shell-extension.zip
http://extensions.gnome.org/static/extension-data/caffeine%40patapon.info.v21.shell-extension.zip
http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-${creator_releasever}.noarch.rpm
http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${creator_releasever}.noarch.rpm"
#packagelist="http://www.lwfinger.com/b43-firmware/broadcom-wl-5.100.138.tar.bz2
#http://extensions.gnome.org/static/extension-data/mediaplayer%40patapon.info.v32.shell-extension.zip
#http://extensions.gnome.org/static/extension-data/caffeine%40patapon.info.v20.shell-extension.zip
#http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-rawhide.noarch.rpm
#http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-rawhide.noarch.rpm"
cd ${extras}
echo "$packagelist" | while read pkg
do
	pkgname="$(echo $pkg | awk 'BEGIN { FS = "/" } ; { print $NF }')"
	if [[ ! -f "$pkgname" ]]
	then
		wget -q -O - $pkg > $pkgname
		if [ $? != 0 ]
		then
			echo "Download of $pkgname failed from URL $pkg. Aborting."
		else
			echo "$pkgname downloaded successfully"
		fi
	fi
done

## Gnome Extensions
cp -pf "mediaplayer%40patapon.info.v33.shell-extension.zip" media-player-indicator-extension.zip
cp -pf "caffeine%40patapon.info.v21.shell-extension.zip" caffeine-extension.zip
cd -

echo "$(date): Running livecd-creator"
echo
sudo livecd-creator --config="$creator_config" --fslabel=$creator_fslabel --releasever=$creator_releasever --cache="$creator_cache" 2>&1
es=$?
echo
echo
if [[ $es != 0 ]]
then
	echo "$(date): livecd-creator failed!"
else
	echo "$(date): livecd-creator completed successfully"
	echo "   Live image is $(pwd)/${creator_fslabel}.iso"
fi

