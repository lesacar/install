#!/bin/bash
echo "If you are reading this, the base installation has succeeded, starting graphical interface installation and configuring system"
echo "-- Choose Desktop --"
read -p "Type 'plasma kde-applications' for KDE --< KDE looks similar to windows, users coming from windows might find it easier to use >-- type 'gnome gnome-extra' for GNOME --< looks similar to macOS, comes by defalt on Ubuntu >--" de
pacman -Syyu --noconfirm
pacman -S networkmanager xorg xorg-xinit man-db man-pages --noconfirm
echo "--------"
echo "Select timezone"
read -p "Timezone - Region >> " reg
read -p "Timezone - City >> " cit
ln -sf /usr/share/zoneinfo/$reg/$cit /etc/localtime
hwclock --systohc
echo "Set hardware clock to UTC"
echo "Set timezone to $reg - $cit"
cp /etc/locale.gen /etc/locale.gen.backup
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "Setting network settings"
read -p "Enter hostname for computer (computer name): >> " hostnm
sleep 1
echo "$hostnm" >> /etc/hostname
echo "127.0.0.1		localhost"$'\n'"::1		localhost"$'\n'"127.01.1	$hostnm.localdomain $hostnm"
echo "-------"
echo "Change root password"
read -s -p "New root password: >> " roopas
echo "root:$roopas" | chpasswd
echo "-------"
echo "Create user"
read -p "New user name: >> " nusrnm
useradd -m -G wheel $nusrnm
read -s -p "Create password for new user: >> " pswfnu
echo "$nusrnm:$pswfnu" | chpasswd
pacman -S grub efibootmgr --noconfirm
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
echo "If all went right Arch Linux was successfully installed"
echo "You need to reboot your computer to boot into the installation"
echo "--------"
echo "To reboot you need to type:"
echo "exit"
echo "umount -R /mnt"
echo "reboot"
