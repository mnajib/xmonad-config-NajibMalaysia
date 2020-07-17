Config {
    -- appearance
    bgColor =      "#181715"
    , fgColor =    "#f3f3f1"
    -- font =         "-*-terminus-*-*-*-*-12-*-*-*-*-*-*-*"
    , position =     Top
    --, textOffset =   13
    , border =       TopB
    , borderColor =  "#181715"

    -- layout
    , sepChar =  "%"   -- delineator between plugin names and straight text
    , alignSep = "}{"  -- separator between left-right alignment
    , template = " %WaktuSolatPutrajaya%  <fc=#ff9933,#663300>%mpipe%</fc> "

    -- general behavior
    , lowerOnStart =     True    -- send to bottom of window stack on start
    , hideOnStart =      False   -- start with window unmapped (hidden)
    , allDesktops =      True    -- show on all desktops
    , overrideRedirect = True    -- set the Override Redirect flag (Xlib)
    , pickBroadest =     False   -- choose widest display (multi-monitor)
    , persistent =       True    -- enable/disable hiding (True = disabled)

    -- plugins
    , commands = [  Run CommandReader "~/.xmonad/waktusolat-putrajaya-hbar-v3" "WaktuSolatPutrajaya",
                    Run MarqueePipeReader "/tmp/${USER}-zikirpipe" (30, 3, "   +   ") "mpipe"
                 ]
}
