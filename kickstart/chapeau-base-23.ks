# chapeau_base_23.ks
#
# Kickstart file for Chapeau Linux
#
# http://chapeaulinux.org
# http://sourceforge.net/projects/chapeau

#Commands
lang en_US.UTF-8
keyboard us
timezone US/Eastern
#lang en_GB.UTF-8
#keyboard uk
#timezone --utc Europe/London
auth --useshadow --enablemd5
#selinux --enforcing
selinux --permissive
#selinux --disabled
firewall --enabled --service=mdns
xconfig --startxonboot
part / --size 10240 --fstype ext4
services --enabled=NetworkManager --disabled=network,sshd
rootpw --plaintext chapeau
bootloader --append="rhgb quiet vconsole.font=gr928-8x16-thin.psfu vt.default_red=20,80,75,128,47,118,119,118,65,102,223,84,85,220,85,225 vt.default_grn=20,0,75,85,47,63,121,118,65,157,223,84,85,108,170,225 vt.default_blu=20,0,75,40,133,117,229,118,65,102,94,171,255,163,200,225 vt.color=0x08"

%include chapeau-repos-23.ks
%include chapeau-packages-23.ks


