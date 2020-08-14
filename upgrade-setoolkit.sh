#!/bin/bash
## github hackjob by t.weeks@vt.edu     2020-08-14
## PROBLEM: setoolit it broken in kali 2020.02 (no apt repo fixes yet)
## FIX: gracefully install the latest setoolkit from git

STATUS=""
INSTSTATUS=""

echo "setookit upgrader for kali 2020.2..."

echo "Checking env..."
if [[ $UID != 0 ]];then
    echo "Not root user.."
    echo -e "\t\t[ABORT]"
    exit 1
fi

if [[ "$(lsb_release -r| tr -s [:blank:] " "|cut -f2 -d" ")" != "2020.2" ]];then
    echo "Not Kali v2020.2..."
    echo -e "\t\t[ABORT]"
    exit 1
fi

echo "Setting up..."
sudo apt-get update -y > /dev/null 2>&1
sudo apt-get install aptitude -y > /dev/null 2>&1
echo "Detecting setookit version..."
VER=$(aptitude show set|grep ^Ver|cut -f2 -d" ")
SETPATH="$(which setoolkit)"
if [[ ("$VER" == "8.0.3-0kali1") && ("$SETPATH" == "/usr/bin/setoolkit" ) ]];then 
    echo "Old version detected..."
    echo "Upgrading path-priority new version from git (leaving old package installed)"
    STATUS=OLD
else
    if [[ "$SETPATH" == "/usr/local/bin/setoolkit" ]]; then
        echo "New version (path) detected..."
        STATUS=NEW
    fi
fi

if [[ $STATUS == NEW ]]; then
    echo "..not proceeding with install..."
    echo -e "\t\t[ABORT]"
    exit 1
else
    echo "..proceeding with git install..."
fi


# Forced Upgrade:
CURDIR="$(pwd)"
mkdir -p /root/tmp && cd /root/tmp && \
wget https://github.com/trustedsec/social-engineer-toolkit/archive/master.zip >/dev/null 2>&1 && \
echo ..downloaded.. && \
unzip master.zip >/dev/null 2>&1 && \
cd social-engineer-toolkit-master/ >/dev/null 2>&1 && \
aptitude install python3-pip -y >/dev/null 2>&1 && \
pip3 install -r requirements.txt >/dev/null 2>&1 && \
python setup.py > /dev/null 2>&1 
INSTSTATUS=?0
sync
NEWPATH="$(which setoolkit)"

if [[ $INSTSTATUS != 0 ]]; then
    echo "..exit code of install = $INSTSTATUS "
    echo -e "\t\t[WARN]"
fi

if [[ "$NEWPATH" == /usr/local/bin/setoolkit ]]; then
    echo "New Path = $(which setoolkit)"
    echo -e "\t\t[OK]"
else
    echo -e "\t\t[FAILED]"
    exit 1
fi

## Cleanup
cd $CURDIR
/bin/rm -rf /root/tmp

