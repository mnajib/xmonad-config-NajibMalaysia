Config {
    -- appearance
    bgColor =      "#181715"
    , fgColor =      "#646464"
    , position =     Bottom
    -- font =         "-*-terminus-*-*-*-*-12-*-*-*-*-*-*-*"
    -- font =         "-*-*-*-*-*-*-12-*-*-*-*-*-*-*"
    --, font = "Monospace Extra-Light Thin 8" -- Need this change because xmobar now use pango insteed of xft
    , font = "Monospace Thin Thin 8" -- Need this change because xmobar now use pango insteed of xft
    --, textOffset =   13
    , border =       TopB
    , borderColor =  "#181715"

    -- layout
    , sepChar =  "%"   -- delineator between plugin names and straight text
    , alignSep = "}{"  -- separator between left-right alignment
    --, template = " %StdinReader% }{ %dynnetwork% %memory% %multicpu% %coretemp% %battery% %keylock% %kbd% %date% "
    --, template = " %StdinReader% }{ %NetConnStatus% %dynnetwork% %memory% %multicpu% %coretemp% %battery% %keylock% %kbd% %date% "
    --, template = " %StdinReader% }{ %NetConnStatus% %dynnetwork% %diskio% %memory% %multicpu% %coretemp% %battery% %keylock% %kbd% %date% "
    --, template = " %StdinReader% }{ %NetConnStatus% %dynnetwork% %diskio%%memory% %multicpu% %coretemp% %default:Master%%battery% %keylock% %kbd% %date% "
    --, template = " %StdinReader% }{ %NetConnStatus% %dynnetwork% %diskio% %memory% %multicpu% %coretemp% %default:Master%%battery% %keylock% %kbd% %date% "
    --, template = " %StdinReader% }{ %NetConnStatus% %dynnetwork% %memory% %multicpu% %coretemp% %default:Master%%battery% %keylock% %kbd% %date% "
    , template = " %StdinReader% }{ %NetConnStatus% %memory% %multicpu% %coretemp% %default:Master%%battery% %keylock% %kbd% %date% "
    --, template = " %StdinReader% }{ %dynnetwork% %memory% %multicpu% %coretemp% %default:Master%%battery% %keylock% %kbd% %date% "
    --, template = " %StdinReader% }{ %dynnetwork% %memory% %multicpu% %coretemp% %battery% %keylock% %date% "
    --, template = " %StdinReader% }{ %dynnetwork% %memory% %multicpu% %coretemp% %battery% %kbd% %date% "

    -- general behavior
    , lowerOnStart =     False    -- send to bottom of window stack on start
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
--      , Run DynNetwork [
--          --, "-S", "True"

--          "--template" , "<dev>:Rx<rx>kb/s,Tx<tx>kb/s"
--          --"--template" , "<dev>:Rx<rx>kbps,Tx<tx>kbps"

--          --, "--Low"    ,  "300000000"     -- in B/s (100% dari 300Mb/s; kelajuan internet sekarang ialah 300Mbps ???)
--          --, "--High"   , "1000000000"     -- in B/s (100% dari 1Gb/s; kelajuan ethernet/LAN network kita ialah 1GBps)
--          , "--Low"      ,  "240000000"     -- in B/s (80% dari 300Mb/s; kelajuan internet sekarang ialah 300Mbps ???)
--          , "--High"     ,  "800000000"     -- in B/s (80% dari 1Gb/s; kelajuan ethernet/LAN network kita ialah 1GBps)

--          , "--low"      , "#649FB6"        -- color below '--low' cutoff
--          , "--normal"   , "darkorange"     -- color between '--low' and '--high' cutoff
--          , "--high"     , "darkred"        -- color above '--high' cutoff

--          ] 10
    --
    -- Note:
    --
    --     1 Giga bits per second
    --     = 1 Gbits/s
    --     = 1,000 mega bits per second
    --     = 1,000 Mbits/s
    --     = 1,000,000 kilo bits per second
    --     = 1,000,000,000 bits per second
    --
    -- 1 Mbps = 1000 kbps
            --
            -- Internet Download speed = 300 Mbps
            --                         = 300 * 1000 kbps
            --                         = 300 000 kbps
            --
            -- 80% from internet download speed = (80 / 100) * 300 000 kbps
            --                  = 240 000 kpbs
            --                  = 240 Mbps
            --
            -- Lan speed = 1 Gbps
            --           = 1000 Mbps
            --           = 1 000 000 kbps
            --
            -- 80% from LAN speed = (80/100) * 1000 Mbps
            --                    = 800 Mbps
            --                  = 800 000 kbps

        --, Run Memory [ "--template" , "Mem:<usedratio>%(<cache>M)" ] 10
        , Run Memory [ "--template" , "Mem:<usedratio>%" ] 10

        --, Run DiskIO [("sda", "<read><write>")] [] 10
        --, Run DiskIO [
        --  --("sda", "sdaIO:R<read>,W<write>")
        --  --, ("sdb", "sdbIO:R<read>,W<write>")
        --  ("/", "/:R<read>,W<write>")
        --     ] [] 10
        --, Run DiskIO [("sda", "DiskIO:<total>")] [] 10

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
        , Run Date "<fc=#ffff00>%A</fc> <fc=#00ff00>%F</fc> <fc=#00ffff>%T</fc>" "date" 10

        , Run Volume "default" "Master" [ "--template", "Vol:<volume>%<status>" ] 10

        -- keyboard layout indicator
        , Run Kbd [
                    ("us(dvorak)"           , "<fc=#181715,#58C5F1> DV </fc>"),
                    ("us"                   , "<fc=#181715,#58C5F1> US </fc>"),
                    ("ara"                  , "<fc=#181715,#58C5F1>ARA </fc>"),
                    ("my"                   , "<fc=#181715,#58C5F1> MY </fc>"),
                    ("msa"                  , "<fc=#181715,#58C5F1>MSA </fc>"),
                    ("msa(najib)"           , "<fc=#181715,#58C5F1>MSA2</fc>"),
                    ("msa(macnajib)"        , "<fc=#181715,#58C5F1>MSA3</fc>")
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

        -- keyboard LED status
        , Run CommandReader "~/.xmonad/bin/keyboard-LED-status.sh" "keylock"

        -- Network connection status
        , Run CommandReader "~/.xmonad/netconnstatus.sh" "NetConnStatus"

        --, Run Weather "RJTT" [ "--template", "<skyCondition>,<fc=#4682B4><tempC></fc>°C,<fc=#4682B4><rh></fc>%,<fc=#4682B4><pressure></fc>hPa" ] 36000
    ]
}
