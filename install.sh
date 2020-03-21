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

############################### Startup questions ##############################
# These questions are to help set up the install
################################################################################

##### Warning #####
whiptail --backtitle "   Arch Install" --title "NOTICE" --msgbox "This file is Provided as is, no warranty is given or should be expected.\nScript is open source." 9 42
##### Username #####
USERNAME=$(whiptail --backtitle "   Arch Install" --title "USERNAME" --inputbox "Please enter a valid Username." 8 42)
##### User Password#####
PASSWORD=$(whiptail --backtitle "   Arch Install" --title "PASSWORD" --passwordbpx "Please enter a password for the user account" 8 42)
##### RootPassword (blank for same as user) #####

##### VM install? #####

##### Hardrive settings #####

##### other as needed #####


############# Just some tests to see if everything is running right ############
##### any code here is temporary to see if code above ir running correctly #####
echo "Username:"
echo "$USERNAME"
echo "Password:"
echo "$PASSWORD"