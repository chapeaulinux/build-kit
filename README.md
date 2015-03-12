# build-kit
The tools and assets used to build the Chapeau bootable iso image

How to use
==========

Where to put the build-kit directory
------------------------------------
The scripts contained in this build-kit expects the build-kit directory to be in the root filesystem on your build host.
You can either put the directory in your root volume if you have the space or, if the directory is located somewhere else, link or mount to it in root.

### Examples
If you want your build-kit directory in /home/fred then create a symbolic link with;

`$ sudo ln -s /home/fred/build-kit /build-kit`


Personally I use virtual machines for my build hosts and my build-kit directories are located on a file server.
Therefore within my build VMs I mount my remote build-kit directory which is shared via NFS to /build-kit.
e.g.  
`$ sudo mkdir /build-kit`  
`$ sudo mount -t nfs myserver:/home/data/chapeaustuff/build-kit /build-kit`


Setting up your host to build Chapeau
-------------------------------------
It is recommended to build Chapeau on a machine running the same version of Fedora to the version of Chapeau you're building or at least be running the latest Fedora.
To setup your Fedora machine as a build host change directory to /build-kit and run the setup-build-host.sh script.

e.g.  
`$ /build-kit/setup-build-host.sh`

This will install the tools you need to make a livecd image and to build RPM packages.


Building a Chapeau image
------------------------
Once your build host is setup and before running the livecd-creator script set selinux to permissive mode;

`$ sudo setenforce 0`

Then run the livecd-creator script;

`$ cd /build-kit`  
`$ ./livecd-creator.sh`

The tool will create a "buildcache" directory in /build-kit, this is where all the packages will be downloaded to.  
The ISO image will be created in your shell's current directory, i.e. /build-kit  
The temporary files when building the image are located under /var/tmp  
Ensure you have plenty of space available to each of these locations, at least 5GB under /buildkit and 4GB under /var.

Once the live-creator script finishes successfully, you will have a new image file called Chapeau.iso


