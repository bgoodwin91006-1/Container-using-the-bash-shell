*********************
SECTION
*********************
Disclaimer
*********************
NOTE: This is not a safe environment for running malicious  code.
It is primarily for added privacy on your system.

Do not use these scripts or instructions if you are unfamiliar
with the concepts of what is being done or the terms used to
describe the required actions. I am not responsible for what you
do to your computer.

There is much room for improvement in these scripts. For example command line
options to name a different container file or mountpoint. Better shutdown of
the container before un-mounting. Control groups could be added to limit the
amount of memory the container is allow to use or the percentage of cpu allowed.
Please feel free to make it better and publish your improvements.

*********************
SECTION
*********************
requirements
*********************
You will need superuser permissions with sudo.

You will need one available /dev/loop device. The default is loop3. If this loop
is unavailable/in-use you will need to edit the scripts to reflect you loop choice.

You will need Luks encryption.
$ sudo apt install luks

You will also need to create a skeletal container using instructions in the last
section of this README.

*********************
SECTION
*********************
What's here
*********************
Here are scripts to mount and unmount a previously created skeletal Linux file system
as a container providing namespace isolation. The script binds existing host utilities
and libraries to that container as read-only files So no system files are stored in the
Container itself. All the space is available for the user.

See the last section of this README for creating a skeletal rootfs container space. It
is created using only bash commands.

User files created within the container will remain in the container when it is
closed and will be recovered when the container is opened again.
DO NOT RENAME, REDATE OR MOVE THE CONTAINER FILE. This will render the
file unreadable by Luks encryption.

Apps running within the container will be isolated from the host system with the
exception of using the hosts' xwindow screen for graphics display purposes. The host will
have access to the containers' content (permissions allowing) during the time it is open but
not vice-versa. No separate desktop is created for the container. Your programs will have
to be launched from a command line but will appear on the host desktop running at native speed.
Apps installed on the host using apt should all be available within the container.

*********************
SECTION
*********************
open-container.sh script
*********************

this script does a complete mount of a pre-made container filesystem and prints out final
instructions for needed user actions to properly enter the container.
Once this script finishes, you can list the container device as /dev/mapper/c1.

*********************
SECTION
*********************
close-container.sh script
*********************
You should close all apps running inside the container and exit before using this script to close the container.
This script will first unbind the hosts' libraries and utilities from the container. It will unmount
the rootfs from the ~/Rootfs mountpoint. It closes the encryption filter making the file unreadable and
finally, it will release the loop device so that the file is again a simple encrypted file. This may
produce messages that some bindings were not released and the container was busy and not unmounted. If
you check ~/Rootfs you will find it empty. You will find /dev/mapper/c1 is no longer listed and
losetup has released the loop device. In short, it's closed.

*******************************
* SECTION
*******************************
* Create a luks encrypted container
* for use with these scripts
*******************************
*******************************
A file needs to be created to use as a container space. Below
is instructions with command line entries you can copy/paste
to a terminal.

To make an empty file filled with zeros, edit the following
command line entry to reflect your choice of container size
and then copy/paste to a terminal;

$ sudo dd count=[see-below] if=/dev/zero of=~/rootfs

count is in number of blocks. default block size is 512 bytes
following are examples file sizes based on the count value.

*******************************
option1 or option2  file-size
--------------------------------
count=1     -       = (512bytes)
count=2     -       = (1K)
count=100   -       = (51k)
count=1000  1K      = (512K)
count=2000  2K      = (1M)
count=10000 10k     = (5M)
count= -    20k     = (10M)  - useable under certain circumstances
count= -    100k    = (50M)  - Suitable for small apps with limited date storage
count= -    200k    = (100M)
count= -    2M      = (1G)   - If you have the disk space and want a larger container
count= -    100M    = (51G)  - Not a big deal on a 1TB disk drive. Takes a while to create.
count= -    200M    = (100G) - Probably way more than you need.
*******************************

Make the created file appear as a device to the system.

    $ sudo losetup /dev/loop3 ~/rootfs

Make the file encrypted through its device interface

    $ sudo cryptsetup luksFormat /dev/loop3
Follow the on-screen instructions. Accept the overwrite option

Map the encrpted container to /dev/mapper

    $ sudo cryptsetup luksOpen /dev/loop3 c1
The container will now appear as /dev/mapper/c1.

Create a filesystem in the encryption-mapped device.

  $ sudo mkfs.ext4 /dev/mapper/c1

If all went well, it should be possible to mount this encrypted device
to a mountpoint on the host system. The example default mountpoint is ~/Rootfs

 $ mkdir ~/Rootfs
 $ sudo mount /dev/mapper/c1 ~/Rootfs

The next step is to create a skeletal root file system.

$ cd ~/Rootfs
$ sudo mkdir opt tmp bin sbin lib lib64 proc sys run usr var etc home dev

If your host contains a /lib32 you should add that to the mkdir above.

Use the close-container.sh script to finish. Use the
open-container.sh script to begin using the container.

