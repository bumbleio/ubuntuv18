#!/bin/bash

#setup script for  Ubuntu 18.04 LTS

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
setHostname () {
	echo " Please enter desired hostname: "
	read HOSTNAME
	hostnamectl set-hostname "HOSTNAME"
	sed -i 's/preserve_hostname: false/preserve_hostname: true/' /etc/cloud/cloud.cfg
}

# Set timezone either US central or UK GMT
setTimeZone () {
	
	echo " Please Nominate TimeZone - 1 for UK GMT or 2 for US central"
	read ZONE
	case $ZONE in
	1) 	echo "Setting timezone to UK gmt"
		rm /etc/localtime
		ln -s /usr/share/zoneinfo/Europe/London /etc/localtime
		sleep 5
		echo "The local time on this machine is `date`"
	;;
	2) 	echo "Setting timezone to US cst"
		rm /etc/localtime
		ln -s /usr/share/zoneinfo/US/Central /etc/localtime
		sleep 5
		echo "The local time on this machine is `date`"
	;;
	*) 	echo "incorrect entry -Please try again"
		setTimeZone
	;;
	esac
	
	
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

# add SSH key to  User PALIGADMIN
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

# Remove password logins for ssh
secureSsh ()	{
	echo "Do you want to restrict ssh password authnetication. Y or N"
	read RESPONSE
	if [ "$FLAG" != "Y" ] && [ "$FLAG" != "y" ];
	then
	echo "Restricting ssh password login "
	sed -i 's/#PasswordAuthnetication yes/PasswordAuthnetication no/' /etc/ssh/sshd_config
	systemctl reload sshd
	else
	echo "Left default configurtaion - SSH  password authnetication enabled"
	fi
}

# This function is not working set
setNetworking () {
	echo "Please enter IP adress"
	read IP
	echo "Please enter subnet mask"
	read MASK
	echo "Please enter gateway"
	read GW
	echo "Please enter DNS server"
	read DNS
	echo "Please validate these are correct"
	echo "IP:			$IP"
	echo "Subnet Mask:	$MASK"
	echo "Gateway:		$GW"
	echo "DNS Server:	$DNS"
	echo " "
	echo "If this is correct please enter Y"
	read RESPONSE
		case $RESPONSE in
		[yY] | [yY][Ee][Ss] )
		echo "writing networking"
		ifconfig eth0 $IP
		;;
	
		*)
		echo " Start Over "
		setNetworking
		;;
		esac
	
}

# Install base packages
basePackageAdd ()	{
	ping -c 2 google.com
	if [ "$?" -ne "0" ]
	then
		echo "internet down -check connectivity"
	else
		apt-get update -y && apt-get upgrade -y
		apt-get install net-tools -y
	fi
}

# Setup firewalls
setFirewallRules () {

}







#currentUser
#checkOsVersls
#userAdd
#sshAddKey
#setTimeZone
#basePackageAdd
#setNetworking










