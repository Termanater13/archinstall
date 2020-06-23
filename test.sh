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
EROR='\e[0;31m'
WARN='\e[1;33m'
SUCC='\e[0;32m'
CLER='\e[0m'
NOTE='\e[1;37m'
LEGA='\e[1;35m'
UEFI='\e[1;34m'

################################## Arguments ###################################
# No arguments will be passed in to this file as all appropriate questions will
# be asked at runtime This File will ignore all arguments passed to it.
################################################################################

function f_VERIFY_BOOT_MODE {
	Echo "1"
}
function f_CONNECTION_TEST {
	Echo "2"
}
function f_USERNAME_ASK {
	Echo "3"
}
function f_USERPASS_ASK {
	Echo "4"
}
function f_ROOTPASS_ASK {
	Echo "5"
}
function f_IS_VM_INSTALL {
	Echo "6"
}
function f_UPDATE_CLOCK {
	Echo "7"
}
function f_DISK_PARTITION {
	Echo "8"
}
function f_ARCH_MIRRROR_SETUP {
	Echo "9"
}
function f_PACSTRAP {
	Echo "10"
}
function f_FSTAB {
	Echo "11"
}
function f_CHROOT {
	Echo "12"
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
