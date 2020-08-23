#!/bin/bash
echo "-- Choose Desktop --"
echo "The Desktop enviroment is the graphical interface you will be interacting with (all the icons, start menu, task bar, etc...)"
echo "You can leave the below blank if you have your own build of a graphical interface or you can typeyour choice if it isn't listed"
read -p "Type 'plasma kde-applications' for KDE --< KDE looks similar to windows, users coming from windows might find it easier to use >-- type 'gnome gnome-extra' for GNOME --< looks similar to macOS, comes by defalt on Ubuntu >-- Type 'xfce4 xfce4-goodies' for xfce --< Also similar to windows but more retro-looking and lightweight >--" de
pacman -Syyu --noconfirm
pacman -S networkmanager xorg xorg-xinit man-db man-pages linux-headers $de --noconfirm
systemctl enable NetworkManager
systemctl start NetworkManager
echo "--------"
echo "Installing the sddm display manager"
pacman -S sddm --noconfirm
systemctl enable sddm
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
locale-gen
echo "Setting network settings"
read -p "Enter hostname for computer (computer name): >> " hostnm
sleep 1
echo "$hostnm" >> /etc/hostname
echo "127.0.0.1		localhost"$'\n'"::1		localhost"$'\n'"127.01.1	$hostnm.localdomain $hostnm" >> /etc/hosts
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
echo "You will need to specify what CPU brand you're using"
read -p "Type 'amd' for amd or 'intel' for intel >> " cpu
pacman -S $cpu-ucode --noconfirm
echo "-------"
echo "Install graphics driver"
read -p "IF YOU ARE USING A NVIDIA GRAPHICS CARD YOU WILL NEED TO MANUALLY INSTALL THE DRIVER, READ THE GUIDE AFTER THE INSTALLATION HAS COMPLETED. Type amdgpu for amd graphics, intel for intel graphics, or vmware for vmware graphics" gpudrvrs
pacman -S xf86-video-$gpudrvrs --noconfirm
echo "---------------------------------"
