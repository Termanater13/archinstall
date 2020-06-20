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

################################# Dialog setup #################################
# This part sets up the dialog inputs used though out this script
################################################################################
#### Shared part of the dialog
DSHARED=( --stdout --backtitle "    Arch Install" )
#### Set Warning Dialog
DNOTICE=("${DSHARED[@]}")
DNOTICE+=( --title "NOTICE" )
DNOTICE+=( --msgbox "File is provided as is, with NO Warranty.\nScript is Open Source.\nURL:\n  https://github.com/Termanater13/archinstall" 8 50)
#### Set USERNAME dialog
DUSERNAME=("${DSHARED[@]}")
DUSERNAME+=( --title "USERNAME" )
DUSERNAME+=( --inputbox "please input a valid username" 8 39 )
#### Set USER PASSWORD dialog
DUSERPASS=("${DSHARED[@]}")
DUSERPASS+=( --title "USER PASSWORD" )
DUSERPASS+=( --passwordbox "Enter the user's Password" 8 39 )
#### Set ROOT PASSWORD dialog
DROOTPASS=("${DSHARED[@]}")
DROOTPASS+=( --title "ROOT PASSWORD" )
DROOTPASS+=( --passwordbox "Enter the Root User Password\nTIP: This should be differnt from the user password" 10 39 )
#### is this a VM install
DISVM=("${DSHARED[@]}")
DISVM+=( --title "VM" )
DISVM+=( --yesno "Are you installing to a VM?" 5 39 )
##### Harddrive Swap Size #####
DHDSWAPOPT=( 1 "1 GiB" )
DHDSWAPOPT+=( 2 "2 GiB" )
DHDSWAPOPT+=( 3 "3 GiB" )
DHDSWAPOPT+=( 4 "4 GiB" )
DHDSWAPOPT+=( 5 "5 GiB" )
DHDSWAP=( "${DSHARED[@]}" )
DHDSWAP+=( --title "Swap Size" )
DHDSWAP+=( --menu "Select Swap partition size" 13 30 5 )
DHDSWAP+=( "${DHDSWAPOPT[@]}" )


############################### Startup questions ##############################
# These questions are to help set up the install
################################################################################

##### Warning #####
dialog "${DNOTICE[@]}"
##### Username #####
USERNAME=$(dialog "${DUSERNAME[@]}")
##### User Password #####
PASSWORD=$(dialog "${DUSERPASS[@]}")
##### Root user password #####
ROOTPASS=$(dialog "${DROOTPASS[@]}")
##### VM install? #####
##### need to capure exit code, 0=Yes, 1=No #####
if $(dialog "${DISVM[@]}")
then
    ISVM="VM Install"
else
    ISVM="NON VM Install"
fi
##### Hardrive settings #####
HDSWAP=$(dialog "${DHDSWAP[@]}")

##### other as needed #####

##### Begin code to start install #####
# most of this code is copy pasted from old code and needs to be converted to match the style above in layout
# and UI for the user

### Verify the boot mode
if [ -d "/sys/firmware/efi" ]
then
	echo -e "${UEFI}UEFI boot ${NOTE}mode${CLER}"
	BOOT="UEFI"
else
	echo -e "${LEGA}Legacy boot ${NOTE}mode${CLER}"
	BOOT="LEGACY"
fi


### Check for internet Connection
echo -e "${NOTE}Checking for internet Connection:${CLER}"
if ping -q -c 1 -W 1 google.com > /dev/null; then
	echo -e "${SUCC}Connected${CLER}\n"
else
	echo -e "${EROR}NOT CONNECTED${CLER} Please check your connection and try again"
	# exit with code 1
	exit 1
fi










































