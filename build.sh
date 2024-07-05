#!/bin/env bash

#### OpenBangla Keyboard Installation Script by ####
####  Js Bro ( https://github.com/me-js-bro )   ####

# this is a clonned repository from ( https://github.com/asifakonjee )
# and the developer of this beautiful project is ( https://github.com/mominul )

# color defination
red="\e[1;31m"
green="\e[1;32m"
yellow="\e[1;33m"
blue="\e[1;34m"
magenta="\e[1;1;35m"
cyan="\e[1;36m"
orange="\x1b[38;5;214m"
end="\e[1;0m"

# initial texts
attention="[${orange} ATTENTION ${end}]"
action="[${green} ACTION ${end}]"
note="[${magenta} NOTE ${end}]"
done="[${cyan} DONE ${end}]"
ask="[${orange} QUESTION ${end}]"
error="[${red} ERROR ${end}]"

display_text() {
    cat << "EOF"
      ___                       ____                        _                _  __             _                             _ 
     / _ \  _ __    ___  _ __  | __ )   __ _  _ __    __ _ | |  __ _        | |/ / ___  _   _ | |__    ___    __ _  _ __  __| |
    | | | || '_ \  / _ \| '_ \ |  _ \  / _` || '_ \  / _` || | / _` | _____ | ' / / _ \| | | || '_ \  / _ \  / _` || '__|/ _` |
    | |_| || |_) ||  __/| | | || |_) || (_| || | | || (_| || || (_| ||_____|| . \|  __/| |_| || |_) || (_) || (_| || |  | (_| |
     \___/ | .__/  \___||_| |_||____/  \__,_||_| |_| \__, ||_| \__,_|       |_|\_\\___| \__, ||_.__/  \___/  \__,_||_|   \__,_|
           |_|                                       |___/                              |___/                                     
    
EOF
}

clear && display_text
printf " \n \n"


###------ Startup ------###

# finding the presend directory and log file
present_dir=`pwd`
cache_dir="$present_dir/.cache"
mkdir -p "$cache_dir"

# log directory
log_dir="$present_dir/Install-Logs"
log="$log_dir"/Install.log
mkdir -p "$log_dir"
if [[ ! -f "$log" ]]; then
    touch "$log"
fi


# Detect package manager
if command -v pacman &> /dev/null; then
    pkg="pacman"
elif command -v dnf &> /dev/null; then
    pkg="dnf"
elif command -v zypper &> /dev/null; then
    pkg="zypper"
elif command -v xbps-install &> /dev/null; then
    pkg="xbps-install"
elif command -v apt &> /dev/null; then
    pkg="apt"
else
    echo "No supported package manager found!"
    exit 1
fi


# Print message about installing necessary packages
printf "${attention} - Installing necessary packages using ${pkg} \n"

# Install required packages based on the detected package manager
case "$pkg" in
    pacman)
        sudo pacman -S --noconfirm base-devel rust cmake qt5-base libibus zstd fcitx5 fcitx5-configtool fcitx5-qt fcitx5-gtk git
        ;;
    dnf)
        sudo dnf install -y @buildsys-build rust cargo cmake qt5-qtdeclarative-devel ibus-devel libzstd-devel git fcitx5 fcitx5-configtool fcitx5-devel fcitx5-qt5
        ;;
    zypper)
        sudo zypper in -y libQt5Core-devel libQt5Widgets-devel libQt5Network-devel libzstd-devel libzstd1 cmake make ninja rust ibus-devel ibus clang gcc patterns-devel-base-devel_basis git fcitx5-devel fcitx5 fcitx5-configtool
        ;;
    xbps-install)
        sudo xbps-install -y base-devel make cmake rust cargo qt5-declarative-devel libzstd-devel qt5-devel cmake-devel git fcitx5 libfcitx5-devel fcitx5-configtool
        ;;
    apt)
        sudo apt install -y build-essential rustc cargo cmake libibus-1.0-dev qtbase5-dev qtbase5-dev-tools libzstd-dev fcitx5 fcitx5-config-qt git
        ;;
    *)
        echo "Unsupported package manager: $pkg"
        exit 1
        ;;
esac

sleep 1 && clear

printf "${action} - Now building ${orange}Openbangla Keyboard ${end}...\n"

if [[ -d "$cache_dir/Build-OpenBangla-Keyboard" ]]; then
    printf "${note} - Directory '${orange}Build-OpenBangla-Keyboard${end}' was located in the '${cache_dir}' directory. Removing it.\n" && sleep 1
    sudo rm -r "$cache_dir/Build-OpenBangla-Keyboard"
fi

git clone --recursive https://github.com/me-js-bro/Build-OpenBangla-Keyboard.git "$cache_dir/Build-OpenBangla-Keyboard" 2>&1 | tee -a "$log" || { printf "${error} - Sorry, could not clone Build-OpenBangla-Keyboard repository\n" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log"); exit 1; }

# Move into the cloned directory
cd "$cache_dir/Build-OpenBangla-Keyboard" || { printf "${error} - Unable to change directory\n" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log"); exit 1; }

# Create build directory
mkdir -p build 2>&1 | tee -a "$log" || { printf "${error} - Unable to create build directory\n" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log"); exit 1; }

cd build || { printf "${error} - Unable to change directory\n" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log"); exit 1; }

# Run CMake to configure the build
cmake .. 2>&1 | tee -a "$log" || { printf "${error} - CMake configuration failed\n" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log"); exit 1; }

# Build the project
make 2>&1 | tee -a "$log" || { printf "${error} - Build failed\n" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log"); exit 1; }

# Install the project
sudo make install 2>&1 | tee -a "$log" || { printf "${error} - Installation failed\n" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log"); exit 1; }

if [[ -d "/usr/share/openbangla-keyboard" ]]; then
    printf "${done} - OpenBangla-Keyboard was installed successfully!\n"
fi

sleep 1 && clear

printf "${attention} - Now installing some fonts (Bangla)\n" && sleep 1 && clear
if git clone --depth=1 https://github.com/me-js-bro/Bangla-Fonts.git "$cache_dir/Bangla-Fonts" 2>&1 | tee -a "$log"; then
    mkdir -p ~/.local/share/fonts
    cp -r "$cache_dir/Bangla-Fonts" ~/.local/share/fonts/
    sudo fc-cache -fv 2>&1 | tee -a "$log"
else
    printf "${error} - Sorry, could not install fonts.\n"
fi
