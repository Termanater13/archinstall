#!/bin/bash

############################# Color text variables #############################
C_CLER='\e[0m'
C_NOTE='\e[1;37m'
C_BOOT='\e[1;35m'
C_EROR='\e[0;31m'


if ping -q -c 1 -W 1 google.com > /dev/null; then
	echo -e "${C_NOTE}[ 1/11]${C_CLER} ${C_SUCC}Connected${C_CLER}"
else
	echo -e "${C_NOTE}[ 1/11]${C_CLER} ${C_EROR}NOT CONNECTED${C_CLER} Please check your connection and try again"
	# exit with code 1
	exit 1
fi

DSHARED=( --stdout --backtitle "     Arch Install" )
DUSERNAME=("${DSHARED[@]}")
DUSERNAME+=( --title "USERNAME" )
DUSERNAME+=( --inputbox "please input a valid username" 8 39 )
DUSERPASS=("${DSHARED[@]}")
DUSERPASS+=( --title "USER PASSWORD" )
DUSERPASS+=( --passwordbox "Enter the user's Password" 8 39 )
DROOTPASS=("${DSHARED[@]}")
DROOTPASS+=( --title "ROOT PASSWORD" )
DROOTPASS+=( --passwordbox "Enter the Root User Password\nTIP: This should be different from the user password" 10 39 )

USERNAME=$(dialog "${DUSERNAME[@]}")
echo -e "${C_NOTE}[ 2/11]${C_CLER}"
USERPASS=$(dialog "${DUSERPASS[@]}")
echo -e "${C_NOTE}[ 3/11]${C_CLER}"
ROOTPASS=$(dialog "${DROOTPASS[@]}")
echo -e "${C_NOTE}[ 4/11]${C_CLER}"

if [ -d "/sys/firmware/efi" ]
then
	BOOT="UEFI"
else
	BOOT="LEGACY"
fi
echo -e "${C_NOTE}[ 5/11]${C_CLER} Boot Mode: ${C_BOOT}${BOOT}${C_CLER}"

timedatectl set-ntp true
echo -e "${C_NOTE}[ 6/11]${C_CLER} Clock setup Complete"

if [ $BOOT = "UEFI" ]
then
	#sdX1 boot(512MiB)|SdX2 root(what's left after sdX1 or sdx3)|sdX3 swap(4GiB)
	parted -a optimal -s /dev/sda -- mklabel gpt \
	mkpart primary ext2 0% 512MiB set 1 esp on \
	mkpart primary ext4 512MiB -4GiB \
	mkpart primary linux-swap -4GiB 100% set 3 swap on
	mkfs.ext2 -F /dev/sda1
	mkfs.ext4 -F /dev/sda2
	mkswap /dev/sda3
	mount /dev/sda2 /mnt
	mkdir /mnt/boot
	mount /dev/sda1 /mnt/boot
	swapon /dev/sda3
else
	#sda1 main partition/sda2 swap
	parted -a optimal -s /dev/sda -- mklabel msdos \
	mkpart primary ext4 0% -4GiB set 1 boot on \
	mkpart primary linux-swap -4GiB 100%
	mkfs.ext4 -F /dev/sda1
	mkswap /dev/sda2
	swapon /dev/sda2
	mount /dev/sda1 /mnt
fi
echo -e "${C_NOTE}[ 7/11]${C_CLER} Partition of hard-drive complete"

pacman -Sy
pacman --noconfirm -S pacman-contrib
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
awk '/## United States/{print;getline;print}' /etc/pacman.d/mirrorlist.backup | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 10 - > /etc/pacman.d/mirrorlist
echo -e "${C_NOTE}[ 8/11]${C_CLER} Arch mirrors ranked"

pacstrap /mnt base
echo -e "${C_NOTE}[ 9/11]${C_CLER}"

genfstab -U /mnt >> /mnt/etc/fstab
#virtual box fstab info below this
echo -e "${C_NOTE}[ 10/11]${C_CLER}"

wget https://raw.githubusercontent.com/Termanater13/archinstall/master/after-chroot.sh -O /mnt/after-chroot.sh
arch-chroot /mnt /bin/bash ./after-chroot.sh $USERNAME $USERPASS $ROOTPASS
echo -e "${C_NOTE}[ 11/11]${C_CLER}