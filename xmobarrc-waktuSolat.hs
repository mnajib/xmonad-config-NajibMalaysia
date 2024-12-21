--

Config {
    bgColor =      "#181715"
    , fgColor =    "#f3f3f1"
    , font = "Monospace Bold 9" -- Refer https://codeberg.org/xmobar/xmobar/src/branch/master/doc/quick-start.org#text-mode
    --, position =     Top
    --, textOffset =   13
    , border =       TopB
    , borderColor =  "#181715"
    , sepChar =  "%"   -- delineator between plugin names and straight text
    , alignSep = "}{"  -- separator between left-right alignment
    --, template = " %WaktuSolatPutrajaya%  <fc=#ff9933,#663300>%mpipe%</fc> "
    --, template = "%WaktuSolat%  <fc=#ff9933,#663300>%mpipe%</fc> "
    , template = "%WaktuSolat% "
    --, template = "%WaktuSolatPutrajaya%  <fc=#ff9933,#663300>%mpipe%</fc> %_XMONAD_TRAYPAD%" -- XXX: TEST

    -- general behavior
    , lowerOnStart =     True    -- send to bottom of window stack on start
    , hideOnStart =      False   -- start with window unmapped (hidden)
    , allDesktops =      True    -- show on all desktops
    , overrideRedirect = True    -- set the Override Redirect flag (Xlib)
    , pickBroadest =     False   -- choose widest display (multi-monitor)
    , persistent =       True    -- enable/disable hiding (True = disabled)

    -- plugins
    --, commands = [  Run CommandReader "~/.xmonad/waktusolat-putrajaya-hbar-v3" "WaktuSolatPutrajaya",
    , commands = [

                    -- ------------------------------------------------------------------------------
                    -- TODO: Use XMonadLog instead of StdinReader:
                    -- XMonadLog is a more efficient way to communicate with xmobar, especially for complex configurations.
                    -- It avoids the potential issues associated with pipes.
                    -- ------------------------------------------------------------------------------
                    --Run CommandReader "~/.xmonad/waktusolat-hbar SGR01" "WaktuSolat"
                    Run CommandReader "~/.xmonad/bin/waktusolat-hbar SGR01" "WaktuSolat"
                    --Run PipeReader "Getting prayer times ...:/tmp/${USER}-prayer_reminder_fifo" "WaktuSolat"

                    --, Run MarqueePipeReader "/tmp/${USER}-zikirpipe" (30, 3, "   +   ") "mpipe"
                    --, Run MarqueePipeReader "/tmp/${USER}-zikirpipe" (20, 3, "   +   ") "mpipe"
                    --, Run XPropertyLog "_XMONAD_TRAYPAD" -- XXX: TEST
                 ]
}
