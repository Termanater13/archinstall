#!/bin/bash
################################### Details ####################################
# CURRENTLY WIP 
# This script is for installing a minimum install of arch to a computer. This
# script has been tested by the originator of the code to work in a Virtual
# Machine (VM). The goal is to have the system boot back into Arch with only a
# terminal so user can run another script to install everything else they need.
# While the script will auto download the scripts to do this it will also auto
# download a script for the user to install a basic graphical user interface
# (I3) and that script will not be required to be ran for a complete install.
################################################################################

############################# Color text variables #############################
C_EROR='\e[0;31m'
C_WARN='\e[1;33m'
C_SUCC='\e[0;32m'
C_CLER='\e[0m'
C_NOTE='\e[1;37m'
C_BOOT='\e[1;35m'
C_UEFI='\e[1;34m'
echo -e "${C_EROR}ERROR ${C_WARN}WARNING ${C_SUCC}SUCCESS ${C_NOTE}NOTE ${C_BOOT}BOOT ${C_UEFI}UEFI ${C_CLER}CLEAR"
################################## Arguments ###################################
# No arguments will be passed in to this file as all appropriate questions will
# be asked at runtime This File will ignore all arguments passed to it.
################################################################################
DSHARED=( --stdout --backtitle "     Arch Install" )


function f_VERIFY_BOOT_MODE {
	### Verify the boot mode
	if [ -d "/sys/firmware/efi" ]
	then
		BOOT="UEFI"
	else
		BOOT="LEGACY"
	fi
	echo -e "${C_NOTE}[ 1/11]${C_CLER} Boot Mode: ${C_BOOT}${BOOT}${C_CLER}"
}
function f_CONNECTION_TEST {
	if ping -q -c 1 -W 1 google.com > /dev/null; then
		echo -e "${C_NOTE}[ 2/11]${C_CLER} ${C_SUCC}Connected${C_CLER}"
	else
		echo -e "${C_NOTE}[ 2/11]${C_CLER} ${C_EROR}NOT CONNECTED${C_CLER} Please check your connection and try again"
		# exit with code 1
		exit 1
	fi
}
function f_USERNAME_ASK {
	DUSERNAME=("${DSHARED[@]}")
	DUSERNAME+=( --title "USERNAME" )
	DUSERNAME+=( --inputbox "please input a valid username" 8 39 )
	USERNAME=$(dialog "${DUSERNAME[@]}")
	echo -e "${C_NOTE}[ 3/11]${C_CLER}"
}
function f_USERPASS_ASK {
	DUSERPASS=("${DSHARED[@]}")
	DUSERPASS+=( --title "USER PASSWORD" )
	DUSERPASS+=( --passwordbox "Enter the user's Password" 8 39 )
	USERPASS=$(dialog "${DUSERPASS[@]}")
	echo -e "${C_NOTE}[ 4/11]${C_CLER}"
}
function f_ROOTPASS_ASK {
	DROOTPASS=("${DSHARED[@]}")
	DROOTPASS+=( --title "ROOT PASSWORD" )
	DROOTPASS+=( --passwordbox "Enter the Root User Password\nTIP: This should be different from the user password" 10 39 )
	ROOTPASS=$(dialog "${DROOTPASS[@]}")
	echo -e "${C_NOTE}[ 5/11]${C_CLER}"
}
function f_UPDATE_CLOCK {
	# This is to keep any future code in one spot. its overkill right now
	timedatectl set-ntp true
	echo -e "${C_NOTE}[ 6/11]${C_CLER} Clock setup Complete"
}
function f_DISK_PARTITION {
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
}
function f_ARCH_MIRRROR_SETUP {
	pacman -Sy
	pacman --noconfirm -S pacman-contrib
	cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
	awk '/## United States/{print;getline;print}' /etc/pacman.d/mirrorlist.backup | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 10 - > /etc/pacman.d/mirrorlist
	echo -e "${C_NOTE}[ 8/11]${C_CLER} Arch mirrors ranked"
}
function f_PACSTRAP {
	pacstrap /mnt base
	echo -e "${C_NOTE}[ 9/11]${C_CLER}"
}
function f_FSTAB {
	genfstab -U /mnt >> /mnt/etc/fstab
	#virtual box fstab info below this
	echo -e "${C_NOTE}[ 10/11]${C_CLER}"
}
function f_CHROOT {
	echo -e "${C_NOTE}[ 11/11]${C_CLER}"
}









################################ Function Calls ################################
f_VERIFY_BOOT_MODE
f_CONNECTION_TEST
f_USERNAME_ASK
f_USERPASS_ASK
f_ROOTPASS_ASK
f_UPDATE_CLOCK
f_DISK_PARTITION
f_ARCH_MIRRROR_SETUP
f_PACSTRAP
f_FSTAB
##### Last action this script can do.
f_CHROOT
echo "BOOT:      ${BOOT}"
echo "USERNAME:  ${USERNAME}"
echo "USERPASS:  ${USERPASS}"
echo "ROOTPASS:  ${ROOTPASS}"