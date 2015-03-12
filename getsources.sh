#!/bin/sh

# A quick script to grab sources of Fedora's
# packages we might need to look at for seeing how
# to package Chapeau's branding

packages="fedora-logos fedora-release fedora-release-workstation generic-logos generic-logos-httpd generic-release generic-release-workstation generic-release-notes generic-release-nonproduct"
buildroot=/build-kit
srcdir=${buildroot}/resources/fedora-sources

if [ ! -d $srcdir ]
then
	mkdir $srcdir >>/dev/null 2>&1
	if [ $? != 0 ]
	then
		echo "Download target $srcdir does not exist and cannot be created. Aborting"
		exit 1
	else
		chmod 777 $srcdir
	fi
else
	touch ${srcdir}/afile
	if [ $? != 0 ]
	then
		echo "Cannot write to $srcdir, cannot continue."
		exit
	else
		rm -f ${srcdir}/afile
	fi
fi

cd $srcdir

yumdownloader --source $packages

if [ $? != 0 ]
then
	echo "Download failed"
else
	echo "The following packages have been downloaded to ${srcdir};"
	echo $packages
fi

