#!/usr/bin/env bash

#case $HOSTNAME in
  #khadijah)
  #  echo "Configuring screensaver/DPMS settings for $HOSTNAME"
  #  xset s blank
  #  xset s 300
  #  # Need to enable DPMS for screen blaking work on multi-monitors
  #  xset dpms 300 300 300               # DPMS value for 'standby', 'suspend', and 'off' session idle time
  #;;
#  *)
    echo "Configuring screensaver/DPMS settings"
    #xset -dpms                         # disable DPMS
    xset s on
    xset s blank                        # enabe screen blanking
    #xset s 300                         # screen will blank after x-seconds of idle session
    xset s 300 0                        # screen will blank after x-seconds of idle session

    # XXX: testing
    #xset +dpms
    xset dpms 300 300 300               # DPMS value for 'standby', 'suspend', and 'off' session idle time
#  ;;
#esac

#echo ""
#xset q
#sleep 1; xset s dmps force off
#sleep 1; xset s dmps force standby
#sleep 1; xset s dmps force suspend

#xset s dmps force on

# To disable DPMS
#xset -dpms
#xset dpms 0 0 0
# To set screen saver to noblank, but this is NOT for disable screensaver
#xset s noblank
#xset s off

#xrandr --output VGA-1 -off
#xrandr --output VGA-1 --brightness 0.1

#$setterm --setterm --blank [0-60|force|poke]
#$ setterm --powersave [on|vsync|hsync|powerdown|off]
#$ setterm --powerdown [0-60]
