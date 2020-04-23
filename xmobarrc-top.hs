Config {

    -- appearance
    -- font =         "-*-terminus-*-*-*-*-12-*-*-*-*-*-*-*"
    bgColor =      "#181715"
    , fgColor =    "#646464"
    , position =     Top
    --, textOffset =   13
    , border =       TopB
    , borderColor =  "#181715"

    -- layout
    , sepChar =  "%"   -- delineator between plugin names and straight text
    , alignSep = "}{"  -- separator between left-right alignment
    --, template = " %StdinReader% }{ %eno1% * %wlp3s0b1% | %kbd% || %date% "
    --, template = " %StdinReader% }{ %eno1% | %memory% | %multicpu% | %kbd% | %date% "
    --, template = " %StdinReader% }{ %RJTT% %battery% %dynnetwork% %memory% %multicpu% %coretemp% %kbd% %date% "
    --, template = " %StdinReader% }{ %dynnetwork% %memory% %multicpu% %coretemp% %battery% %kbd% %date% "
    --, template = " Waktu Solat Putrajaya  %WaktuSolatPutrajaya%      <fc=#ff9933,#333333>%mpipe%</fc> "
    , template = " %WaktuSolatPutrajaya%      <fc=#ff9933,#663300>%mpipe%</fc> "

    -- general behavior
    , lowerOnStart =     True    -- send to bottom of window stack on start
    , hideOnStart =      False   -- start with window unmapped (hidden)
    , allDesktops =      True    -- show on all desktops
    , overrideRedirect = True    -- set the Override Redirect flag (Xlib)
    , pickBroadest =     False   -- choose widest display (multi-monitor)
    , persistent =       True    -- enable/disable hiding (True = disabled)

    -- plugins
    --   Numbers can be automatically colored according to their value. xmobar
    --   decides color based on a three-tier/two-cutoff system, controlled by
    --   command options:
    --     --Low sets the low cutoff
    --     --High sets the high cutoff
    --
    --     --low sets the color below --Low cutoff
    --     --normal sets the color between --Low and --High cutoffs
    --     --High sets the color above --High cutoff
    --
    --   The --template option controls how the plugin is displayed. Text
    --   color can be set by enclosing in <fc></fc> tags. For more details
    --   see http://projects.haskell.org/xmobar/#system-monitor-plugins.
    , commands = [

        -- StdinReader will read the output generated by xmonad (workspace info)
        Run StdinReader

        -- network activity monitor for ethernet
        --, Run Network "eno1" [
    , Run DynNetwork [
            --"--template" , "E:<tx>kB/s,<rx>kB/s"
            "--template" , "Tx:<tx>kB/s,Rx:<rx>kB/s"
            , "--Low"  , "1000"  -- units: kB/s
            , "--High"  , "5000"  -- units: kB/s
            , "--low"  , "#649FB6"
            , "--normal"  , "darkorange"
            , "--high"  , "darkred"
            ] 10

    , Run Memory [ "--template" , "Mem:<usedratio>%(<cache>M)" ] 10

    , Run MultiCpu [ "--template" , "Cpu:<total>%" ] 10


    -- cpu core temperature monitor
        , Run CoreTemp       [ "--template" , "Temp:<core0>°C,<core1>°C"
                             , "--Low"      , "70"        -- units: °C
                             , "--High"     , "80"        -- units: °C
                             , "--low"      , "darkgreen"
                             , "--normal"   , "darkorange"
                             , "--high"     , "darkred"
                             ] 50


    -- time and date indicator
    , Run Date "<fc=#ABABAB>%A %F %T</fc>" "date" 10

    -- keyboard layout indicator
    , Run Kbd [
        ("us(dvorak)" , "<fc=#181715,#58C5F1>DV</fc>")
        , ("us"                , "<fc=#181715,#58C5F1>US</fc>")
        ]

    -- battery monitor
    , Run Battery        [ "--template" , "Batt:<acstatus>"
                             , "--Low"      , "10"        -- units: %
                             , "--High"     , "80"        -- units: %
                             , "--low"      , "darkred"
                             , "--normal"   , "darkorange"
                             , "--high"     , "darkgreen"

                             , "--" -- battery specific options
                                       -- discharging status
                                       , "-o"   , "<left>% (<timeleft>)"
                                       -- AC "on" status
                                       , "-O"   , "<fc=#dAA520>Charging</fc>"
                                       -- charged status
                                       , "-i"   , "<fc=#006000>Charged</fc>"
                             ] 50

    --, Run Weather "RJTT" [ "--template", "<skyCondition>,<fc=#4682B4><tempC></fc>°C,<fc=#4682B4><rh></fc>%,<fc=#4682B4><pressure></fc>hPa" ] 36000

    --, Run CommandReader "~/bin/waktusolat-putrajaya-hbar" "WaktuSolatPutrajaya"
    , Run CommandReader "~/.xmonad/wsp" "WaktuSolatPutrajaya"

    -- Is this only read pipe file in /tmp/ ?
    --, Run MarqueePipeReader "~/.xmonad/zikir" (10, 7, "+") "mpipe"
    --, Run MarqueePipeReader "/tmp/${USER}-zikirpipe" (32, 3, "     +     ") "mpipe"
    , Run MarqueePipeReader "/tmp/${USER}-zikirpipe" (32, 3, "   +   ") "mpipe"
    --, Run MarqueePipeReader "~/.xmonad/zikirpipe" (10, 7, "+") "mpipe"
    --, Run PipeReader "~/.xmonad/zikirpipe" "mpipe"
    --, Run PipeReader "/tmp/zikirpipe" "mpipe"
    ]
}
