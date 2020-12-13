#!/bin/bash
bootype=bios
ls /sys/irmware/efi/efivars >/dev/null 2>&1 && bootype=efi
echo $bootype
sleep 2
clear
echo "This is my Arch Linux install script"$'\n'"it works only on UEFI systems"$'\n'"If you want the legacy BIOS version check my repoitory"
echo "Set keyboard layout (only croatian and german)"
read -p "Type 'de' for german or 'croat' for croatian: >> " lang1
loadkeys $lang1
clear
echo "Partition disk tool"
echo "You must choose GPT when a prompt shows up"
sleep 1
echo "Choose disk to format/install"
lsblk -d -n -l
read -p "Choose sda or nvme0n1: >> " disk
cfdisk /dev/$disk
echo "--------"
echo "Printing partition table"
echo "--------"
lsblk 
echo "--------"
sleep 1
read -p "Enter root partition: >> " rootp
echo "Set root partition to $rootp "
read -p "Enter boot partition: >> " bootp
echo 'Set boot partition to $bootp '
echo "--------"
echo "Creating file systems"
mkfs.ext4 /dev/$rootp
mkfs.fat -F32 /dev/$bootp
mount /dev/$rootp /mnt
mkdir -p /mnt/boot/efi
mount /dev/$bootp /mnt/boot/efi
sleep 1
echo "Starting Arch Linux download"
sleep 3
pacstrap /mnt base base-devel linux linux-firmware vim
echo "--------"
echo "Downloaded Arch Linux system files"
sleep 1
curl -LO https://raw.github.com/lesacar/install/master/b.sh
echo "bootype=$bootype" >> c.sh
echo "rootp=$rootp" >> c.sh
cat b.sh >> c.sh
cp c.sh /mnt
echo "Base Arch Linux is installed, setting up Arch Linux"
echo "pacman -S nvidia nvidia-utils --noconfirm" >> nvidia.sh
cp nvidia.sh /mnt/nvidia.sh
echo "arch-chroot /mnt bash nvidia.sh" >> install-nvidia.sh
sleep 3
arch-chroot /mnt bash /c.sh
echo "Arch Linux has been successfully installed"
echo "IF YOU HAVE A NVIDIA GRAPHICS CARD TYPE 'sh install-nvidia.sh'"
echo "---------"
echo "The last step is to reboot you computer"
echo "umount -R /mnt"$'\n'"reboot" >> reboot.sh
echo "Type 'sh reboot.sh' to reboot"
