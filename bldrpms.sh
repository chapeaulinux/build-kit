#!/bin/sh

buildroot=~
rpmbuilddir=${buildroot}/rpmbuild
specdir=${rpmbuilddir}/SPECS
specs=$(ls ${specdir}/*.spec)

if [ $USER = root ]
then
	echo "Don't run this as root, use your own build-user account"
	exit 1
fi

cd $rpmbuilddir && for dir in BUILD BUILDROOT RPMS SOURCES SPECS SRPMS
do
	if [ ! -d $dir ]
	then
		echo "${rpmbuilddir}/${dir} does not exist, exiting."
		exit 1
	fi
done

if [ -z "$specs" ]
then
	echo "No spec files found in $specdir"
	exit
fi

for spec in $specs
do
	echo
	echo -e "\n\nBuilding $spec ...\n==========================\n"
	rpmbuild -ba $spec || echo "ERROR: rpmbuild for $spec failed."
done

