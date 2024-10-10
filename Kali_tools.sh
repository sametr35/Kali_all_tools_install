#!/bin/bash

# Create a function that checks if the tool exist. if not it will install.
install_if_not_preinstalled() {
    local package=$1
    if command -v "$package" &>/dev/null; then
        echo -e "\e[32m$package is already installed.\e[0m"
    else
        echo "Installing $package..."
        sudo apt install -y "$package"
    fi
}

# Usage
install_if_not_preinstalled "locate"
install_if_not_preinstalled "crackmapexec"
install_if_not_preinstalled "gobuster"
install_if_not_preinstalled "theharvester"
install_if_not_preinstalled "bloodhound"
install_if_not_preinstalled "responder"
install_if_not_preinstalled "nikto"
install_if_not_preinstalled "john"
install_if_not_preinstalled "evil-winrm"
install_if_not_preinstalled "chisel"



echo "Wordlists downloading..."
mkdir wordlists && cd wordlists && curl -L https://raw.githubusercontent.com/rbsec/dnscan/master/subdomains-10000.txt -o subdomains-10000.txt && curl -L https://raw.githubusercontent.com/jeanphorn/wordlist/master/usernames.txt -o usernames.txt
echo "winpeas/Linpeas downloading..."
mkdir ../privesc && cd ../privesc && curl -L https://linpeas.sh/ -o linpeas.sh && curl -L https://raw.githubusercontent.com/carlospolop/PEASS-ng/releases/download/20230101/winPEASx64.exe -o winpeas.exe
echo "impacket-tools installing..."
cd .. && git clone https://github.com/fortra/impacket.git
mkdir revshells && cd revshells && curl -L https://raw.githubusercontent.com/pentestmonkey/php-reverse-shell/master/php-reverse-shell.php -o php-reverse-shell.php 
