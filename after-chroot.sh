### Set ARGS for script(after-chroot.sh $1 $2 $3)
USER=$1
PASS=$2
ROOT=$3
HOST="${USER}-VM"
#set timezone
ls -sf /usr/share/zoneinfo/America/New_York /etc/localtime
hwclock --systohc
#set localization
sed 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
#set Network configuration
echo "${HOST}" >> /etc/hostname

# no ititramfs needed
#set users and passwords
#reboot

echo "USER: ${USER}"
echo "PASS: ${PASS}"
echo "ROOT: ${ROOT}"
echo "HOST: ${HOST}"