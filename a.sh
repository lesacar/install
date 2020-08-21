#!/bin/bash
echo "Set keyboard layout (only croatian and german)"
read -p "Type 'de' for german or 'croat' for croatian: >> " lang1
loadkeys $lang1
echo "Partition disk tool"
sleep 1
echo "Choose disk to format/install"
lsblk -d -n -l
read -p "Choose /dev/sda or /dev/nvme0n1: >> " disk
cfdisk $disk
echo "--------"
echo "Printing partition table"
echo "--------"
lsblk
sleep 1
echo "--------"
read -p "Enter root partition: >> " rootp
echo "Set root partition to $rootp "
read -p "Enter boot partition: >> " bootp
echo 'Set boot partition to $bootp '

