### Set ARGS for script(after-chroot.sh $1 $2 $3)
USER=$1
PASS=$2
ROOT=$3
HOST="${USER}-VM"
### Colors
C_EROR='\e[0;31m'
C_WARN='\e[1;33m'
C_SUCC='\e[0;32m'
C_CLER='\e[0m'
C_NOTE='\e[1;37m'
C_BOOT='\e[1;35m'
C_UEFI='\e[1;34m'
#set timezone
echo -e "${C_NOTE}Setting up Timezone${C_CLER}"
timedatectl set-ntp true
ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
timedatectl set-timezone America/New_York
hwclock --systohc

#set localization
echo -e "${C_NOTE}Setting up Localization${C_CLER}"
sed -i 's/^#en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
#set Network configuration

echo -e "${C_NOTE}Setting up basic network settings${C_CLER}"
echo "${HOST}" >> /etc/hostname
echo "127.0.0.1	localhost" >> /etc/hosts
echo "::1	localhost" >> /etc/hosts
echo "127.0.1.1	${HOST}.localdomain	${HOST}" >> /etc/hosts

echo -e "${C_NOTE}${C_CLER}"
# no ititramfs needed
#set users and passwords
#reboot

echo "USER: ${USER}"
echo "PASS: ${PASS}"
echo "ROOT: ${ROOT}"
echo "HOST: ${HOST}"