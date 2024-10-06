#!/bin/sh

E2PID=`pidof enigma2`

if  [ -z "$E2PID" ]; then
    PYTHON3="1"
    PYTHON2="1"
else
    PYTHON3=`cat /proc/$E2PID/maps | grep -c /libpython3`
    PYTHON2=`cat /proc/$E2PID/maps | grep -c /libpython2`
fi

python="python"

if [ "$PYTHON3" -gt "0" ]; then
    PYTHON_VERSIONS="3.8 3.9 3.10 3.11 3.12 3"
    for i in $PYTHON_VERSIONS; 
    do
        item="/usr/bin/python$i"
        if [ -f "$item" ]; then
            python="$item"
            break;
        fi
    done
fi

if [ "$PYTHON2" -gt "0" ]; then
    PYTHON_VERSIONS="2.7 2.6 2"
    for i in $PYTHON_VERSIONS; 
    do
        item="/usr/bin/python$i"
        if [ -f "$item" ]; then
            python="$item"
            break;
        fi
    done
fi

echo "python location=$python, enigma2 pid=$E2PID, PYTHON3=$PYTHON3, PYTHON2=$PYTHON2"

SETTINGS_FILE="/etc/enigma2/settings"
ICONS_PACK="100"
if grep -q "iptvplayer.IconsSize=100" "$SETTINGS_FILE"; then
    ICONS_PACK="100"
elif grep -q "iptvplayer.IconsSize=120" "$SETTINGS_FILE"; then
    ICONS_PACK="120"
elif grep -q "iptvplayer.IconsSize=135" "$SETTINGS_FILE"; then
    ICONS_PACK="135"
fi

set -e


cd /tmp
rm -f e2iplayer_installer.py
wget http://e2iplayer.github.io/www/nt-install.py -O e2iplayer_installer.py
$python -O e2iplayer_installer.py "$1" "$2" $ICONS_PACK 
rm -f e2iplayer_installer.py
