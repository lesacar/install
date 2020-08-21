#!/bin/bash
echo "This is my Arch Linux install script"$'\n'"it works only on UEFI systems"$'\n'"If you want the legacy BIOS version check my repoitory"
echo "Set keyboard layout (only croatian and german)"
read -p "Type 'de' for german or 'croat' for croatian: >> " lang1
loadkeys $lang1
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
mkfs.ext4 $rootp
mkfs.fat -F32 /dev/$bootp
mount $rootp /mnt
mkdir -R /mnt/boot/efi
mount /dev/$bootp /mnt/boot/efi
sleep 1
echo "Starting Arch Linux download"
sleep 3
pacstrap /mnt base base-devel linux linux-firmware vim
echo "--------"
echo "Downloaded Arch Linux system files"
sleep 1
wget https://raw.github.com/lesacar/install/master/b.sh
cp b.sh /mnt
echo "Base Arhch Linux is installed, setting up Arch Linux"
sleep 3
arch-chroot /mnt bash /b.sh
