#!/bin/bash

##### arguments test
### set arg var defaults
ARGCASE="CHECK"
VMINSTALL="FALSE"
RSAUPASS="FALSE"
for arg in "$@"
do
	case $ARGMODE in
		CHECK)
			case $arg in
				-u | --username)
				ARGMODE="USERNAME"
				;;
				-p | --userpass | --userpassword)
				ARGMODE="USERPASS"
				;;
				-r | --rootpass | --rootpassword)
				ARGMODE="ROOTPASS"
				;;
				-vm)
				VMINSTALL="TRUE"
				;;
				-h | --help | *)
				echo "This Script is for automating the install of arch linux"
				echo "-u\t--username\n\tSet the user name of the users account"
				echo "-p\t--userpass\t--userpassword\n\tSet the user password of the users account"
				echo "-r\t--rootpass\t--rootpassword\n\tSet the root user's password"
				echo "-vm\n\tThis is for when instaling to a virtual machine as some items are not needed since host machene takes care of them"
				echo "-rsau\n\tSet Root user password to be the same as user\n\tNOTE: This is not recomended as this could be a security risk"
				echo "-h\t--help\n\tshow this text"
				exit 0
				;;
			esac
			;;
		USERNAME)
			USERNAME=$arg
			;;
		USERPASS)
			USERPASS=$arg
			;;
		ROOTPASS)
			ROOTPASS=$arg
			;;
	esac
done

### Varibles to run the rest of the script with
EROR='\e[0;31m'
WARN='\e[1;33m'
SUCC='\e[0;32m'
CLER='\e[0m'
NOTE='\e[1;37m'
LEGA='\e[1;35m'
UEFI='\e[1;34m'


### Check for internet Connection
echo -e "${NOTE}Checking for internet Connection:${CLER}"
if ping -q -c 1 -W 1 google.com > /dev/null; then
	echo -e "${SUCC}Connected${CLER}\n"
else
	echo -e "${EROR}NOT CONNECTED${CLER} Please check your connection and try again"
	# exit with code 1
	exit 1
fi

### Basic setup question if not passed as arguments
## username -un --username
## user passward -up --userpass (if skiped use root pass)
## root passward -rp --rootpass (if skiped for generic pass)
##      not a sucure if passed but better then none



##### Install STEPS
### Step One Keyboard Layout
# Skiped as The default keymap is all I need

### Verify the boot mode
if [ -d "/sys/firmware/efi" ]
then
	echo -e "${UEFI}UEFI boot ${NOTE}mode${CLER}"
	BOOT="UEFI"
else
	echo -e "${LEGA}Legacy boot ${NOTE}mode${CLER}"
	BOOT="LEGACY"
fi

### update system clock
timedatectl set-ntp true

### Partition, format, and mount the harddrives based on BOOT mode
if [ $BOOT = "UEFI" ]
then
	#sdX1 boot(512MiB)|SdX2 root(whats left after sdX1 or sdx3)|sdX3 swap(4GiB)
	parted -a optimal -s /dev/sda -- mklabel gpt mkpart primary ext2 0% 512MiB set 1 esp on mkpart primary ext4 512MiB -4GiB mkpart primary linux-swap -4GiB 100% set 3 swap on
	mkfs.ext2 -F /dev/sda1
	mkfs.ext4 -F /dev/sda2
	mkswap /dev/sda3
	mount /dev/sda2 /mnt
	mkdir /mnt/boot
	mount /dev/sda1 /mnt/boot
	swapon /dev/sda3
else
	#sdX1 root(rest minus sdX2)|sdX2 swap(4GiB)
	parted -a optimal -s /dev/sda -- mklabel msdos mkpart primary ext4 0% -4 GiB set 1 boot on mkpart primary linux swap -4GiB 100% set 2 swap on
	mkfs.ext4 -F /dev/sda1
	mkswap /dev/sda2
	mount /dev/sda1 /mnt
	swapon /dev/sad2
fi

echo -e "${NOTE}Ranking Pacman Mirrors${CLER}"
pacman -Sy
pacman --noconfirm -S pacman-contrib
mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
awk '/## United States/{print;getline;print}' /etc/pacman.d/mirrorlist.backup | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 10 - > /etc/pacman.d/mirrorlist

echo -e "${NOTE}instaling arch and base packages${CLER}"
pacstrap /mnt base linux-lts linux-firmware

echo -e "${NOTE}Generate fstab${CLER}"
genfstab -U /mnt >> /mnt/etc/fstab

echo -e "${NOTE}Getting Post install script${CLER}"
wget https://raw.githubusercontent.com/Termanater13/archinstall/master/postinstall.sh -P /mnt/root/

echo -e "${NOTE}Chroot${CLER}"
arch-chroot /mnt /mnt/root/postinstall.sh


