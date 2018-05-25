#!/bin/bash


#setup log location for install script

# check current user and move to root
currentUser () {
	
	NEWUSER=root
	CURRENTUSER=`whoami`

	if [ "$CURRENTUSER" != "$NEWUSER" ]
	then
		echo "You are running this script as user $CURRENTUSER - You must run as root"
		echo "Exiting Script"
		exit
	fi
}

# This Function checks the OS is running Ubuntu 18 LTS or exits
checkOsVersion () {
	
# set OS flag variable
	OSFLAG='"Ubuntu 18.04 LTS"'

# Get OS version	
	STRINGOS=`cat /etc/*release | grep -i pretty`
	
# Get length of string	
	STRINGLEN=${#STRINGOS}
    STRINGCOUNT=`expr $STRINGLEN - 12`
    
#check OS version against OSFLAG     
    OS="${STRINGOS:12:$STRINGCOUNT}" 
	if [ "$OSFLAG" = "$OS" ]
	then
		echo "This is a supported OS"
	else
		echo "This is an unsupported OS"
		echo "Exiting script"
		exit 
	fi
}

# Create a New User PALIGADMIN add to sudoers

userAdd ()	{
useradd -md /home/paligadmin -G sudo paligadmin
echo "created user paligadmin"
echo "Please set new complex password for user paligadmin:"
sleep 1	
/usr/bin/passwd paligadmin

if [ $? -ne 0 ] 
then
echo "Password reset failed - please try again:"
sleep 1
userAdd
fi	
}


changePIpw () {
echo "Please set new complex password for user PI:"
sleep 1	
/usr/bin/passwd pi

if [ $? -ne 0 ] 
then
echo "Password reset failed - please try again:"
sleep 1
changePIpw
fi

}

#Check Time Zone

#Install base packages
#apt-get update and upgrade
#SSH
#IFCONFIG
#PING
#CRON

#setup basic cron jobs 

#setup ssh key for user PALIGADMIN

#Disable password authentication for SSH

#Setup base firewall rules












