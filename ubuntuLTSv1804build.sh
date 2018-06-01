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
	
	sudo -u paligadmin mkdir /home/paligadmin/.ssh/
	chmod 700 /home/paligadmin/.ssh/
	sudo -u paligadmin touch /home/paligadmin/.ssh/authorized_keys
	chmod 600 /home/paligadmin/.ssh/authorized_keys
	
	
}

sshAddKey ()	{
	
	echo "Adding SSH Secuirty"
	echo "Please copy SSH public key:"
	read KEY
	echo "$KEY" > /home/paligadmin/.ssh/authorized_keys
	echo "Please now test SSH access using your key"
	echo "using paligadmin@IPaddress"
	echo  "Type Y or y if ssh test was successful"
	read FLAG
	if [ "$FLAG" != "Y" ] && [ "$FLAG" != "y" ];
	then
	sshAddKey
	fi
}



#Check Time Zone
#Install base packages

basePackagadd ()	{
	ping -c google.com
	if [ "$?" -ne "0" ]
	then
		echo "internet down -check connectivity"
	else
		apt-get update -y && apt-get upgrade -y
		apt-get install net-tools -y
	fi
}

#apt-get update and upgrade
#SSH
#IFCONFIG
#PING
#CRON

#setup basic cron jobs 

#setup ssh key for user PALIGADMIN and Disable password authentication for SSH



#Setup base firewall rules
#rename server 
#set time zone

#currentUser
#checkOsVersls
#userAdd
sshAddKey










