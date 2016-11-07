
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

# Need aajohan-comfortaa-fonts for the SVG rnotes images
aajohan-comfortaa-fonts

# Without this, initramfs generation during live image creation fails: #1242586
dracut-live

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

#Fedora packages
libreoffice
bijiben
gnome-music
firefox
gnome-tweak-tool
darktable
gnome-photos
gnome-boxes
testdisk
gimp
gimp-help
clamtk
clamav-data
vino
iftop
iotop
htop
#powertop
#fedup
screen
liveusb-creator
nrg2iso
p7zip
p7zip-plugins
simple-scan
alsamixergui
sound-juicer
soundconverter
gstreamer-plugins-good
gstreamer-plugins-good-extras
#gstreamer-ffmpeg
gstreamer-plugins-bad-free
gstreamer-plugins-bad-free-extras
gconf-editor
gnome-disk-utility
btrfs-progs
bash-completion
dconf-editor
gconf-editor
gparted
gnome-system-log
system-config-services
#nautilus-actions
nautilus-extensions
nautilus-image-converter
nautilus-open-terminal
nautilus-sendto
#nautilus-sound-converter
yumex-dnf
dnf-plugin-system-upgrade
unoconv
alsa-plugins-pulseaudio
alsa-utils
flac
ffmpeg
lame
libdvdnav
libdvdread
lsdvd
libmatroska
#transcode
xvidcore
libbluray
libbluray-java
libaacs
#pitivi
pavucontrol
openshot
-totem*
chntpw
openssh-server
joystick
stress
beesu
terminus-fonts-console
gnome-system-log
# Now needs explicit inclusion in f24...
rhythmbox
brasero
shotwell
xorg-x11-drv-libinput
gnome-sound-recorder
gnome-dictionary
empathy
yum
deja-dup
deja-dup-nautilus
tmux
aisleriot
gnome-chess
iagno
gnome-mines
neverball-neverball
neverball-neverputt

# New for Chapeau 24...
transmission
nmap

##Chapeau appearance
aajohan-comfortaa-fonts
chapeau-gnome-theme
oxygen-cursor-themes
f21-backgrounds-gnome
f21-backgrounds-base
f21-backgrounds-extras-gnome
f22-backgrounds-gnome
f22-backgrounds-base
f22-backgrounds-extras-gnome
f23-backgrounds-gnome
f23-backgrounds-base
f23-backgrounds-extras-gnome
f24-backgrounds-gnome
f24-backgrounds-base
f24-backgrounds-extras-gnome
plymouth-scripts
plymouth-plugin-script

##Gnome-shell extensions
gnome-shell-extension-common
#gnome-shell-extension-weather
#gnome-shell-extension-cpu-temperature
gnome-shell-extension-drive-menu
gnome-power-manager
gnome-books
gnome-calendar

#libcdio
#libcdio-paranoia
#freerdp-libs

## Skype dependencies
qtwebkit.i686
libXScrnSaver.i686

## Hardware
b43-openfwwf
b43-tools
b43-fwcutter
cups-bjnp

## RPMFusion
# **Testing** - RPMFusion development repo rpms included in the chapeau-repos package
###rpmfusion-free-release-rawhide
###rpmfusion-nonfree-release-rawhide
###rpmfusion-free-release
###rpmfusion-nonfree-release
unrar
gstreamer1-libav
gstreamer1-plugins-bad-free-extras
gstreamer1-plugins-bad-freeworld
gstreamer1-plugins-base-tools
gstreamer1-plugins-good-extras
gstreamer1-plugins-ugly
gstreamer1-plugins-bad-free
gstreamer1-plugins-good
gstreamer1-plugins-base
gstreamer-ffmpeg
xvidcore
vlc
steam

## Packages from other repos
playonlinux
flash-plugin
flash-plugin.i386
nautilus-dropbox

libdvdcss

%end
