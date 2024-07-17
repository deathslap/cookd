#!/bin/bash

# Some functions to clean up
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

format
sleep .5

read -p "Name your working directory:"$'\n>>> ' dir
# dir = ${directory:-default}

format
sleep .5

if [ -d /tmp/$dir ]; then
        echo -e "/tmp/$dir already exists!\n"
        read -p "Do you want to remove /tmp/$dir? Y/n"$'\n>>> ' ans
                if [[ $ans =~ ^[Yy]$ ]]; then
                        rm -rf /tmp/$dir
                fi
                format
                if [[ $ans =~ ^[Nn]$ ]]; then
                        exit
                fi
        read -p "Name your working directory:"$'\n>>> ' dir
        sleep 3
fi

if [ ! -d /tmp/$dir ]; then
        echo -e "/tmp/$dir does not exist!\nCreating your directory!\n"
        mkdir /tmp/$dir
        sleep 3
fi

# Need to add overwrite/remove directory option
# Add logic to check if file exists currently

touch /tmp/$dir/hostinfo.ckd
touch /tmp/$dir/netinfo.ckd

format

echo -e "Gathering some basic host information...\n"


#stage rev shell or shell code?
#exfil data found to $dir?

sleep 3
echo -e "Your username is: "; whoami
user="$(whoami)"
nl
echo -e "Your hostname is: "; hostname
        # echo hostname > /tmp/$dir/hostinfo.cooked
host="$(hostname)"
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

#----- Create path variables and output files -----
hostpath=/tmp/$dir/hostinfo.ckd
netpath=/tmp/$dir/netinfo.ckd

#----- Formating children files -----
echo -e "----- Host info -----" > $hostpath
echo "" >> $hostpath
echo -e "--- user@host ---" >> $hostpath
echo -e "$user@$host\n" >> $hostpath
echo -e "--- OS Information ---" >> $hostpath
cat /etc/*-release >> $hostpath


echo -e "\n--- Kernel Information ---" >> $hostpath
cat /proc/version >> $hostpath

# net info
## echo -e "Your IP address(es): "; ip -4 addr | grep -oP '(?<=inet\s)\d+(\.\d+){3}'
## TUN=$(ip -4 addr | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v 127) && echo $TUN

#echo $user
#echo $host
#echo $OS
