#########################################
losetup /dev/loop3 /home/$SUDO_USER/rootfs    #make the container file look like a device
cryptsetup luksOpen /dev/loop3 c1             #begin crypt control of all input/output to the device
mount /dev/mapper/c1 /home/$SUDO_USER/Rootfs  #mount the container at a mountpoint in the host filesystem
xhost local:      #make existing host xwindow server available to the container
#                 #for graphics display. Does not expose the xwindow to network.
#########################################
#populate the container's skeletal filesystem with utilities and libraries from the host
#########################################
if  [ -d /home/$SUDO_USER/Rootfs/dev ]   # minimal sanity check if mountpoints are available in the container
#                              by sampling one mountpoint
    then
mount --bind /dev /home/$SUDO_USER/Rootfs/dev -o ro  # ro='read only' option
mount --bind /etc /home/$SUDO_USER/Rootfs/etc -o ro
mount --bind /bin /home/$SUDO_USER/Rootfs/bin -o ro
mount --bind /lib /home/$SUDO_USER/Rootfs/lib -o ro
mount --bind /lib64 /home/$SUDO_USER/Rootfs/lib64 -o ro
mount --bind /sys /home/$SUDO_USER/Rootfs/sys -o ro
mount --bind /run /home/$SUDO_USER/Rootfs/run -o ro
mount --bind /usr /home/$SUDO_USER/Rootfs/usr -o ro
mount --bind /var /home/$SUDO_USER/Rootfs/var -o ro
mount --bind /opt /home/$SUDO_USER/Rootfs/opt -o ro
mount --bind /sbin /home/$SUDO_USER/Rootfs/sbin -o ro
mount --bind /lib32 /home/$SUDO_USER/Rootfs/lib32 -o ro
else   #failed to find proper mountpoints
     echo "bind mount failed."
     echo /home/$SUDO_USER/Rootfs "does not appear to be a formated alternate root file system."
     exit
fi # end binding host utilities and libraries to container
#
# Reminder messages for user to complete container setup
echo "***********************************"
echo "PLEASE NOTE THE FOLLOWING"
echo "***********************************"
echo "Use ""'"" unshare -p -f chroot "/home/$SUDO_USER/Rootfs" /bin/bash""'"" to attach to the container"
echo "Remember to mount proc from within the alt root."
echo "as root; mount -t proc proc /proc"
echo "unmount /proc before closing the container."
#
