#!/bin/bash


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

# This Function checks the OS is running Rasprian V9 Stretch or exits
checkOSrasprian () {
	
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

# This Function checks that there is enough swap allocated to run node software and creates more if required
checkMem () {

# check swap- space if less that 2GB add space
CURRENTSWAP=`free -m | grep Swap | awk '{print $2}'`
echo "system has $CURRENTSWAP of swap"
	if [ $CURRENTSWAP -lt 1023 ]
	then
	echo "we need more swap space"
	# first check if there is enough disk space to accomodate
	DISKSPACE=`df -m / | awk '{print $4}' | tail -1`
		if [ $DISKSPACE -gt 2000 ]
		then
		SWAPSIZE=`cat /etc/dphys-swapfile | grep SIZE`
		sed -i -r "s/$SWAPSIZE/CONF_SWAPSIZE=1024/" /etc/dphys-swapfile
		/etc/init.d/dphys-swapfile restart
		free
		else
		echo "you do not have enough disk space to increase swap"
		fi
		 
	else
	echo "we have enough swap"
	fi

# add swap
# re-check if addition is successful
	
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

# remove Pi from remote logins
cat /etc/ssh/sshd_config | grep -w 'DenyUsers pi' >> /dev/null
if [ $? -ne 0 ]
then
echo "DenyUsers pi" >> /etc/ssh/sshd_config
echo " added user to ssgd_configZ"
/usr/sbin/service ssh restart
#restart SSHDl
fi


}


# shows which package provides a binary 
whichPackage () {
BINPATH=`which $1`
echo "path = $BINPATH"

	
	}








# call functions
#currentUser
checkOSrasprian 
#checkMem
#changePIpw
#echo ""
#whichPackage "date"

# adding a line to test git commits
