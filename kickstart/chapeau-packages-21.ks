
%packages

@base-x
@guest-desktop-agents
-@standard
@core
@fonts
-@input-methods
-@dial-up
@multimedia
@hardware-support
@printing
@networkmanager-submodules
@workstation-product
#@fedora-release-nonproduct

# Branding for the installer
#fedora-productimg-workstation

# Exclude unwanted packages from @anaconda-tools group
-gfs2-utils
-reiserfs-utils


-fedora-logos*
chapeau-release
chapeau-packages

# Explicitly specified here:
# <notting> walters: because otherwise dependency loops cause yum issues.
kernel
kernel-modules-extra
kernel-devel
kernel-headers

# This was added a while ago, I think it falls into the category of
# "Diagnosis/recovery tool useful from a Live OS image".  Leaving this untouched
# for now.
memtest86+

# The point of a live image is to install
anaconda
@anaconda-tools

# Make live images easy to shutdown and the like in libvirt
qemu-guest-agent

#Desktop
@gnome-desktop
-fedora-release-notes
-devassistant

#Devel & modules
dkms
gcc
akmods
glade3-libgladeui

#Extra Fedora packages
libreoffice
bijiben
gnome-music
firefox
gnome-tweak-tool
darktable
gnome-boxes
testdisk
#audacity
gimp
gimp-help
clamtk
clamav-data
vino
iftop
iotop
htop
powertop
fedup
screen
liveusb-creator
nrg2iso
p7zip
p7zip-plugins
simple-scan
#ufraw
alsamixergui
sound-juicer
soundconverter
gstreamer-plugins-good
gstreamer-plugins-good-extras
gstreamer-ffmpeg
gstreamer-plugins-bad-free
gstreamer-plugins-bad-free-extras
gconf-editor
#git
#gnome-classic-session
gnome-disk-utility
btrfs-progs
bash-completion
dconf-editor
gconf-editor
#gnote
gparted
gnome-system-log
#nautilus-actions
nautilus-extensions
#nautilus-image-converter
nautilus-open-terminal
nautilus-sendto
#nautilus-sound-converter
yumex
unoconv
alsa-plugins-pulseaudio
alsa-utils
flac
ffmpeg
lame
libdvdnav
libdvdread
libmatroska
libmpg123
transcode
xvidcore
libbluray
#openshot
pitivi
-totem*
chntpw
openssh-server
joystick
stress
beesu
terminus-fonts-console
gnome-system-log
##Chapeau logo font, Comfortaa
aajohan-comfortaa-fonts
##Gnome-shell extensions
gnome-shell-extension-common
gnome-shell-extension-weather
#gnome-shell-extension-cpu-temperature
gnome-shell-extension-drive-menu

## Skype dependencies
qtwebkit.i686
libXScrnSaver.i686

## Broadcom chipset tools
b43-openfwwf
b43-tools
b43-fwcutter

## RPMFusion
rpmfusion-free-release-21
rpmfusion-nonfree-release-21
rpmfusion-free-release
rpmfusion-nonfree-release
unrar
#gstreamer-plugins-bad
#gstreamer-plugins-bad-nonfree
#gstreamer-plugins-ugly
gstreamer1-libav
gstreamer1-plugins-bad-free-extras
gstreamer1-plugins-bad-freeworld
gstreamer1-plugins-base-tools
gstreamer1-plugins-good-extras
gstreamer1-plugins-ugly
gstreamer1-plugins-bad-free
gstreamer1-plugins-good
gstreamer1-plugins-base
vlc
steam

## Korora
pharlap*

## Packages from other repos
#playonlinux-yum
playonlinux
flash-plugin
flash-plugin.i386
#GarminPlugin
#garmintools
nautilus-dropbox
#livna-release
libdvdcss

%end
