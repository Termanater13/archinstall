#!/bin/bash

### Varibles to run the rest of the script with
EROR='\e[0;31m'
WARN='\e[1;33m'
SUCC='\e[0;32m'
CLER='\e[0m'
NOTE="\e[1;37m"


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
    echo -e "\e[1;34mUEFI boot \e[0mmode"
    BOOT="UEFI"
else
    echo -e "\e[1;35mLegacy boot \e[0mmode"
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

echo -e "${NOTE}Chroot${CLER}"
arch-chroot /mnt

##### Everything here is after root folder change
### change local time to my local timezone
echo -e "${NOTE}Set Timezone and clock"
ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
hwclock --systohc

echo -e "set localization info${CLER}"
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
### skiped setting keyboard layout as no change has been made and defualt is all that is needed for me

echo -e "${NOTE}Setup hostename${CLER}"
echo "AVM" >> /etc/hostname

echo -e "${NOTE}Setup hosts file${CLER}"
echo -e "127.0.0.1\tlocalhost" >> /etc/hosts
echo -e "::1\tlocalhost" >> /etc/hosts
echo -e "127.0.1.1\tAVM.localdomain\tAVM" >> /etc/hosts

