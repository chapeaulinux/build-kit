repo --name=fedora --baseurl=http://download.fedoraproject.org/pub/fedora/linux/releases/$releasever/Everything/$basearch/os/
repo --name=updates --baseurl=http://download.fedoraproject.org/pub/fedora/linux/updates/$releasever/$basearch/
repo --name=updates-testing --baseurl=http://download.fedoraproject.org/pub/fedora/linux/updates/testing/$releasever/$basearch/ --includepkgs=gnome-shell
#repo --name=rawhide --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=rawhide&arch=$basearch

### RPMFusion
## Main
repo --name="RPMFusion Free" --baseurl=http://download1.rpmfusion.org/free/fedora/releases/$releasever/Everything/x86_64/os/
repo --name="RPMFusion Free Updates" --baseurl=http://download1.rpmfusion.org/free/fedora/updates/$releasever/x86_64/
#repo --name="RPMFusion Free Updates - Testing" --baseurl=http://download1.rpmfusion.org/free/fedora/updates/testing/$releasever/x86_64/
#repo --name="RPMFusion Free i386" --baseurl=http://download1.rpmfusion.org/free/fedora/releases/$releasever/Everything/i386/os/ 
repo --name="RPMFusion Nonfree" --baseurl=http://download1.rpmfusion.org/nonfree/fedora/releases/$releasever/Everything/x86_64/os/
repo --name="RPMFusion Nonfree Updates" --baseurl=http://download1.rpmfusion.org/nonfree/fedora/updates/$releasever/x86_64/
#repo --name="RPMFusion Nonfree Updates - Testing" --baseurl=http://download1.rpmfusion.org/nonfree/fedora/updates/testing/$releasever/x86_64/
#repo --name="RPMFusion Nonfree i386" --baseurl=http://download1.rpmfusion.org/nonfree/fedora/releases/$releasever/Everything/i386/os/ --includepkgs=steam,lpf-spotify-client
## Devel
#repo --name="RPMFusion Free Devel" --baseurl=http://download1.rpmfusion.org/free/fedora/development/$releasever/$basearch/os/
#repo --name="RPMFusion Free Devel i386" --baseurl=http://download1.rpmfusion.org/free/fedora/development/$releasever/i386/os/
#repo --name="RPMFusion Non-Free Devel" --baseurl=http://download1.rpmfusion.org/nonfree/fedora/development/$releasever/$basearch/os/
#repo --name="RPMFusion Non-Free Devel i386" --baseurl=http://download1.rpmfusion.org/nonfree/fedora/development/$releasever/i386/os/ --includepkgs=steam,lpf-spotify-client
## Rawhide
#repo --name="RPMFusion Free Rawhide" --baseurl=http://download1.rpmfusion.org/free/fedora/development/rawhide/$basearch/os/
#repo --name="RPMFusion Free Rawhide i386" --baseurl=http://download1.rpmfusion.org/free/fedora/development/rawhide/i386/os/
#repo --name="RPMFusion Non-Free Rawhide" --baseurl=http://download1.rpmfusion.org/nonfree/fedora/development/rawhide/$basearch/os/
#repo --name="RPMFusion Non-Free Rawhide i386" --baseurl=http://download1.rpmfusion.org/nonfree/fedora/development/rawhide/i386/os/

## Korora (no longer used)
# Korora have Pharlap to assist with installing proprietory drivers
#repo --name=Korora --baseurl=http://mirror.linux.org.au/pub/korora/releases/21/x86_64/ --includepkgs=pharlap*,lens,*-lens,*-lens-*

## PlayOnLinux for running Windows software / managing Wine instances
repo --name="PlayonLinux" --baseurl=http://rpm.playonlinux.com/fedora/yum/base

## Adobe
repo --name="Adobe" --baseurl=http://linuxdownload.adobe.com/linux/x86_64/
repo --name="Adobe - 32bit" --baseurl=http://linuxdownload.adobe.com/linux/i386/

## Dropbox
# (No '23' repo yet)
repo --name=Dropbox --baseurl=http://linux.dropbox.com/fedora/22/

## Chapeau packages
# Local build repo for chapeau package testing
#repo --name="Chapeau" --baseurl=file:///chapeau/repo/$releasever/x86_64/
#repo --name="Chapeau 32bit packages" --baseurl=file:///chapeau/repo/$releasever/i386/
# Live repo
repo --name="Chapeau" --baseurl=http://chapeaulinux.org/repo/$releasever/x86_64/
repo --name="Chapeau 32bit packages" --baseurl=http://chapeaulinux.org/repo/$releasever/i386/

