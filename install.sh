################################### Details ####################################
# CURRENTLY WIP 
# This script is for installing a minimum install of arch to a computer. This
# script has been tested by the originator of the code to work in a Virtual
# Machine (VM). The goal is to have the system boot back into Arch with only a
# terminal so user can run another script to install everything else they need.
# While the script will auto download the scripts to do this it will also auto
# download a script for the user to install a basic graphical user interface
# (I3) and that script will not be required to be ran for a complete install. 

################################ Argument Test #################################
# pattern: install.sh <username> <user_password> <user_aurgs_here>
# assumptions if onlyw 2 passed
#     1.) root_password is same as user
#     2.) Script is for a Computer and not a VM
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
echo "USERNAME: ${USERNAME}"
echo "USERPASS: ${USERPASS}"
echo "VMINSTALL: ${VMINSTALL}"
echo "# OF ARGS: ${ARGNUM}"