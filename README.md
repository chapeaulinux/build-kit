# build-kit
The tools and assets used to build the Chapeau bootable iso image

How to use
==========

In order to build a Chapeau image one must first have your build system running the equivalent or later version of Fedora Workstation to the Chapeau version you intend to build.  
Download the build-kit zip file or clone the build-kit git repository then setup the build host with the supplied setup script, then you're good to go.


Where to put the build-kit directory
------------------------------------
The scripts contained in this build-kit expects the build-kit directory to be in the root filesystem on your build host.
You can either put the directory in your root volume if you have the space or, if you need the build-kit directory to be located somewhere else, link or mount to it in root.

### Examples
If you want your build-kit directory to be in /home/fred then you still need to create a symbolic link to it in / with;

`$ sudo ln -s /home/fred/build-kit /build-kit`


Personally my build hosts are virtual machines and my build-kit directories are located on a file server shared via NFS. Therefore within my VMs I mount my remote build-kit directories to /build-kit.
e.g.  
`$ sudo mkdir /build-kit`  
`$ sudo mount -t nfs myserver:/data/chapeau/build-kit /build-kit`


Setting up your Fedora host to build Chapeau
--------------------------------------------
It is recommended to build Chapeau on a machine running the same version of Fedora to the version of Chapeau you're building or at least be running the latest Fedora.
To setup your Fedora machine as a build host run the setup-build-host.sh script in /build-kit.

e.g.  
`$ /build-kit/setup-build-host.sh`

This will install and setup the tools you need to make a bootable Chapeau image and to build RPM packages.


Building a Chapeau image
------------------------
Once your build host is setup selinux should be in permissive mode, the livecd-creator.sh script will attempt to do this for you when run.  
Run the script as yourself not as root, it will prompt you to enter your password for sudo when it requires elevated privileges.  

`$ cd /build-kit`  
`$ ./livecd-creator.sh`

The tool will create a directory called *buildcache* in /build-kit, this is where all the build's packages will be downloaded to.  
The ISO image will be created in your shell's current working directory, i.e. /build-kit as shown above.  
The temporary files created when building the image are located under /var/tmp  
Ensure you have plenty of disk space available to each of these locations, at least 6GB under /buildkit and at least 4GB under /var.

Once the live-creator.sh script finishes successfully, you will have a new image file called *Chapeau.iso*  
