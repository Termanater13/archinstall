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

function f_VERIFY_BOOT_MODE {
	### Verify the boot mode
	if [ -d "/sys/firmware/efi" ]
	then
		BOOT="UEFI"
	else
		BOOT="LEGACY"
	fi
	echo -e "${C_NOTE}[ 1/12]${C_CLER} Boot Mode: ${C_BOOT}${BOOT}${C_CLER}"
}
function f_CONNECTION_TEST {
	if ping -q -c 1 -W 1 google.com > /dev/null; then
		echo -e "${C_NOTE}[ 2/12]${C_CLER} ${C_SUCC}Connected${C_CLER}"
	else
		echo -e "${C_NOTE}[ 2/12]${C_CLER} ${C_EROR}NOT CONNECTED${C_CLER} Please check your connection and try again"
		# exit with code 1
		exit 1
	fi
}
function f_USERNAME_ASK {
	echo "3"
}
function f_USERPASS_ASK {
	echo "4"
}
function f_ROOTPASS_ASK {
	echo "5"
}
function f_IS_VM_INSTALL {
	echo "6"
}
function f_UPDATE_CLOCK {
	# This is to keep any futre code in one spot. its overkill right now
	# timedatectl set-ntp true
	echo "${C_NOTE}[ 7/12]${C_CLER} Clock setup Complete"
}
function f_DISK_PARTITION {
	echo "8"
}
function f_ARCH_MIRRROR_SETUP {
	echo "9"
}
function f_PACSTRAP {
	echo "10"
}
function f_FSTAB {
	echo "11"
}
function f_CHROOT {
	echo "12"
}









################################ Function Calls ################################
f_VERIFY_BOOT_MODE
f_CONNECTION_TEST
f_USERNAME_ASK
f_USERPASS_ASK
f_ROOTPASS_ASK
f_IS_VM_INSTALL
f_UPDATE_CLOCK
f_DISK_PARTITION
f_ARCH_MIRRROR_SETUP
f_PACSTRAP
f_FSTAB
##### Last action this script can do.
f_CHROOT
echo "BOOT:  ${BOOT}"