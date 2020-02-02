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

################################ Argument Test #################################
# pattern: install.sh <username> <user_password> <user_aurgs_here>
# assumptions if onlyw 2 passed
#     1.) root_password is same as user
#     2.) Script is for a Computer and not a VM
######################## Variables used in this scritp #########################
# ARGMODE | This holds the necessary value so that the current argument can be 
#           processed properly
# VMINSTALL | This holds wether the install is on a Virtual Machine
# USERNAME | The user name for the user
# USERPASS | Password for the user account
# ROOTPASS | Root account password
################################################################################
##### process arguments passed
ARGNUM=$#
ARGMODE="ONE"
VMINSTALL=FALSE
for arg in "$@"
do
    case $ARGMODE in
        ONE)
            USERNAME=$arg
            ARGMODE="TWO";;
        TWO)
            USERPASS=$arg
            ARGMODE="ARGCHECK";;
        ARGCHECK)
            echo "extra arg: $arg"
            case $arg in
                --vm)
                    VMINSTALL="TRUE";;
                *)
                    if [ -z "$ROOTPASS" ]
                    then
                        ROOTPASS=$arg
                    fi
            esac;;
    esac
done
##### makesure args passed properly and all required set the appropret variables
if [ -z "$USERNAME" ]
then
    echo "user name not set"
fi

if [ -z "$USERPASS" ]
then
    echo "user password not set"
fi

if [ -z "$ROOTPASS" ]
then
    ROOTPASS=$USERPASS
fi

echo "${ROOTPASS}"

echo -e "${EROR}Error text${CLER}"
echo -e "${WARN}Wanrning text${CLER}"
echo -e "${SUCC}SUCESS text${CLER}"
echo -e "${NOTE}NOTE text${CLER}"
echo -e "${LEGA}Legacy text${CLER}"
echo -e "${UEFI}UEFI text${CLER}"