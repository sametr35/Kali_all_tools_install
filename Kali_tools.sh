#!/bin/bash

# output colors.
GREEN='\033[0;32m'
RED='\033[0;31m'
No_Color='\033[0m' 


declare -A INSTALL_STATUS

# Check if the command is pre-installed.
check_command() {
  if ! command -v "$1" &> /dev/null; then
    return 1
  else
    echo -e "${GREEN}[+] $1 is already installed${No_Color}"
    return 0
  fi
}

# Check the errors. In case errors continue.
handle_error() {
  echo -e "${RED}[!] Error occurred during: $1. Continuing...${No_Color}"
  INSTALL_STATUS["$1"]="Failed"
}

# Add Installed tools as environment variables.
add_to_bashrc() {
  VAR_NAME=$1
  VAR_VALUE=$2

  if ! grep -q "$VAR_NAME" "$HOME/.bashrc"; then
    echo "export $VAR_NAME=\"$VAR_VALUE\"" >> "$HOME/.bashrc"
    export $VAR_NAME="$VAR_VALUE"
    echo -e "${GREEN}[+] Added $VAR_NAME to .bashrc${No_Color}"
  else
    echo -e "${GREEN}[+] $VAR_NAME already set in .bashrc${No_Color}"
  fi
}

# FeroxBuster
install_feroxbuster() {
  if ! check_command feroxbuster; then
    echo "[*] Installing FeroxBuster..."
    wget -qO - https://github.com/epi052/feroxbuster/releases/latest/download/feroxbuster_amd64.deb || handle_error "FeroxBuster"
    sudo dpkg -i feroxbuster_amd64.deb || handle_error "FeroxBuster"
    INSTALL_STATUS["FeroxBuster"]="Success"
  else
    INSTALL_STATUS["FeroxBuster"]="Already installed"
  fi
}

# LinPEAS/WinPEAS
install_peas() {
  if [ ! -d "$HOME/privilege-escalation-awesome-scripts-suite" ]; then
    echo "[*] Installing LinPEAS/WinPEAS..."
    git clone https://github.com/carlospolop/PEASS-ng.git "$HOME/privilege-escalation-awesome-scripts-suite" || handle_error "LinPEAS/WinPEAS"
    add_to_bashrc "PEASS_DIR" "$HOME/privilege-escalation-awesome-scripts-suite"
    INSTALL_STATUS["LinPEAS/WinPEAS"]="Success"
  else
    INSTALL_STATUS["LinPEAS/WinPEAS"]="Already installed"
  fi
}

# BloodHound
install_bloodhound() {
  if ! check_command bloodhound; then
    echo "[*] Installing BloodHound..."
    sudo apt install -y bloodhound || handle_error "BloodHound"
    INSTALL_STATUS["BloodHound"]="Success"
  else
    INSTALL_STATUS["BloodHound"]="Already installed"
  fi
}

#  Impacket
install_impacket() {
  if ! check_command impacket-smbclient; then
    echo "[*] Installing Impacket..."
    sudo apt install -y python3-impacket || handle_error "Impacket"
    add_to_bashrc "IMPACKET_DIR" "/usr/share/doc/python3-impacket/examples"
    INSTALL_STATUS["Impacket"]="Success"
  else
    INSTALL_STATUS["Impacket"]="Already installed"
  fi
}

#  CrackMapExec
install_cme() {
  if ! check_command crackmapexec; then
    echo "[*] Installing CrackMapExec..."
    sudo apt install -y crackmapexec || handle_error "CrackMapExec"
    INSTALL_STATUS["CrackMapExec"]="Success"
  else
    INSTALL_STATUS["CrackMapExec"]="Already installed"
  fi
}

#  Evil-WinRM
install_evil_winrm() {
  if ! check_command evil-winrm; then
    echo "[*] Installing Evil-WinRM..."
    sudo gem install evil-winrm || handle_error "Evil-WinRM"
    INSTALL_STATUS["Evil-WinRM"]="Success"
  else
    INSTALL_STATUS["Evil-WinRM"]="Already installed"
  fi
}

#  SecLists
install_seclists() {
  if [ ! -d "/usr/share/seclists" ]; then
    echo "[*] Installing SecLists..."
    sudo apt install -y seclists || handle_error "SecLists"
    add_to_bashrc "SECLISTS_DIR" "/usr/share/seclists"
    INSTALL_STATUS["SecLists"]="Success"
  else
    INSTALL_STATUS["SecLists"]="Already installed"
  fi
}

#  Chisel
install_chisel() {
  if ! check_command chisel; then
    echo "[*] Installing Chisel..."
    wget https://github.com/jpillora/chisel/releases/latest/download/chisel_1.7.7_linux_amd64.gz || handle_error "Chisel"
    gunzip chisel_1.7.7_linux_amd64.gz || handle_error "Chisel"
    chmod +x chisel_1.7.7_linux_amd64
    sudo mv chisel_1.7.7_linux_amd64 /usr/local/bin/chisel || handle_error "Chisel"
    INSTALL_STATUS["Chisel"]="Success"
  else
    INSTALL_STATUS["Chisel"]="Already installed"
  fi
}

#  EternalBlue-Exploits
install_eternalblue() {
  if [ ! -d "$HOME/eternalblue-exploits" ]; then
    echo "[*] Downloading EternalBlue exploits..."
    git clone https://github.com/worawit/MS17-010.git "$HOME/eternalblue-exploits" || handle_error "EternalBlue exploits"
    add_to_bashrc "ETERNALBLUE_DIR" "$HOME/eternalblue-exploits"
    INSTALL_STATUS["EternalBlue Exploits"]="Success"
  else
    INSTALL_STATUS["EternalBlue Exploits"]="Already installed"
  fi
}

#  Pspy
install_pspy() {
  if ! check_command pspy; then
    echo "[*] Installing Pspy..."
    wget https://github.com/DominicBreuker/pspy/releases/latest/download/pspy64 || handle_error "Pspy"
    chmod +x pspy64
    sudo mv pspy64 /usr/local/bin/pspy || handle_error "Pspy"
    INSTALL_STATUS["Pspy"]="Success"
  else
    INSTALL_STATUS["Pspy"]="Already installed"
  fi
}

# Apply environment variables
apply_env() {
  echo "[*] Applying environment variables..."
  source "$HOME/.bashrc" || handle_error "sourcing .bashrc"
}

# Run installation functions
install_feroxbuster
install_peas
install_bloodhound
install_impacket
install_cme
install_evil_winrm
install_seclists
install_chisel
install_eternalblue
install_pspy

# Apply environment variables
apply_env

# Sum of installation status
echo -e "${GREEN}[+] Installation Summary:${No_Color}"
for tool in "${!INSTALL_STATUS[@]}"; do
  if [ "${INSTALL_STATUS[$tool]}" == "Success" ]; then
    echo -e "${GREEN}[*] $tool: ${INSTALL_STATUS[$tool]}${No_Color}"
  elif [ "${INSTALL_STATUS[$tool]}" == "Already installed" ]; then
    echo -e "${GREEN}[*] $tool: ${INSTALL_STATUS[$tool]}${No_Color}"
  else
    echo -e "${RED}[*] $tool: ${INSTALL_STATUS[$tool]}${No_Color}"
  fi
done
