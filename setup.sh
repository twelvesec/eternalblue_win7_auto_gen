#!/bin/bash

#function packmang
packmang(){

	#Search for yum packet manager if exists
	which yum >/dev/null 2>&1
	if [ $? -eq 0 ]; then
		#found yum
		echo -e "\e[1;31m[!] Packet Manager found:\e[0m\n";
		echo -e "RED HAT LINUX (yum)\n"

		#indentify Linux Distro
		echo -e "\e[1;32m[!] Linux Distribuntion:\e[0m\n";		
		cat /etc/*-release | grep -i "name" | cut -d '"' -f 2 | head -n 3 | tail -n 1

		#set gloabal variable for packet manager
		export packvar=yum
		#debug
		#echo $packvar

	fi

	#Search for apt packet manager if exists
	which apt >/dev/null 2>&1
	if [ $? -eq 0 ]; then
		#found apt
		 echo -e "\e[1;31m[!] Packet Manager found:\e[0m\n";
		 echo -e "Debian/Ubuntu (apt)\n"

		 #indentify Linux Distro
		 echo -e "\e[1;32m[!] Linux DIstribution:\e[0m\n";
		 cat /etc/*-release | grep -i "name" | cut -d '"' -f 2 | head -n 3 | tail -n 1

		 #set gloabal variable for packet manager
		 export packvar=apt
		 #debug
		 #echo $packvar

	fi

}


#Checks root's privileges
echo -e "\e[1;34m[+] Do you have root's privileges?\e[0m\n"
if [[ $EUID -ne 0 ]]; then
	echo -e "\e[1;31m[!] You don't have root's privileges!\e[0m"
	echo -e "\e[1;31m[!] Plz use first sudo su command and then run this script!\e[0m\n"
	exit 1;
else
	echo -e "\e[1;32m[!] root's privileges OK!\e[0m\n"
	cd /root
fi

#Packet Manager
echo -e "\e[1;34m[+] Try to indentify packet manager:\e[0m\n";
#call function packmag
packmang

#install requirments
$packvar install python -y
$packvar install git -y
$packvar install nasm -y

echo -e "\n"
echo -e "\e[1;34m[+] Install msfvenom manually:\e[0m\n";
echo -e "-> https://github.com/rapid7/metasploit-framework\n"
