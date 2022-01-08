#!/bin/bash
if  [ -d /home/$SUDO_USER/Rootfs/dev ] #minimal sanity check
    then
    umount /home/$SUDO_USER/Rootfs/dev  
    umount /home/$SUDO_USER/Rootfs/opt 
    umount /home/$SUDO_USER/Rootfs/bin 
    umount /home/$SUDO_USER/Rootfs/lib
    umount /home/$SUDO_USER/Rootfs/sys 
    umount /home/$SUDO_USER/Rootfs/run 
    umount /home/$SUDO_USER/Rootfs/usr 
    umount /home/$SUDO_USER/Rootfs/var
    umount /home/$SUDO_USER/Rootfs/etc
    umount /home/$SUDO_USER/Rootfs/sbin
    umount /home/$SUDO_USER/Rootfs/lib64
#   umount /home/$SUDO_USER/Rootfs/proc # Mounted and unmounted within the container
#   umount /home/$SUDO_USER/Rootfs/tmp  # Not normally mounted to avoid bleeding
#                                       # from container to host.
else
    echo "home/$SUDO_USER/Rootfs does not appear to contain a filesystem."
    exit
fi

if [ -d /home/$SUDO_USER/Rootfs/lib32 ]
    then
    umount /home/$SUDO_USER/Rootfs/lib32
fi
# Example for any non-rootfs devices mounted to the container in the 'open' scriopt
#if  [ -d home/$SUDO_USER/Rootfs/Elements ]
#   then
#   umount /home/$SUDO_USER/Rootfs/Elements 
#fi

umount -l /home/$SUDO_USER/Rootfs
cryptsetup luksClose /dev/mapper/c1 #you will need to change c1 if you changed it in the 'open' script.
losetup -d /dev/loop3 #you will need to change loop3 if you changed it in the 'open' script.
