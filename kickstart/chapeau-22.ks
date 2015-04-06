# chapeau_22.ks
#
# Kickstart file for Chapeau Linux
#
# http://chapeaulinux.org
# http://sourceforge.net/projects/chapeau

%include chapeau-base-22.ks


%post --nochroot

# chapeau-welcome
/usr/bin/cp /build-kit/assets/chapeau-welcome.desktop $INSTALL_ROOT/usr/share/applications/
/usr/bin/cp -p /build-kit/assets/chapeau-welcome $INSTALL_ROOT/usr/share/anaconda/gnome/

# Extras
/usr/bin/mkdir -p $INSTALL_ROOT/opt/extras
/usr/bin/cp /build-kit/extras/* $INSTALL_ROOT/opt/extras/
/usr/bin/cp -R /build-kit/assets/mozilla $INSTALL_ROOT/opt/extras/

# Defaults
/usr/bin/cp /build-kit/assets/dconf/profile/user $INSTALL_ROOT/etc/dconf/profile/
/usr/bin/mkdir -p $INSTALL_ROOT/etc/dconf/db/local.d/locks
/usr/bin/cp /build-kit/assets/dconf/db/local.d/* $INSTALL_ROOT/etc/dconf/db/local.d/
/usr/bin/cp /build-kit/assets/dconf/desktop-directories/* $INSTALL_ROOT/usr/share/desktop-directories/

# GIMP sessionrc file
/usr/bin/cp /build-kit/assets/gimp_sessionrc $INSTALL_ROOT/opt/extras/

%end


%post


# Default console font
#/usr/bin/sed -i 's/^FONT=.*/FONT="gr928-8x16-thin.psfu.gz"/' /etc/vconsole.conf
#echo "SYSFONT=\"gr928-8x16-thin.psfu.gz\"" >> /etc/sysconfig/i18n

# GIMP single window mode by default
/usr/bin/mkdir /etc/skel/.`/usr/bin/rpm -q gimp | /usr/bin/cut -d. -f-2`
/usr/bin/mv /opt/extras/gimp_sessionrc /etc/skel/.`/usr/bin/rpm -q gimp | /usr/bin/cut -d. -f-2`/sessionrc

# Chapeau niceties
/usr/bin/chmod -R 755 /etc/dconf/db/local.d
/usr/bin/chmod 644 /usr/share/applications/chapeau-welcome.desktop /etc/dconf/profile/user
/usr/bin/chmod 755 /usr/share/anaconda/gnome/chapeau-welcome

# Gnome Shell extensions not available from repos
/usr/bin/mkdir -p "/etc/skel/.local/share/gnome-shell/extensions"
## 'Caffeine'
##  info - https://extensions.gnome.org/extension-info/?pk=517&shell_version=3.16
##  download - https://extensions.gnome.org/download-extension/caffeine@patapon.info.shell-extension.zip?version_tag=4792
/usr/bin/mkdir -p "/usr/share/gnome-shell/extensions/caffeine@patapon.info"
/usr/bin/unzip /opt/extras/caffeine-extension.zip -d "/usr/share/gnome-shell/extensions/caffeine@patapon.info"
/usr/bin/cp -pR /usr/share/gnome-shell/extensions/caffeine@patapon.info /etc/skel/.local/share/gnome-shell/extensions/
## 'Media Player Indicator'
##  info - https://extensions.gnome.org/extension-info/?pk=55&shell_version=3.16
##  download - https://extensions.gnome.org/download-extension/mediaplayer@patapon.info.shell-extension.zip?version_tag=4791
/usr/bin/mkdir -p "/usr/share/gnome-shell/extensions/mediaplayer@patapon.info"
/usr/bin/unzip /opt/extras/media-player-indicator-extension.zip -d "/usr/share/gnome-shell/extensions/mediaplayer@patapon.info"
/usr/bin/cp -pR /usr/share/gnome-shell/extensions/mediaplayer@patapon.info /etc/skel/.local/share/gnome-shell/extensions/
/usr/bin/chmod -R a+w /etc/skel/.local
/usr/bin/find /etc/skel/.local -type d -exec chmod a+x '{}' \;

# Create a dconf config directory in skel
/usr/bin/mkdir -p /etc/skel/.config/dconf

# Firefox defaults
/usr/bin/mkdir -p /etc/skel/.mozilla/firefox/chapeau.default
/usr/bin/cp /opt/extras/mozilla/firefox/profiles.ini /etc/skel/.mozilla/firefox/
/usr/bin/cp /opt/extras/mozilla/firefox/chapeau.default/prefs.js /etc/skel/.mozilla/firefox/chapeau.default

# Restore default SELinux security contexts on the new/changed files
/usr/sbin/restorecon -R /etc/skel/* /etc/dconf/db/local.d /etc/dconf/profile/user /usr/share/icons/Fedora/48x48/apps/anaconda.png /usr/share/icons/Fedora/scalable/apps/anaconda.svg /usr/share/desktop-directories/*

# Update dconf databases to apply our user's Gnome defaults (set in the --nochroot)
/usr/bin/dconf update

# Force plymouth default theme
/usr/bin/sed -i -e 's/Theme=.+/Theme=chapeau/g' /usr/share/plymouth/plymouthd.defaults
/usr/bin/sed -i -e 's/^Theme=.+/Theme=chapeau/g' /etc/plymouth/plymouthd.conf
/usr/sbin/plymouth-set-default-theme chapeau
/usr/bin/dracut --force /boot/initrd-$(ls -1 /boot/vmlinuz*|grep -v rescue|cut -d- -f2-|tail -1).img $(ls -1 /boot/vmlinuz*|grep -v rescue|cut -d- -f2-|tail -1)

# **Temporary during testing** - Install RPMFusion development repo rpms
#/usr/bin/rpm -iv /opt/extras/rpmfusion-free-release-rawhide.noarch.rpm
#/usr/bin/rpm -iv /opt/extras/rpmfusion-nonfree-release-rawhide.noarch.rpm

%end


%post --nochroot

# Copy initrd with changed default plymouth theme to live_root/isolinux
cp $INSTALL_ROOT/boot/initrd-$(ls -1 $INSTALL_ROOT/boot/vmlinuz*|grep -v rescue|cut -d- -f3-|tail -1).img $LIVE_ROOT/isolinux/initrd0.img

%end


%post

# FIXME: it'd be better to get this installed from a package
cat > /etc/rc.d/init.d/livesys << EOF
#!/bin/bash
#
# live: Init script for live image
#
# chkconfig: 345 00 99
# description: Init script for live image.
### BEGIN INIT INFO
# X-Start-Before: display-manager
### END INIT INFO

. /etc/init.d/functions

if ! strstr "\`cat /proc/cmdline\`" rd.live.image || [ "\$1" != "start" ]; then
    exit 0
fi

if [ -e /.liveimg-configured ] ; then
    configdone=1
fi

exists() {
    which \$1 >/dev/null 2>&1 || return
    \$*
}

# Make sure we don't mangle the hardware clock on shutdown
ln -sf /dev/null /etc/systemd/system/hwclock-save.service

livedir="LiveOS"
for arg in \`cat /proc/cmdline\` ; do
  if [ "\${arg##rd.live.dir=}" != "\${arg}" ]; then
    livedir=\${arg##rd.live.dir=}
    return
  fi
  if [ "\${arg##live_dir=}" != "\${arg}" ]; then
    livedir=\${arg##live_dir=}
    return
  fi
done

# enable swaps unless requested otherwise
swaps=\`blkid -t TYPE=swap -o device\`
if ! strstr "\`cat /proc/cmdline\`" noswap && [ -n "\$swaps" ] ; then
  for s in \$swaps ; do
    action "Enabling swap partition \$s" swapon \$s
  done
fi
if ! strstr "\`cat /proc/cmdline\`" noswap && [ -f /run/initramfs/live/\${livedir}/swap.img ] ; then
  action "Enabling swap file" swapon /run/initramfs/live/\${livedir}/swap.img
fi

mountPersistentHome() {
  # support label/uuid
  if [ "\${homedev##LABEL=}" != "\${homedev}" -o "\${homedev##UUID=}" != "\${homedev}" ]; then
    homedev=\`/sbin/blkid -o device -t "\$homedev"\`
  fi

  # if we're given a file rather than a blockdev, loopback it
  if [ "\${homedev##mtd}" != "\${homedev}" ]; then
    # mtd devs don't have a block device but get magic-mounted with -t jffs2
    mountopts="-t jffs2"
  elif [ ! -b "\$homedev" ]; then
    loopdev=\`losetup -f\`
    if [ "\${homedev##/run/initramfs/live}" != "\${homedev}" ]; then
      action "Remounting live store r/w" mount -o remount,rw /run/initramfs/live
    fi
    losetup \$loopdev \$homedev
    homedev=\$loopdev
  fi

  # if it's encrypted, we need to unlock it
  if [ "\$(/sbin/blkid -s TYPE -o value \$homedev 2>/dev/null)" = "crypto_LUKS" ]; then
    echo
    echo "Setting up encrypted /home device"
    plymouth ask-for-password --command="cryptsetup luksOpen \$homedev EncHome"
    homedev=/dev/mapper/EncHome
  fi

  # and finally do the mount
  mount \$mountopts \$homedev /home
  # if we have /home under what's passed for persistent home, then
  # we should make that the real /home.  useful for mtd device on olpc
  if [ -d /home/home ]; then mount --bind /home/home /home ; fi
  [ -x /sbin/restorecon ] && /sbin/restorecon /home
## Useradd altered for Chapeau
  if [ -d /home/liveuser ]
  then
	USERADDARGS="-M"
  else
	USERADDARGS="-m -k"
  fi
}

findPersistentHome() {
  for arg in \`cat /proc/cmdline\` ; do
    if [ "\${arg##persistenthome=}" != "\${arg}" ]; then
      homedev=\${arg##persistenthome=}
      return
    fi
  done
}

if strstr "\`cat /proc/cmdline\`" persistenthome= ; then
  findPersistentHome
elif [ -e /run/initramfs/live/\${livedir}/home.img ]; then
  homedev=/run/initramfs/live/\${livedir}/home.img
fi

# if we have a persistent /home, then we want to go ahead and mount it
if ! strstr "\`cat /proc/cmdline\`" nopersistenthome && [ -n "\$homedev" ] ; then
  action "Mounting persistent /home" mountPersistentHome
fi

if [ -n "\$configdone" ]; then
  exit 0
fi

# add 'liveuser' user with no passwd
action "Adding live user" useradd \$USERADDARGS -c "Live System User" liveuser
passwd -d liveuser > /dev/null
usermod -aG wheel liveuser > /dev/null

##################################
# Inserted for Chapeau live user
##################################

# Turn off the bug reporting deamon in live sessions
systemctl stop abrtd.service 2>/dev/null

# Turn off the packagekit daemon in live sessions
systemctl stop packagekit.service 2>/dev/null

# Set the right permissions and selinux contexts on liveuser's home directory
/usr/bin/chown -R 1000 /home/liveuser
/usr/sbin/restorecon -R /home/liveuser

# Turn off gnome-screensaver & disable screensaver lock & lock screen option
/usr/bin/su -c '/usr/bin/dbus-launch /usr/bin/gsettings set org.gnome.desktop.screensaver lock-enabled false' - liveuser
/usr/bin/su -c '/usr/bin/dbus-launch /usr/bin/gsettings set org.gnome.session idle-delay 0' - liveuser
/usr/bin/su -c '/usr/bin/dbus-launch /usr/bin/gsettings set org.gnome.desktop.lockdown disable-lock-screen true' - liveuser

# Disable updates plugin
/usr/bin/su -c '/usr/bin/dbus-launch /usr/bin/gsettings set org.gnome.settings-daemon.plugins.updates active false' - liveuser

# Setup liveuser's desktop favorites
echo "/usr/bin/dbus-launch /usr/bin/gsettings set org.gnome.shell favorite-apps \"['firefox.desktop', 'evolution.desktop', 'gnome-documents.desktop', 'gnome-music.desktop', 'shotwell.desktop', 'libreoffice-writer.desktop', 'nautilus.desktop', 'liveinst.desktop']\"" >/aa
/usr/bin/chmod a+rx /aa
/usr/bin/su -c '/aa' - liveuser
/usr/bin/rm -f /aa

# Idle screen brightness
/usr/bin/su -c '/usr/bin/dbus-launch /usr/bin/gsettings set org.gnome.settings-daemon.plugins.power idle-brightness 85' - liveuser

# make the installer show up
/usr/bin/sed -i 's/NoDisplay=true/NoDisplay=false/' /usr/share/applications/liveinst.desktop

# hide gnome-software in a live session
echo "NoDisplay=true" >> /usr/share/applications/gnome-software.desktop

# set up gdm auto-login
/usr/bin/sed -i 's/\[daemon\]/\[daemon\]\nAutomaticLoginEnable=True\nAutomaticLogin=liveuser\n/' /etc/gdm/custom.conf

# Make chapeau-welcome run on start
/usr/bin/mkdir -p /home/liveuser/.config/autostart
/usr/bin/ln -s /usr/share/applications/chapeau-welcome.desktop /home/liveuser/.config/autostart/chapeau-welcome.desktop
/usr/bin/sed -i -e 's/NoDisplay=true/NoDisplay=false/' /usr/share/applications/chapeau-welcome.desktop
# ...and don't run gnome-initial-setup
/usr/bin/touch /home/liveuser/.config/gnome-initial-setup-done

#####################


# Remove root password lock
passwd -d root > /dev/null

# turn off firstboot for livecd boots
systemctl --no-reload disable firstboot-text.service 2> /dev/null || :
systemctl --no-reload disable firstboot-graphical.service 2> /dev/null || :
systemctl stop firstboot-text.service 2> /dev/null || :
systemctl stop firstboot-graphical.service 2> /dev/null || :

# don't use prelink on a running live image
sed -i 's/PRELINKING=yes/PRELINKING=no/' /etc/sysconfig/prelink &>/dev/null || :

# turn off mdmonitor by default
systemctl --no-reload disable mdmonitor.service 2> /dev/null || :
systemctl --no-reload disable mdmonitor-takeover.service 2> /dev/null || :
systemctl stop mdmonitor.service 2> /dev/null || :
systemctl stop mdmonitor-takeover.service 2> /dev/null || :

# don't enable the gnome-settings-daemon packagekit plugin
gsettings set org.gnome.software download-updates false || :

# don't start cron/at as they tend to spawn things which are
# disk intensive that are painful on a live image
systemctl --no-reload disable crond.service 2> /dev/null || :
systemctl --no-reload disable atd.service 2> /dev/null || :
systemctl stop crond.service 2> /dev/null || :
systemctl stop atd.service 2> /dev/null || :

# Mark things as configured
touch /.liveimg-configured

# add static hostname to work around xauth bug
# https://bugzilla.redhat.com/show_bug.cgi?id=679486
echo "localhost" > /etc/hostname

EOF

# bah, hal starts way too late
cat > /etc/rc.d/init.d/livesys-late << EOF
#!/bin/bash
#
# live: Late init script for live image
#
# chkconfig: 345 99 01
# description: Late init script for live image.

. /etc/init.d/functions

if ! strstr "\`cat /proc/cmdline\`" rd.live.image || [ "\$1" != "start" ] || [ -e /.liveimg-late-configured ] ; then
    exit 0
fi

exists() {
    which \$1 >/dev/null 2>&1 || return
    \$*
}

touch /.liveimg-late-configured

# read some variables out of /proc/cmdline
for o in \`cat /proc/cmdline\` ; do
    case \$o in
    ks=*)
        ks="--kickstart=\${o#ks=}"
        ;;
    xdriver=*)
        xdriver="\${o#xdriver=}"
        ;;
    esac
done

# if liveinst or textinst is given, start anaconda
if strstr "\`cat /proc/cmdline\`" liveinst ; then
   plymouth --quit
   /usr/sbin/liveinst \$ks
fi
if strstr "\`cat /proc/cmdline\`" textinst ; then
   plymouth --quit
   /usr/sbin/liveinst --text \$ks
fi

# configure X, allowing user to override xdriver
if [ -n "\$xdriver" ]; then
   cat > /etc/X11/xorg.conf.d/00-xdriver.conf <<FOE
Section "Device"
	Identifier	"Videocard0"
	Driver	"\$xdriver"
EndSection
FOE
fi

EOF

chmod 755 /etc/rc.d/init.d/livesys
/sbin/restorecon /etc/rc.d/init.d/livesys
/sbin/chkconfig --add livesys

chmod 755 /etc/rc.d/init.d/livesys-late
/sbin/restorecon /etc/rc.d/init.d/livesys-late
/sbin/chkconfig --add livesys-late

# enable tmpfs for /tmp
systemctl enable tmp.mount

# make it so that we don't do writing to the overlay for things which
# are just tmpdirs/caches
# note https://bugzilla.redhat.com/show_bug.cgi?id=1135475
cat >> /etc/fstab << EOF
vartmp   /var/tmp    tmpfs   defaults   0  0
varcacheyum /var/cache/yum  tmpfs   mode=0755,context=system_u:object_r:rpm_var_cache_t:s0   0   0
EOF

# work around for poor key import UI in PackageKit
rm -f /var/lib/rpm/__db*
releasever=$(rpm -q --qf '%{version}\n' --whatprovides system-release)
basearch=$(uname -i)
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-$releasever-$basearch
echo "Packages within this LiveCD"
rpm -qa
# Note that running rpm recreates the rpm db files which aren't needed or wanted
rm -f /var/lib/rpm/__db*

# go ahead and pre-make the man -k cache (#455968)
/usr/bin/mandb

# save a little bit of space at least...
rm -f /boot/initramfs*
# make sure there aren't core files lying around
rm -f /core*

# convince readahead not to collect
# FIXME: for systemd

# forcibly regenerate fontconfig cache (so long as this live image has
# fontconfig) - see #1169979
if [ -x /usr/bin/fc-cache ] ; then
   fc-cache -f
fi

###### More Chapeau live image changes

# Turn off PackageKit-command-not-found while uninstalled
/usr/bin/sed -i -e 's/^SoftwareSourceSearch=true/SoftwareSourceSearch=false/' /etc/PackageKit/CommandNotFound.conf

# Create a separate Pharlap icon named 'Driver Helper' to make it more obvious what it's for.
/usr/bin/cp -p /usr/share/applications/pharlap.desktop /usr/share/applications/driver_helper.desktop
/usr/bin/sed -i 's/^Name=.*/Name=Driver Helper/' /usr/share/applications/driver_helper.desktop
/usr/bin/sed -i 's/^Icon=.*/Icon=\/usr\/share\/icons\/Moka\/96x96\/apps\/cs-drivers.png/' /usr/share/applications/driver_helper.desktop
#/usr/bin/sed -i 's/^Icon=.*/Icon=\/usr\/share\/icons\/hicolor\/scalable\/apps\/hwhelper.svg/' /usr/share/applications/driver_helper.desktop
#/usr/bin/cp /opt/extras/hwhelper.svg /usr/share/icons/hicolor/scalable/apps/
#/usr/bin/chmod 644 /usr/share/icons/hicolor/scalable/apps/hwhelper.svg

# Tidy up liveusb-creator icon which is Fedora branded
# The original icon will probably return at some point when updated
# but it'll look tidy on the live session
/usr/bin/cp /opt/extras/chapeau-liveusb.png /usr/share/pixmaps/
/usr/bin/chmod o+r /usr/share/pixmaps/chapeau-liveusb.png
/usr/bin/sed -i 's/^Name=Fedora LiveUSB Creator/Name=LiveUSB Creator/' /usr/share/applications/liveusb-creator.desktop
/usr/bin/sed -i 's/^Comment=.*/Comment=Write Fedora-based images to a USB device/' /usr/share/applications/liveusb-creator.desktop
/usr/bin/sed -i 's/^Icon=.*/Icon=\/usr\/share\/pixmaps\/chapeau-liveusb.png/' /usr/share/applications/liveusb-creator.desktop
/usr/bin/cp -p /usr/share/applications/liveusb-creator.desktop /usr/share/applications/liveusb_creator.desktop
echo "NoDisplay=true" >> /usr/share/applications/liveusb-creator.desktop

# ... and the XTerm icon's just nasty looking.
echo "NoDisplay=true" >> /usr/share/applications/xterm.desktop

# ... and the OpenJDK Policy tool icon
rm -f /usr/share/applications/*openjdk-*-policytool.desktop

# The liveinst launcher needs an icon
echo "Icon=/usr/share/icons/Fedora/scalable/apps/anaconda.svg" >> /usr/share/applications/liveinst.desktop

# Make Dropbox repo not mandatory as the Dropbox rpm installs
# the repo file but their Fedora 22 repo is not yet available
echo "skip_if_unavailable=1" >> /etc/yum.repos.d/dropbox.repo

# Some PNGs included with PlayOnLinux cause libpng to throw a warning when launching PlayOnLinux
/usr/bin/find /usr/share/playonlinux -type f -name "*.png" -exec /usr/bin/convert '{}' -strip '{}' \;

# Insert Broadcom b43 firmware
cd /opt/extras
/usr/bin/tar xjf broadcom*.tar.bz2
/usr/bin/b43-fwcutter -w /lib/firmware/ broadcom-wl-*/linux/wl_apsta.o
/usr/bin/chmod o+rx /lib/firmware/b43

# Create symlink to the 32bit Flash plugin in Steam users' profiles
/usr/bin/mkdir -p /etc/skel/.local/share/Steam/ubuntu12_32/plugins/
/usr/bin/chmod -R 777 /etc/skel/.local/share/Steam
ln -s /usr/lib/flash-plugin/libflashplayer.so /etc/skel/.local/share/Steam/ubuntu12_32/plugins/

# Remove temporary extras directory
/usr/bin/rm -rf /opt/extras

# Import any other repo keys
echo -e "***Importing repository keys..."
find /etc/pki/rpm-gpg/ -type f -name "RPM-GPG-KEY*" -print -exec /usr/bin/rpm --import '{}' \;

ls /
ls -l /boot


%end


%post --nochroot
cp $INSTALL_ROOT/usr/share/licenses/*-release/* $LIVE_ROOT/

# only works on x86, x86_64
if [ "$(uname -i)" = "i386" -o "$(uname -i)" = "x86_64" ]; then
  if [ ! -d $LIVE_ROOT/LiveOS ]; then mkdir -p $LIVE_ROOT/LiveOS ; fi
  cp /usr/bin/livecd-iso-to-disk $LIVE_ROOT/LiveOS
fi
%end



