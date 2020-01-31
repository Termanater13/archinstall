### EVERY THING ARTER arch-chroot WILL NOT RUN MOVE TO NEW SCRIPT AND PLACE IT UNDER 
##### Everything here is after root folder change
### change local time to my local timezone
echo -e "${NOTE}Set Timezone and clock"
ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
hwclock --systohc

##### Set Localazaion
echo -e "${NOTE}set localization info${CLER}"
### uncomment the one line for my local and run local-gen
sed -i 's/^#en_US.UTF-8/en_US.utf-8/' /etc/locale.gen
locale-gen
### sety lang Variable in config to locale
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
### skiped setting keyboard layout as no change has been made and defualt is all that is needed for me

##### Setup Hostename 
echo -e "${NOTE}Setup hostename${CLER}"
echo "AVM" >> /etc/hostname

echo -e "${NOTE}Setup hosts file${CLER}"
echo -e "127.0.0.1\tlocalhost" >> /etc/hosts
echo -e "::1\tlocalhost" >> /etc/hosts
echo -e "127.0.1.1\tAVM.localdomain\tAVM" >> /etc/hosts

### Initramfs
### Root password
### Boot loader