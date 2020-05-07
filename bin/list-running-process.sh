#!/run/current-system/sw/bin/env bash

printT(){
    local f1="\n---((( "
    local f2=" )))---"
    #echo -e "${f1}${1}${f2}"
    echo -n ""
}

#ps auxwww | egrep -i "zikir|xmobar|solat|trayer|LED|pasystray|volumeicon"

printT "xmobar"
pgrep -a xmobar | grep 'xmobar /home'

printT "waktusolat-putrajaya-hbar-v2"
pgrep -a bash | grep 'waktusolat-putrajaya-hbar-v2'

printT "keyboard-LED-status"
pgrep -a bash | grep '.xmonad/bin/keyboard-LED-status.sh'

printT "trayer"
pgrep -a trayer | grep 'trayer --edge top --align right'

printT "zikir marque"
pgrep -a bash | grep '/zikir'

printT "pasystray"
pgrep -a pasystray

printT "volumeicon"
pgrep -a volumeicon
