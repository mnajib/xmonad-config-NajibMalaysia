-- {-# OPTIONS_GHC -Wno-deprecations #-}

-- Copyright (c) 2024 xmonad-config-NajibMalaysia
-- Licensed under the BSD 3-Clause License. See LICENSE file for details.

-- ----------------------------------------------
-- Ref:
--   https://www.reddit.com/r/xmonad/comments/ndww5/dual_screens_multi_monitors_tips_and_tricks/
--   https://hackage.haskell.org/package/xmonad-contrib-0.13/docs/XMonad-Layout-IndependentScreens.html
-- ----------------------------------------------

import XMonad
-- import Data.Monoid -- mapped
import System.Exit

import qualified XMonad.StackSet as W
import qualified Data.Map as M -- fromList

import XMonad.Actions.Volume
import XMonad.Actions.CycleWindows      -- now working like what I want
--import XMonad.Actions.CycleWS -- try to implement custom "zoom tiling window"
--import XMonad.Actions.MostRecentlyUsed (mostRecentlyUsed) -- to toggle focus between last/recent two focused windows

import XMonad.Hooks.DynamicLog
-- import XMonad.Hooks.StatusBar.PP

import XMonad.Hooks.ManageDocks
-- import XMonad.Hooks.Rescreen
-- import XMonad.Util.XUtils (fi)
-- import Graphics.X11.Xlib
-- import Graphics.X11.Xlib.Extras
import XMonad.Util.Run (spawnPipe, hPutStrLn) -- hPutStrLn
import XMonad.Util.SpawnOnce
import XMonad.Util.EZConfig(additionalKeys, removeKeys) --mkKeymap
-- import XMonad.Util.ActionCycle          -- I try to use this to keybinding for toggle focus between last two window
import qualified XMonad.Util.Hacks as Hacks
import System.IO (Handle) -- , hPutStrLn)
--import System.Process (readProcess)
import System.Posix.Unistd (getSystemID, nodeName)
--import XMonad.Util.ExtensibleState as XS

import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName

import XMonad.Layout.Fullscreen -- (fullscreenFull)
import XMonad.Layout.NoBorders
-- import XMonad.Layout.Spiral
import XMonad.Layout.Grid
import XMonad.Layout.Tabbed
-- import XMonad.Layout.ThreeColumns
import XMonad.Layout.TwoPane
import XMonad.Layout.Combo -- combineTwo
import XMonad.Layout.WindowNavigation
import XMonad.Layout.Renamed
import XMonad.Layout.LayoutCombinators hiding ( (|||) )
--import XMonad.Layout.SubLayouts
import XMonad.Layout.ToggleLayouts
import XMonad.Layout.Column
import XMonad.Layout.Maximize -- (maximize) --, RestoreMaximized)
-- import XMonad.Layout.Decoration (ModifiedLayout)

--import XMonad.Layout.Groups
-- import XMonad.Layout.Groups.Helpers
import XMonad.Layout.Groups.Examples

-- import qualified XMonad.Layout.IndependentScreens as LIS

-- import XMonad.Config.Xfce
import XMonad.Hooks.EwmhDesktops

import Graphics.X11.ExtraTypes.XF86

import Control.Concurrent (threadDelay)
--threadDelay 1000000 --sleep for a million microseconds, or one second

-- import Control.Monad (forM_, when)


-- ----------------------------------------------------------------------------

-- XXX:

---- Custom State for Maximize Tracking
--data MaximizeState = MaximizeState
--    { isMaximized :: Bool
--    , lastWindow :: Maybe Window
--    }
--    deriving (Typeable, Read, Show)
--
---- Initialize the state
--instance ExtensionClass MaximizeState where
--    initialValue = MaximizeState
--        { isMaximized = False
--        , lastWindow = Nothing
--        }
--
---- Color Definitions
--blueColor, redColor :: String
---- blueColor = "#0000FF"
--blueColor = "#FF00FF"
--redColor = "#FF0000"
--
---- Color Initialization for X11
--initColorPixel :: Display -> String -> IO Pixel
--initColorPixel d colorString = do
--    let colormap = defaultColormap d (defaultScreen d)
--    (color, _) <- allocNamedColor d colormap colorString
--    return $ color_pixel color
--
---- Window Border Color Setting
--setWindowBorderColor :: Window -> String -> X ()
--setWindowBorderColor win color = do
--    d <- asks display
--    pixel <- io $ initColorPixel d color
--    io $ setWindowBorder d win pixel
--    -- io $ setWindowBorderWidth d win 2 -- 1-pixels window border width?
--    io $ setWindowBorderWidth d win 1 -- 2-pixels window border width?
--
---- Toggle Maximize with Border Color
--toggleMaximizeWithBorder :: X ()
--toggleMaximizeWithBorder = do
--    -- Get current focused window
--    maybeWindow <- XMonad.gets (W.peek . windowset)
--
--    case maybeWindow of
--        Nothing -> return ()
--        Just win -> do
--            -- Retrieve current state
--            currentState <- XS.get
--
--            -- Determine new state and color
--            let newMaximizedState = not (isMaximized currentState)
--                newColor = if newMaximizedState then blueColor else redColor
--
--            -- Update window border color
--            -- setWindowBorderColor win newColor
--
--            -- Send maximize/restore message
--            withFocused (sendMessage . maximizeRestore)
--
--            -- -------------------------------------------
--
--            -- Retrieve current state
--            -- currentState2 <- XS.get
--
--            -- Determine new state and color
--            -- let newMaximizedState2 = isMaximized currentState2
--            --     newColor2 = if newMaximizedState2 then blueColor else redColor
--
--            -- Update window border color
--            setWindowBorderColor win newColor
--            -- setWindowBorderColor win newColor2
--
--            -- -------------------------------------------
--
--            -- Update state
--            XS.put $ MaximizeState
--                { isMaximized = newMaximizedState
--                -- { isMaximized = newMaximizedState2
--                , lastWindow = Just win
--                }
--



-- ----------------------------------------------------------------------------



-- TODO: Need different xmobar settings for different host. One way to achieve that would be to write a function that will create a new .xmobarrc file for your given host.
--import Network.HostName
--createXmobarrc :: String -> IO ()
--createXmobarrc hostname = undefined -- Write your logic
--
--main = do
-- hostname <- getHostName
-- createXmobarrc hostname -- produce appropriate .xmobarrc file for a given host
-- -- other xmonad stuff follows here

-- myTerminal      = "urxvt +sb -bg black -fg white -uc -bc" -- my current urxvt give better clear font with smaller font size, and also color theme
-- myTerminal      = "terminology" -- my current urxvt give better clear font with smaller font size, and also color theme
-- myTerminal   = "termonad"
myTerminal = "alacritty"
-- myTerminal = "termite" -- Can zoom; but my current termite font and color not better than urxvt

myEditor = "emacsclient -c"

-- myXmobarrc = "~/.xmonad/xmobarrc-main-oldCPU.hs"

--_XMONAD_TRAYPAD(UTF8_STRING) = "<hspace=53/>"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
myBorderWidth   = 1
-- Border colors for unfocused and focused windows, respectively.
myNormalBorderColor  = "#dddddd"
myFocusedBorderColor = "#ff0000"

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--myModMask       = mod1Mask
myModMask       = mod4Mask


-- -----------------------------------------------
-- TODO:
--
--togglevga = do
--  screencount <- LIS.countScreens
--  if screencount > 1
--   then spawn "xrandr --output VGA1 --off"
--   else spawn "xrandr --output VGA1 --auto --right-of LVDS1"
--
--myScreens :: Int
--myScreens = 2  -- Number of X screens
--
--myWorkspaces :: [WorkspaceId]
--myWorkspaces = withScreens myScreens ["1", "2", "3", "4", "5"]
--myWorkspaces = withScreens myScreens ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
-- -----------------------------------------------



-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
-- A tagging example:
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]

-- Generate screen-specific workspaces
--myWorkspaces :: [String]
--myWorkspaces = [show i ++ "_" ++ show sid | sid <- [0..1], i <- [1..9]]


------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
-- override some of the default keybindings and add my own
-- myKeys =
--    [ ((mod4Mask .|. shiftMask, xK_w), spawn "feh --bg-fill --randomize ~/Wallpapers/*")                                                                                                -- change wallpaper
--    --, ((mod4Mask .|. shiftMask, xK_q),                  kill)                                                                                                                         -- close window with mod-shift-Q (default is mod-shift-C)
--    --, ((mod4Mask .|. shiftMask, xK_e),                  io (exitWith ExitSuccess))                                                                                                    -- close xmonad with mod-shift-E (default is mod-shift-Q)
--    , ((mod4Mask .|. shiftMask, xK_r),                    spawn "if type xmonad; then xmonad --recompile && xmonad --restart; else xmessage xmonad not in \\$PATH: \"$PATH\"; fi")      -- %! Recompile and restart xmonad
--    , ((mod4Mask,               xK_x),                    spawn "scrot '%Y-%m-%d-%H%M%S.png' -b -u -e 'mv $f ~/Pictures/Screenshots/'" )                                                --
--    , ((mod4Mask .|. shiftMask, xK_x),                    spawn "scrot '%Y-%m-%d-%H%M%S-full.png' -b -e 'mv $f ~/Pictures/Screenshots/'" )                                              --
--    --, ((mod4Mask .|. shiftMask, xK_l),                  spawn "xlock -mode random" )                                                                                                  --
--    , ((mod4Mask .|. shiftMask, xK_l),                    spawn "xlock -mode forest" )                                                                                                  --
--    --, ((mod4Mask .|. shiftMask, xK_l),                  spawn "xscreensaver-command --lock" )                                                                                         --
--    ]
--
-- To get list of mod keys:
--    xmodmap
--
-- keyBindings conf = let m = modMask conf in fromList $
--myKeys :: XConfig l -> [(String, X ())]
--myKeys conf = [
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $ [

    -- launch a terminal -------------------------------------------------------
    ((modm .|. shiftMask,                                   xK_Return),         spawn $ XMonad.terminal conf)

    , ((modm, xK_c), spawn "emacsclient -c") -- super+c

    -- launch dmenu
    --, ((modm,                                             xK_p),              spawn "dmenu_run")

    -- launch gmrun
    --, ((modm .|. shiftMask,                               xK_p),              spawn "gmrun")
    --, ((modm .|. shiftMask,                               xK_p),              spawn "")

    -- launch rofi -------------------------------------------------------------
    , ((modm,                                               xK_p),              spawn "rofi -font \"hack 10\" -modes \"window,calc,filebrowser,keys,combi\" -combi-modes \"drun,run\" -font \"hack 10\" -show combi -icon-theme \"Papirus\" -show-icons")
    , ((modm .|. shiftMask,                                 xK_p),              spawn "rofi -font \"hack 10\" -modes \"drun,run,window,windowcd,calc,ssh,filebrowser,file-browser-extended,keys,emoji,combi\" -combi-modes \"drun,run\" -font \"hack 10\" -show combi -icon-theme \"Papirus\" -show-icons")

    -- toggle enable/disable touchpad ------------------------------------------
    , ((modm, xK_F3 ), spawn $ "~/.xmonad/bin/toggleTouchpadEnableDisable-Thinkpad.sh")

    -- keyboard layout ---------------------------------------------------------
    , ((modm,                                               xK_F4),             spawn $ "setxkbmap -layout us -variant dvorak")
    , ((modm,                                               xK_F5),             spawn $ "setxkbmap -layout us")
    , ((modm,                                               xK_F6),             spawn $ "setxkbmap -layout msa -variant najib")
    --, ((modm,                                             xK_F7 ),            spawn $ "setxkbmap -layout us,us,msa -variant dvorak,,najib -option \"grp:shift_caps_toggle,grp:alt_shift_toggle\"")

    -- audio-out (speaker) Volume control --------------------------------------
    , ((modm,                                               xK_F10),            lowerVolume 1 >> return () )
    , ((modm,                                               xK_F11),            raiseVolume 1 >> return () )
    , ((modm,                                               xK_F12),            toggleMute >> return () )
    -- audio-in (microphone) volume control ------------------------------------
    , ((modm .|. shiftMask,                                 xK_F10),            spawn $ "pactl -- set-source-volume 2 -4" )
    , ((modm .|. shiftMask,                                 xK_F11),            spawn $ "pactl -- set-source-volume 2 +4" )
    , ((modm .|. shiftMask,                                 xK_F12),            spawn $ "pactl -- set-source-mute 1 toggle" )
    --
    , ((0, xF86XK_AudioLowerVolume),                                            lowerVolume 4 >> return () )
    , ((0, xF86XK_AudioRaiseVolume),                                            raiseVolume 4 >> return () )
    , ((0, xF86XK_AudioMute),                                                   toggleMute >> return () ) -- spawn $ "pactl -- set-sink-mute 1 toggle"
    , ((0, xF86XK_AudioMicMute),                                                spawn $ "pactl -- set-source-mute 1 toggle" )

    -- XF86MonBrightnessUp
    -- XF86MonBrightnessDown

    -- clipcat-menu: Clipboard Manager -----------------------------------------
    --, ((modm,                                               xK_c),              spawn "clipcat-menu")

    -- Toggle maximize focused window using "Super"+"\" key combo. -------------
    , ((modm, xK_backslash), withFocused (sendMessage . maximizeRestore))
    --, ((modm, xK_backslash), toggleMaximizeRestore)
    --, ((modm, xK_backslash), toggleMaximizeWithBorder) -- XXX:

    -- close focused window ----------------------------------------------------
    , ((modm .|. shiftMask,                                 xK_c),              kill)

     -- Rotate through the available layout algorithms -------------------------
    , ((modm,                                               xK_space),          sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default ------------------
    , ((modm .|. shiftMask,                                 xK_space),          setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size -------------------------------
    , ((modm,                                               xK_n),              refresh)

    -- Change (the currently focus) window title -------------------------------
    , ( (modm .|. mod1Mask, xK_t), spawn "~/.xmonad/bin/change_window_title.sh" ) -- <super><alt><t>

    -------------------------------------------------------
    -- Window focus
    -------------------------------------------------------

    -- Move focus to the next window
    , ((modm,                                               xK_Tab),            windows W.focusDown)

    -- Move focus to the next window
    --, ((modm,                                               xK_j),              windows W.focusDown)

    -- Move focus to the previous window
    --, ((modm,                                               xK_k),              windows W.focusUp)
    , ((modm .|. shiftMask,                                 xK_Tab),            windows W.focusUp)

    -- Move focus to the master window
    , ((modm,                                               xK_m),              windows W.focusMaster)

    -- TODO: Toggle focus between two recent windows. slow???
    --, ((modm .|. mod1Mask,                                xK_Tab),            cycleRecentWindows [xK_Super_L] xK_j xK_k)
    -- Status: OK, but between next and current window
    --, ((modm .|. mod1Mask,                                  xK_Tab),            cycleAction "toggleTwoRecentWindows" [windows W.focusDown, windows W.focusUp])
    -- Status: Working, should toggle between two last focus windows. But need to relase buttons after each time apply
    --, ((modm .|. mod1Mask,                                  xK_Tab),            mostRecentlyUsed [xK_Alt_L, xK_Alt_R] xK_Tab)


    -------------------------------------------------------
    -- Window swap
    -------------------------------------------------------
    -- Swap the focused window and the master window
    --, ((modm,                                             xK_Return),         windows W.swapMaster)
    , ((modm .|. shiftMask,                                 xK_m),              windows W.swapMaster)

    -- Swap the focused window with the next window
    --, ((modm .|. shiftMask,                                 xK_j),              windows W.swapDown)
    , ((modm .|. shiftMask,                                 xK_Page_Down),      windows W.swapDown)

    -- Swap the focused window with the previous window
    --, ((modm .|. shiftMask,                                 xK_k),              windows W.swapUp)
    , ((modm .|. shiftMask,                                 xK_Page_Up),        windows W.swapUp)


    ------------------------------------------------------------------------
    -- Windows Layout
    ------------------------------------------------------------------------
    -- Push window back into tiling
    , ((modm,                                               xK_t),              withFocused $ windows . W.sink)


    ------------------------------------------------------------------------
    -- Master Area
    ------------------------------------------------------------------------
    -- Shrink the master area
    , ((modm,                                               xK_h),              sendMessage Shrink)
    -- Expand the master area
    , ((modm,                                               xK_l),              sendMessage Expand)

    -- Increment the number of windows in the master area
    , ((modm,                                               xK_comma),          sendMessage (IncMasterN 1))
    -- Deincrement the number of windows in the master area
    , ((modm,                                               xK_period),         sendMessage (IncMasterN (-1)))


    ------------------------------------------------------------------------

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --, ((modm,                                             xK_b),              sendMessage ToggleStruts)

    -- Lock screen
    --, ((mod4Mask .|. shiftMask,                           xK_l),              spawn "xlock -mode forest" )
    --, ((modm .|. shiftMask,                               xK_l),              spawn "xlock -mode forest")
    --, ((modm .|. shiftMask,                               xK_l),              spawn "xlock -mode swirl")
    , ((modm .|. shiftMask,                                 xK_l),              spawn "xscreensaver-command -lock")

    -- Screenshot
    --, ((mod4Mask,                                         xK_x),              spawn "scrot '%Y-%m-%d-%H%M%S.png' -b -u -e 'mv $f ~/Pictures/Screenshots/'" ) -- Focused window
    --, ((mod4Mask .|. shiftMask,                           xK_x),              spawn "scrot '%Y-%m-%d-%H%M%S-full.png' -b -e 'mv $f ~/Pictures/Screenshots/'" ) -- Entire screen
    --, ((mod4Mask,                                         xK_x),              spawn "scrot '%Y-%m-%d-%H%M%S-window.png' -b -u" ) -- Focused window
    --, ((mod4Mask .|. shiftMask,                           xK_x),              spawn "scrot '%Y-%m-%d-%H%M%S-fullscreen.png' -b" ) -- Entire screen
    , ((0,                                                  xK_Print),          spawn "scrot")
    , ((controlMask,                                        xK_Print),          spawn "sleep 0.2; scrot -u -b")
    , ((shiftMask,                                          xK_Print),          spawn "sleep 0.2; scrot -u -b")
    , ((modm,                                               xK_Print),          spawn "sleep 0.2; scrot -u -b")
    , ((modm .|. shiftMask,                                 xK_Print),          spawn "sleep 0.2; scrot -u -b")

    --------------------------------------------------------
    -- XMonad
    --------------------------------------------------------
    -- Quit xmonad
    , ((modm .|. shiftMask,                                 xK_q),              io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm,                                               xK_q),              spawn "xmonad --recompile; xmonad --restart")

    --, ((modm .|. controlMask .|. shiftMask,               xK_Right),          sendMessage $ Move R)
    --, ((modm .|. controlMask .|. shiftMask,               xK_Left),           sendMessage $ Move L)
    --, ((modm .|. controlMask .|. shiftMask,               xK_Up),             sendMessage $ Move U)
    --, ((modm .|. controlMask .|. shiftMask,               xK_Down),           sendMessage $ Move D)
    --, ((modm .|. controlMask .|. shiftMask .|. mod1Mask,  xK_k),              sendMessage $ moveToNewGroupUp)
    --, ((modm .|. controlMask .|. shiftMask .|. mod1Mask,  xK_j),              sendMessage $ moveToNewGroupDown)
    --, ((modm .|. controlMask .|. shiftMask,               xK_K),              moveToNewGroupUp)


    --------------------------------------------------------
    -- not working???
    --------------------------------------------------------
    , ((modm .|. shiftMask,                                 xK_F1),             nextOuterLayout)
    , ((modm .|. shiftMask,                                 xK_F2),             decreaseNMasterGroups)
    , ((modm .|. shiftMask,                                 xK_F3),             increaseNMasterGroups)
    , ((modm .|. shiftMask,                                 xK_F5),             moveToGroupDown True)
    , ((modm .|. shiftMask,                                 xK_F6),             moveToGroupUp True)
    , ((modm .|. shiftMask,                                 xK_F7),             moveToNewGroupDown)
    , ((modm .|. shiftMask,                                 xK_F8),             moveToNewGroupUp)

    , ((modm,                                               xK_Right),          sendMessage $ Go R)
    , ((modm,                                               xK_Left),           sendMessage $ Go L)
    , ((modm,                                               xK_Up),             sendMessage $ Go U)
    , ((modm,                                               xK_Down),           sendMessage $ Go D)
    , ((modm .|. shiftMask,                                 xK_Right),          sendMessage $ Move R)
    , ((modm .|. shiftMask,                                 xK_Left),           sendMessage $ Move L)
    , ((modm .|. shiftMask,                                 xK_Up),             sendMessage $ Move U)
    , ((modm .|. shiftMask,                                 xK_Down),           sendMessage $ Move D)
    , ((modm .|. controlMask,                               xK_Right),          sendMessage $ Swap R)
    , ((modm .|. controlMask,                               xK_Left),           sendMessage $ Swap L)
    , ((modm .|. controlMask,                               xK_Up),             sendMessage $ Swap U)
    , ((modm .|. controlMask,                               xK_Down),           sendMessage $ Swap D)


    --------------------------------------------------------
    -- Help
    --------------------------------------------------------
    -- Run xmessage with a summary of the default keybindings (useful for beginners)
    --, ((modm .|. shiftMask, xK_slash ), spawn ("echo \"" ++ help ++ "\" | xmessage -file -")) -- haskellPackages.hzenity
    , ((modm .|. shiftMask,                                 xK_slash ),         spawn ("echo \"" ++ help ++ "\" | gxmessage -font monospace -file -"))
    --, ((modm .|. shiftMask, xK_slash ), spawn ("gxmessage" ++ help ))
    ]


    --------------------------------------------------------
    -- Workspace
    --------------------------------------------------------
    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    ++
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]

    -- ++
    -- [((m .|. modm .|. controlMask, k), windows $ LIS.onCurrentScreen f i)
    --     | (i, k) <- zip (LIS.workspaces' conf) [xK_1 .. xK_9]
    --     , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]

    --------------------------------------------------------
    -- physical/Xinerama screens
    --------------------------------------------------------
    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    ++
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

    -- ++
    -- [ ((modm, xK_c), spawn "emacsclient -c") ] -- super+c

------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $ [
    -- mod-button1, Set the window to floating mode and move by dragging
    ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))
    ,
    -- mod-button2, Raise the window to the top of the stack
    ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    ,
    -- mod-button3, Set the window to floating mode and resize by dragging
    ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- Change (the currently focus) window title -------------------------------
    -- , (( modm .|. mod1Mask, button3), \w -> spawn "~/.xmonad/bin/change_window_title.sh") -- <super><alt><mouse-right-click>

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- Colors for text and backgrounds of each tab when in "Tabbed" layout.
-- NOTE: https://sourcefoundry.org/hack/playground.html
-- tabConfig = defaultTheme {
tabConfig = def {
    --fontName = "xft:monospace:pixelsize=10:antialias=false:hinting=true",
    --fontName = "xft:monospace:pixelsize=10:style=bold:antialias=false:hinting=true",
    --fontName = "xft:monospace:pixelsize=10:style=bold:hinting=true",
    --fontName = "xft:monospace:pixelsize=10:style=bold",
    --fontName = "xft:monospace:size=10:style=bold", -- best 2024-11-30 20:24
    fontName = "xft:monospace:size=9:style=bold",
    --fontName = "xft:Terminus (TTF):pixelsize=12:antialias=false:hinting=true", -- GOOD!
    --fontName = "xft:Source Code Pro:pixelsize=12:antialias=false:hinting=true",

    --fontName = "xft:terminus:pixelsize=10:antialias=false:hinting=true",
    --fontName = "xft:terminus:size=8:antialias=false:hinting=true",
    --fontName = "xft:arial:pixelsize=10:antialias=false:hinting=true",
    --fontName = "xft:Ubuntu Mono:pixelsize=10:antialias=false:hinting=true",
    --fontName = "xft:Ubuntu Mono derivative Powerline:pixelsize=10:antialias=true:hinting=true",
    --fontName = "xft:JetBrainsMono Nerd Font Mono:size=9", -- working, but the font seam to tall
    --fontName = "xft:JetBrainsMono Nerd Font Mono:style=Bold:size=9:antialias=true:hinting=true",
    --fontName = "xft:Fira Mono for Powerline:style=Bold-10",
    --fontName = "xft:Ubuntu Mono:pixelsize=12:antialias=true:hinting=true",
    --fontName = "xft:Fira Mono for Powerline:style=Bold:size=9", -- working good, but the font problem when zoom
    --fontName = "xft:Fira Mono for Powerline:style=Bold:size=8",
    --fontName = "xft:Fira Mono for Powerline:style=Regular:size=9",
    activeBorderColor = "#FF0000",-- "#7C7C7C",
    activeTextColor = "#00FF00",--"#CEFFAC",
    activeColor = "#000000",
    inactiveBorderColor = "#7C7C7C",--"#222222",
    inactiveTextColor = "#EEEEEE",
    inactiveColor = "#000000"--,
    --inactiveBorderWidth = 0
    }

myTiledTabsConfig = def {
    tabsTheme = tabConfig
    }

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
myLayout =
    renamed [Replace "Tab"] ( avoidStruts (
                              windowNavigation (
                                tabbed shrinkText tabConfig
                              )
                            ))
    |||
    -- renamed [Replace "TabTab"] ( avoidStruts ( windowNavigation (combineTwo (TwoPane (3/100) (1/2)) (tabbed shrinkText tabConfig) (tabbed shrinkText tabConfig) )) ) |||
    renamed [Replace "Tab2VSplit"] ( avoidStruts (
           maximizeWithPadding myMaxWithPad (
           -- windowNavigation (
             -- maximizeWithPadding myMaxWithPad (
             windowNavigation (
               (tabbedAlways shrinkText tabConfig) *|* (tabbedAlways shrinkText tabConfig)
             )
           )
         ))
    |||
    renamed [Replace "Tab2HSplit"] ( avoidStruts (
            maximizeWithPadding myMaxWithPad ( windowNavigation (    (tabbed shrinkText tabConfig) */* (tabbed shrinkText tabConfig)    ) )
            ))
    |||
    renamed [Replace "TabOn3"] (
      avoidStruts (
        maximizeWithPadding myMaxWithPad (
          windowNavigation (
            (tabbed shrinkText tabConfig)
            *|*
            windowNavigation (
              (tabbed shrinkText tabConfig) */* (tabbed shrinkText tabConfig)
            )
          )
        )
      )
    )
    |||
    --{-
    renamed [Replace "TabOn4"] (
      avoidStruts (
        maximizeWithPadding myMaxWithPad (
          windowNavigation (
            windowNavigation (
              (tabbed shrinkText tabConfig) */* (tabbed shrinkText tabConfig)
            )
            *|*
            windowNavigation (
              (tabbed shrinkText tabConfig) */* (tabbed shrinkText tabConfig)
            )
          )
        )
      )
    )
    |||
    ---}
    {-
    renamed [Replace "TabInTallMstr"] (
      avoidStruts (
        maximizeWithPadding myMaxWithPad (
          Tall 1 (3/100) (1/2)
        )
      )
    )
    |||
    -}
    --{-
    renamed [Replace "TiledTabGroups"] (
      avoidStruts (
        maximizeWithPadding myMaxWithPad (
          --tallTabs def
          tallTabs myTiledTabsConfig
          --tallTabs 1 (3/100) (1/2)
          --rowOfColumns
        )
      )
    )
    |||
    ---}
    renamed [Replace "Columns"] ( avoidStruts(
            maximizeWithPadding myMaxWithPad (Mirror(Column 1) )
            )) |||
    renamed [Replace "Rows"] (avoidStruts(
            maximizeWithPadding myMaxWithPad (Column 1)
            )) |||
    renamed [Replace "TallMaster"] ( avoidStruts (
            maximizeWithPadding myMaxWithPad ( Tall 1 (3/100) (1/2) )
            )) |||
    renamed [Replace "WideMaster"] (avoidStruts (
          maximizeWithPadding myMaxWithPad (
            Mirror (Tall 1 (3/100) (1/2))
          )
        )) |||
    -- avoidStruts ( ThreeColMid 1 (3/100) (1/2) ) |||
    renamed [Replace "Grid"] (avoidStruts (
          maximizeWithPadding myMaxWithPad (Grid)
        )) |||
    renamed [Replace "Max"] (avoidStruts Full) |||
    -- renamed [Replace "SuperFull"] (fullscreenFull Full) |||
    renamed [Replace "SuperFull"] (noBorders (fullscreenFull Full))
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1        -- 1 window in the master pane

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2      -- half of the screen size

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100    -- 3% of the screen

     -- To be use by maximizeWithPadding
     -- myMaxWithPad = 7
     -- myMaxWithPad = 1
     myMaxWithPad = 0
     -- XXX:

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll [
    className =? "MPlayer"              --> doFloat
    ,
    className =? "Gimp"                 --> doFloat
    ,
    resource  =? "desktop_window"       --> doIgnore
    ,
    resource  =? "kdesktop"             --> doIgnore
    ]

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = mempty


-- myEventHook :: Event -> X All
-- myEventHook (ClientMessageEvent _ _ _ _ msg) = do
--     let maximizeMessage = "_NET_WM_STATE_MAXIMIZED_VERT"  -- Message for vertical maximization
--     let restoreMessage = "_NET_WM_STATE_NORMAL"            -- Message for restoring
--     when (msg == maximizeMessage || msg == restoreMessage) $ do
--         win <- asks theRoot >>= \r -> getFocus r  -- Get currently focused window
--         setWindowBorderColor win  -- Call function to set border color
--     return (All True)
-- myEventHook _ = return (All True)
--
-- setWindowBorderColor :: Window -> X ()
-- setWindowBorderColor win = do
--     isMaximized <- withDisplay $ \d -> do
--         wmState <- getAtom "_NET_WM_STATE"
--         maxVert <- getAtom "_NET_WM_STATE_MAXIMIZED_VERT"
--         maxHorz <- getAtom "_NET_WM_STATE_MAXIMIZED_HORZ"
--         state <- getProperty32 d win wmState 0 1024  -- Check the window's state properties
--         return $ maxVert `elem` state || maxHorz `elem` state  -- Check if it's maximized
--
--     if isMaximized
--         then setBorderColor win "blue"  -- Set border color to blue if maximized
--         else setBorderColor win "default"  -- Set back to default if not maximized
--
-- setBorderColor :: Window -> String -> X ()
-- setBorderColor win color = withDisplay $ \d -> do
--     gc <- createGC d win  -- Create graphics context for drawing borders
--     setForeground d gc (colorToPixel d color)  -- Set the border color using pixel value
--     drawRectangle d win gc 0 0 width height  -- Draw the rectangle as border (you may need to adjust this)



-- Custom hook to change border color when a window gains focus
-- zoomEventHook :: Event -> X All
-- zoomEventHook (ClientMessageEvent {ev_window = w}) = do
--   withDisplay $ \dpy -> do
--     let blue = 0x0000FF -- Blue color in hexadecimal
--     io $ setWindowBorder dpy w (fromIntegral blue)
--   return (All True)
-- zoomEventHook _ = return (All True)

---- Change border color based on window state
--changeBorderColor :: Window -> Pixel -> X ()
--changeBorderColor w color = withDisplay $ \dpy ->
--    io $ setWindowBorder dpy w color
--
---- Hook to change border color when a window is maximized or restored
--zoomEventHook :: Event -> X All
--zoomEventHook (ClientMessageEvent {ev_window = w}) = do
--    -- Check if the window is in the current window set
--    withWindowSet $ \ws -> do
--        let isMaximized = any (\win -> win == w) (W.allWindows ws)
--        if isMaximized
--            then changeBorderColor w (fromIntegral 0x0000FF) -- Blue when maximized
--            else changeBorderColor w (fromIntegral 0x000000) -- Default when not maximized
--    return (All True)
--zoomEventHook _ = return (All True)


-- maximizeRestoreHook :: Event -> X All
-- maximizeRestoreHook (ClientMessageEvent {ev_window = w}) = do
--     withFocused $ \focusedWindow -> do
--         if focusedWindow == w
--             then do
--                 -- Assuming maximized windows have a specific border color
--                 isMaximized <- isWindowMaximized w
--                 if isMaximized
--                     then setBorderColor w 0x0000FF -- Blue for maximized
--                     else setBorderColor w 0x000000 -- Default border color
--             else return ()
--     return (All True)
-- maximizeRestoreHook _ = return (All True)

-- Utility function to check if a window is maximized
-- isWindowMaximized :: Window -> X Bool
-- isWindowMaximized w = do
--     ws <- gets windowset
--     let stack = W.stack . W.workspace . W.current $ ws
--     return $ case stack of
--         Just s -> w == W.focus s && isMaximizedLayout (W.layout $ W.workspace $ W.current ws)
--         Nothing -> False

-- Example implementation for border color change (requires X11 interaction)
-- setBorderColor :: Window -> Pixel -> X ()
-- setBorderColor w color = withDisplay $ \dpy -> io $ setWindowBorder dpy w color

-- Check if the current layout is maximized
-- isMaximizedLayout :: Layout Window -> Bool
-- isMaximizedLayout layout =
--     case fromLayout layout of
--         Just _ -> True
--         Nothing -> False
--   where
--     fromLayout :: Layout Window -> Maybe (ModifiedLayout Maximize Window)
--     -- fromLayout = asTypeOf Nothing . cast
--     fromLayout = cast
--
-- isMaximizedLayout :: Layout Window -> Bool
-- isMaximizedLayout _ = True  -- Simplified; maximization state tracking happens elsewhere


------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
-- Empty logHook for additional customization
myLogHook :: X ()
myLogHook = mempty

myBasicXmobarPP :: Handle -> PP
myBasicXmobarPP xmproc = xmobarPP {
    ppOutput  = hPutStrLn xmproc
  , ppTitle   = xmobarColor "#14FF08" "" . shorten 30
  , ppCurrent = xmobarColor "#181715" "#58C5F1" . wrap "[" "]"
  , ppVisible = xmobarColor "#58C5F1" "#181715" . wrap "(" ")"
  , ppUrgent  = xmobarColor "#181715" "#D81816"
  , ppHidden  = xmobarColor "#58C5F1" "#181715"
  , ppSep     = " "
}

-- Custom xmobarPP for multiple Handles
myXmobarPP :: [Handle] -> PP
myXmobarPP xmprocs = xmobarPP
  {
  --  ppOutput  = \x -> mapM_ (\h -> when (h /= undefined) (hPutStrLn h x)) xmprocs
    ppOutput  = \x -> mapM_ (`hPutStrLn` x) xmprocs
  , ppTitle   = xmobarColor "#14FF08" "" . shorten 30
  , ppCurrent = xmobarColor "#181715" "#58C5F1" . wrap "[" "]"
  , ppVisible = xmobarColor "#58C5F1" "#181715" . wrap "(" ")"
  , ppUrgent  = xmobarColor "#181715" "#D81816"
  , ppHidden  = xmobarColor "#58C5F1" "#181715"
  , ppSep     = " "
  }

-- Function to create screen-specific PP
--myXmobarPP :: ScreenId -> [Handle] -> PP
--myXmobarPP sid xmprocs = LIS.marshallPP sid $ xmobarPP
--  {
--    ppOutput  = \x -> mapM_ (`hPutStrLn` x) xmprocs
--  , ppTitle   = xmobarColor "#14FF08" "" . shorten 38
--  , ppCurrent = xmobarColor "#181715" "#58C5F1" . wrap "[" "]"
--  , ppVisible = xmobarColor "#58C5F1" "#181715" . wrap "(" ")"
--  , ppUrgent  = xmobarColor "#181715" "#D81816"
--  , ppHidden  = xmobarColor "#58C5F1" "#181715"
--  , ppSep     = " "
--  }

------------------------------------------------------------------------
-- Startup hook

---- import Control.Concurrent (threadDelay)
---- import System.Console.ANSI (setSGR, SGR(..))
---- Function to sound a continuous beep for a specified duration in seconds
--beepFor :: Int -> IO ()
--beepFor seconds = do
--    let endTime = seconds * 1000000 -- Convert seconds to microseconds
--    let beepDuration = 100000        -- Duration of each beep in microseconds
--    let totalBeepTime = 3000000      -- Total time for beeping in microseconds
--
--    -- Loop to produce beeps
--    let loop timeLeft
--            | timeLeft > 0 = do
--                putStr "\a"          -- Output the beep character
--                threadDelay beepDuration -- Wait for the beep duration
--                loop (timeLeft - beepDuration)
--            | otherwise = return ()
--
--    loop totalBeepTime


-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
-- myStartupHook = return ()
myStartupHook = do
    -- Reset custom maximize state
--    XS.put $ MaximizeState
--      { isMaximized = False
--      , lastWindow = Nothing
--      }

    spawnOnce "~/.xmonad/bin/autostart.sh"
      -- >> spawnOnce "~/.xmonad/bin/kill2restart-xmobar.sh"
      -- >> spawn "killall xmobar"
      -- >> spawnOnce "~/.xmonad/bin/kill2restart-sidetool.sh"
      -- >> spawnOnce "xrandr --setmonitor CombineMonitor 2560/752x1024/301+1920+0 VGA-1-1,DP-1"
      -- >> spawnOnce "xrandr --setmonitor LaptopMonitor 1920/344x1080/194+0+0 eDP-1-1"
      -- >> spawnOnce "~/.xmonad/bin/start-sidetool.sh";
--
-- Checking fo duplicate key bindings.
-- XMonad.Util.EZConfig provides a function checkKeymap to check for duplicate key bindings, otherwise the duplicates will be silently ignored.
--myStartupHook = return () >> checkKeymap myConfig myKeymap
--myStartupHook = return () >> checkKeymap myKeymap
------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Helper function to remove trailing newlines
-- trim :: String -> String
-- trim = reverse . dropWhile (`elem` "\n\r") . reverse

-- Ref: https://github.com/prikhi/xmobar/blob/master/src/Xmobar/Config/Types.hs
-- -----------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------
-- fakeHandleDelay :: Int -> IO Handle
-- fakeHandleDelay delay = do
--   threadDelay delay
--   return undefined

-- Start xmobar instances dynamically based on hostname
-- NOTE:
--   If problem with which screen, check nvidia setting, Xinerama, PRIME, ...
--startXmobars :: String -> IO [Handle]
--startXmobars hostname = case hostname of
--  "khadijah" -> sequence
--    [
--    --  spawnPipe "xmobar ~/.xmonad/xmobarrc-host1.hs" -- Needs xmproc
--    --, spawnPipe "xmobar ~/.xmonad/xmobarrc-prayertimes-host1.hs" -- Needs xmproc
--      spawnPipe "xmobar --screen=0 --position=Bottom ~/.xmonad/xmobarrc-main-newCPU.hs" -- Needs xmproc
--    --, fakeHandleDelay 1000000  -- 1 second
--    --, spawnPipe "xmobar --screen=0 --position=top ~/.xmonad/xmobarrc-top.hs" >> return undefined -- Do not needs xmproc
--    --, spawnPipe "xmobar --screen=0 --position=top ~/.xmonad/xmobarrc-top.hs" -- Do not needs xmproc
--    , spawnPipe "xmobar --screen=0 --position=Top ~/.xmonad/xmobarrc-waktuSolat.hs" -- Do not needs xmproc
--    --, fakeHandleDelay 1000000  -- 1 second
--    --, spawnPipe "xmobar --screen=2 --position=Bottom ~/.xmonad/xmobarrc-top.hs" >> return undefined -- Do not needs xmproc
--    --, spawnPipe "xmobar --screen=2 --position=Bottom ~/.xmonad/xmobarrc-top.hs" -- Do not needs xmproc
--    --, spawnPipe "xmobar --screen=1 --position=Top ~/.xmonad/xmobarrc.hs" -- Needs xmproc
--    --, fakeHandleDelay 1000000  -- 1 second
--    --, spawnPipe "xmobar --screen=2 --position=Top ~/.xmonad/xmobarrc.hs" -- Needs xmproc
--    ]
--
--  --"asmak" -> sequence
--  --  [
--  --  --  spawnPipe "xmobar ~/.xmonad/xmobarrc-host1.hs" -- Needs xmproc
--  --  --, spawnPipe "xmobar ~/.xmonad/xmobarrc-prayertimes-host1.hs" -- Needs xmproc
--  --    spawnPipe "xmobar --screen=0 --position=Bottom ~/.xmonad/xmobarrc.hs" -- Needs xmproc
--  --  , spawnPipe "xmobar --screen=0 --position=top ~/.xmonad/xmobarrc-top.hs" >> return undefined -- Do not needs xmproc
--  --  ]
--
--  --"host2" -> sequence
--  --  [ spawnPipe "xmobar ~/.xmonad/xmobarrc-host2.hs" -- Needs xmproc
--  --  , spawn "xmobar ~/.xmonad/xmobarrc-top-host2.hs" >> return undefined -- No xmproc
--  --  ]
--
--  --"host3" -> sequence
--  --  [ spawnPipe "xmobar ~/.xmonad/xmobarrc-host3.hs" -- Needs xmproc
--  --  ]
--
--  _ -> sequence
--    [
--    --spawnPipe "xmobar ~/.xmonad/xmobarrc.hs" -- Needs xmproc
--    --, spawn "xmobar ~/.xmonad/xmobarrc-prayertimes.hs" >> return undefined -- No xmproc
--      --spawnPipe "xmobar --screen=0 --position=Bottom ~/.xmonad/xmobarrc-bottom-zahrah.hs" -- Needs xmproc
--      spawnPipe "xmobar --screen=0 --position=Bottom ~/.xmonad/xmobarrc-main-oldCPU.hs" -- Needs xmproc
--    --, spawnPipe "xmobar --screen=0 --position=top ~/.xmonad/xmobarrc-top.hs" >> return undefined -- Do not needs xmproc
--    , spawnPipe "xmobar --screen=0 --position=top ~/.xmonad/xmobarrc-waktuSolat.hs" -- Do not needs xmproc
--    ]
--
--startXmobars2 :: String -> IO [Handle]
--startXmobars2 hostname = case hostname of
--    "khadijah" -> do
--        xmproc <- spawnPipe "xmobar --screen=0 --position=Bottom ~/.xmonad/xmobarrc-main-newCPU.hs" -- Needs xmproc
--        spawnPipe "xmobar --screen=0 --position=Top ~/.xmonad/xmobarrc-waktuSolat.hs" -- Do not needs xmproc
--        return [xmproc]
--
--    _ -> do
--        xmproc <- spawnPipe "xmobar --screen=0 --position=Bottom ~/.xmonad/xmobarrc-main-oldCPU.hs" -- Needs xmproc
--        spawnPipe "xmobar --screen=0 --position=top ~/.xmonad/xmobarrc-waktuSolat.hs" -- Do not needs xmproc
--        return [xmproc]

-- NOTE: !!! must use 'top', and not 'Top' !!!
startXmobars3 :: String -> IO [Handle]
startXmobars3 hostname = case hostname of
    "khadijah" -> do
        -- -- xmprocBottom <- spawnPipe "xmobar --screen=0 --position=Bottom ~/.xmonad/xmobarrc-main-newCPU.hs -d" -- Needs xmproc
        -- xmprocBottom <- spawnPipe "xmobar --screen=0 --position=top ~/.xmonad/xmobarrc-main-newCPU.hs -d" -- Needs xmproc
        -- --xmprocTop <- spawnPipe "xmobar --screen=0 --position=Top ~/.xmonad/xmobarrc-waktuSolat.hs -d" -- Do not needs xmproc
        -- -- spawnPipe "xmobar --screen=0 --position=Top ~/.xmonad/xmobarrc-waktuSolat.hs -d" -- Do not needs xmproc
        -- spawn "xmobar --screen=1 --position=top ~/.xmonad/xmobarrc-waktuSolat.hs -d" -- Do not needs xmproc
        -- -- TODO: both xmobar position at bottom screen-1 and screen-2
        --
        xmprocBottom <- spawnPipe "xmobar --screen=0 --position=Bottom ~/.xmonad/xmobarrc-main-newCPU.hs -d" -- Needs xmproc
        spawn "xmobar --screen=0 --position=top ~/.xmonad/xmobarrc-waktuSolat.hs -d" -- Do not needs xmproc
        --
        -- return [xmprocBottom, xmprocTop]
        return [xmprocBottom]

    _ -> do
        xmprocBottom <- spawnPipe "xmobar --screen=0 --position=Bottom ~/.xmonad/xmobarrc-main-oldCPU.hs -d" -- Needs xmproc
        -- threadDelay 5000000 -- in miliseconds;
        -- xmprocTop <- spawnPipe "xmobar --screen=0 --position=top ~/.xmonad/xmobarrc-waktuSolat.hs -d" -- Do not needs xmproc
        spawn "xmobar --screen=0 --position=top ~/.xmonad/xmobarrc-waktuSolat.hs -d" -- Do not needs xmproc
        -- threadDelay 5000000 -- in miliseconds;
        -- return [xmprocBottom, xmprocTop]
        return [xmprocBottom]

-- -----------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------

-- Run xmonad with the settings you specify. No need to modify this.
-- main = xmonad =<< statusBar myBar myPP toggleGapsKey myConfig
-- main = xmonad defaults
main = do
    -- spawnOnce "~/.xmonad/bin/autostart.sh"
    spawn "~/.xmonad/bin/kill2restart-xmobar.sh"
    spawn "~/.xmonad/bin/kill2restart-sidetool.sh"
    spawn "killall xmobar"
    spawn "pkill xmobar"
    threadDelay 5000000 -- in miliseconds
    spawn "~/.xmonad/bin/start-sidetool.sh"

    -- -- Get the current hostname dynamically
    hostname <- fmap nodeName getSystemID

    --xmproc <- spawnPipe "xmobar --screen=0 --position=Bottom ~/.xmonad/xmobarrc-main-oldCPU.hs" -- Needs xmproc
    --spawnPipe "xmobar --screen=0 --position=top ~/.xmonad/xmobarrc-waktuSolat.hs" -- Do not needs xmproc
    --
    -- -- Start xmobar instances based on the hostname
    -- xmprocs <- startXmobars hostname
    --xmprocs <- startXmobars2 hostname
    xmprocs <- startXmobars3 hostname
    --threadDelay 5000000 -- in miliseconds;

    --xmonad $ defaults {
    --xmonad $ def {
    --xmonad $ defaults
    --xmonad $ Hacks.javaHack (def {
    --xmonad $ Hacks.javaHack  def {
    --xmonad $ ewmh defaultConfig {
    -- xmonad . configureMRU $ ewmh defaultConfig {
    -- xmonad . configureMRU $ ewmh def {
    -- xmonad $ ewmh def {
    xmonad $ ewmh . docks $ def {
-- {-
        -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

        -- key bindings
        keys               = myKeys,
        --keys = \conf -> mkKeymap conf $ myKeys conf,
        mouseBindings      = myMouseBindings,

        layoutHook         = myLayout,
        --layoutHook         = avoidStruts $ (docks $ myLayout),
        --layoutHook = avoidStruts $ layoutHook defaultConfig,
        --layoutHook         = smartBorders $ myLayout,
        --layoutHook = smartBorders . avoidStruts $ layoutHook defaultConfig
        -- The . thing combines several functions into one, in this case it will combine smartBorders with avoidStruts to give you the benefits of both.
        -- layoutHook = composeAll [
        --    myLayout--,
        --    --layoutHook defaultConfig
        --    ],

        -- handleEventHook    = myEventHook,
        --handleEventHook    = docksEventHook,
        --handleEventHook    = myEventHook <+> docksEventHook,
        --handleEventHook    = handleEventHook def <> Hacks.windowedFullscreenFixEventHook <+> myEventHook <+> docksEventHook,
        --handleEventHook    = handleEventHook def <> Hacks.windowedFullscreenFixEventHook <+> myEventHook <+> docksEventHook <> Hacks.trayerAboveXmobarEventHook,
        --handleEventHook    = handleEventHook def <> Hacks.windowedFullscreenFixEventHook <+> myEventHook <+> docksEventHook <> Hacks.trayerAboveXmobarEventHook <> Hacks.trayerPaddingXmobarEventHook,
        --windowedFullscreenFixEventHook :: Event -> X All
        --
        --handleEventHook    = handleEventHook def <+> myEventHook <+> docksEventHook,  -- <-- I am using this
        --handleEventHook    = handleEventHook def <+> myEventHook <+> docksEventHook <> Hacks.trayerPaddingXmobarEventHook,  -- <-- currently testing this
        --handleEventHook    = handleEventHook def <+> myEventHook <+> docksEventHook <+> Hacks.trayerPaddingXmobarEventHook,  -- <-- currently testing this
        -- handleEventHook    = handleEventHook def <+> myEventHook <+> docksEventHook <+> Hacks.trayerAboveXmobarEventHook <+> Hacks.trayerPaddingXmobarEventHook,
        -- handleEventHook    = handleEventHook def <+> myEventHook <+> docks <+> Hacks.trayerAboveXmobarEventHook <+> Hacks.trayerPaddingXmobarEventHook,
        handleEventHook    = handleEventHook def <+> myEventHook <+> Hacks.trayerAboveXmobarEventHook <+> Hacks.trayerPaddingXmobarEventHook,
        --handleEventHook    = handleEventHook def <+> docksEventHook <+> Hacks.trayerPaddingXmobarEventHook,  -- <-- currently testing this
        -- handleEventHook    = handleEventHook def <+> myEventHook <+> zoomEventHook <+> docksEventHook <> Hacks.trayerPaddingXmobarEventHook,  -- <-- currently testing this
        --handleEventHook    = handleEventHook def <+> myEventHook <+> maximizeRestoreHook <+> docksEventHook <> Hacks.trayerPaddingXmobarEventHook,  -- <-- currently testing this

        -- startupHook        = myStartupHook,
        --startupHook        = setWMName "LG3D",
        --startupHook        = myStartupHook <+> setWMName "LG3D",
        -- startupHook        = myStartupHook <+> ewmhDesktopsStartup <+> setWMName "LG3D",
        -- startupHook        = myStartupHook <+> ewmh <+> setWMName "LG3D",
        startupHook        = myStartupHook <+> setWMName "LG3D",

        -- The "manage hook" is the thing that decides how windows are supposed to appear.
        -- The <+> thing combines options for the manage hook.
        --
        --manageHook = myManageHook,
        --manageHook = manageDocks <+> myManageHook <+> manageHook defaultConfig,
        --manageHook = manageDocks <+> myManageHook,
        manageHook = composeAll [  --  composeAll will automatically combine every item in the list with the <+> operator.
            manageDocks,
            -- isFullscreen --> doFullFloat,
            -- className =? "Vlc" --> doFloat,
            myManageHook--,
            --manageHook defaultConfig
            ],
        -- NOTE: You can float your windows before fullscreening them. This is
        -- usually accomplished by holding down the modkey and left clicking on
        -- the window once. When you have floated the window, it can cover all
        -- other windows, including xmobar. So if you then try to fullscreen
        -- the window, it should cover the entire screen.

        -- logHook = myLogHook
        --
        --logHook = myLogHook <+> dynamicLogWithPP (myBasicXmobarPP xmproc)
        --
        -- -- Multiple xmobar with xmprocs: working config
        -- -- logHook = updateBorderColors >> dynamicLog -- Update border colors after each layout change
        logHook = myLogHook <+> dynamicLogWithPP (myXmobarPP xmprocs)
        --
        -- screen-base workspaces: not working
        --logHook = myLogHook <+> mconcat
        --    [ dynamicLogWithPP (myXmobarPP (fromIntegral sid) [xmprocs !! sid])  -- Cast sid to ScreenId
        --    | sid <- [0 .. length xmprocs - 1] ]
        --
        -- test
        --logHook = myLogHook <+> mconcat
        --    [ io (putStrLn "Running logHook") >> dynamicLogWithPP (myXmobarPP (fromIntegral sid) [xmprocs !! sid])
        --    | sid <- [0 .. length xmprocs - 1] ]

        -- } `additionalKeys` myKeys `removeKeys` [(mod4Mask, xK_q)]
        } -- end xmonad -- `additionalKeys` [
        --    ((mod4Mask .|. shiftMask, xK_l), spawn "xlock -mode forest"),
        --    ((controlMask, xK_Print), spawn "sleep 0.2; scrot"),
        --    ((0, xK_Print), spawn "scrot")
        --    ]

-------------------------------------------------------------------------------
-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
-- No need to modify this.
-- myConfig = def {
--defaults = def {
{-defaults = defaultConfig {
  -- simple stuff
  terminal           = myTerminal,
  focusFollowsMouse  = myFocusFollowsMouse,
  clickJustFocuses   = myClickJustFocuses,
  borderWidth        = myBorderWidth,
  modMask            = myModMask,
  workspaces         = myWorkspaces,
  normalBorderColor  = myNormalBorderColor,
  focusedBorderColor = myFocusedBorderColor,

  -- key bindings
  keys               = myKeys,
  mouseBindings      = myMouseBindings,

  -- hooks, layouts
  layoutHook         = myLayout,
  --layoutHook         = smartBorders $ myLayout,
  manageHook         = myManageHook,
  handleEventHook    = myEventHook,
  logHook            = myLogHook,
  startupHook        = myStartupHook
}-}
-------------------------------------------------------------------------------

-- | Finally, a copy of the default bindings in simple textual tabular format.
mmm :: String
mmm = "Super"
help :: String
help = unlines [
    "",
    "Launching and killing programs",
    "⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺",
    mmm ++ "-Shift-Enter        Launch xterminal",
    mmm ++ "-p                  Launch rofi",                     -- dmenu
    mmm ++ "-Shift-p            Launch rofi with icons",          -- gmrun
    mmm ++ "-Shift-c            Close/kill the focused window",
    mmm ++ "-Space              Rotate through the available layout algorithms",
    mmm ++ "-Shift-Space        Reset the layouts on the current workSpace to default",
    mmm ++ "-n                  Resize/refresh viewed windows to the correct size",
    "",
    "Move focus up or down the window stack",
    "⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺",
    mmm ++ "-Tab                Change focus to the next window",
    mmm ++ "-Shift-Tab          Change focus to the previous window",
    mmm ++ "-m                  Change focus to the master window",
    "",
    "Modifying the window order",
    "--------------------------",
    "",
    mmm ++ "-Shift-m            Swap position of the focused window and the master window",
    mmm ++ "-Shift-PageDown     Swap position of the focused window with the next window",
    mmm ++ "-Shift-PageUp       Swap position of the focused window with the previous window",
    "",
    "Resizing the master/slave ratio",
    "-------------------------------",
    "",
    mmm ++ "-h                  Shrink the master area",
    mmm ++ "-l                  Expand the master area",
    "",
    "Floating layer support",
    "----------------------",
    "",
    mmm ++ "-t                  Push window back into tiling; unfloat and re-tile it",
    "",
    "Increase or decrease number of windows in the master area",
    "---------------------------------------------------------",
    "",
    mmm ++ "-comma  (" ++ mmm ++ "-,)   Increment the number of windows in the master area",
    mmm ++ "-period (" ++ mmm ++ "-.)   Deincrement the number of windows in the master area",
    "",
    "Quit, or restart",
    "----------------",
    "",
    mmm ++ "-Shift-q            Quit xmonad",
    mmm ++ "-q                  Restart xmonad",
    mmm ++ "-[1..9]             Switch to workSpace N",
    "",
    "Workspaces & screens",
    "--------------------",
    "",
    mmm ++ "-Shift-[1..9]       Move client to workspace N",
    mmm ++ "-{w,e,r}            Switch to physical/Xinerama screens 1, 2, or 3",
    mmm ++ "-Shift-{w,e,r}      Move client to screen 1, 2, or 3",
    "",
    "Change window title",
    "-----------------------------------------------------",
    "",
    mmm ++ "-Alt-t              Change window title",
    "",
    "Mouse bindings: default actions bound to mouse events",
    "-----------------------------------------------------",
    "",
    mmm ++ "-button1            Set the window to floating mode and move by dragging",
    mmm ++ "-button2            Raise the window to the top of the stack",
    mmm ++ "-button3            Set the window to floating mode and resize by dragging",
    "",
    "Volume control",
    "--------------",
    "",
    "Mute                       Toggle audio output mute",
    "Vol-ve                     Decrease audio output volume",
    "Vol+ve                     Increase audio output volume",
    "Mic                        Toggle mic mute",
    "",
    mmm ++ "-F8                 Decrease audio volume",
    mmm ++ "-F9                 Increase audio volume",
    mmm ++ "-F10                Toggle audio output mute",
    mmm ++ "-Shift-F10          Toggle audio input mute",
    "",
    "Keyboard layout",
    "---------------",
    "",
    mmm ++ "-F4                 Dvorak keyboard layout",
    mmm ++ "-F5                 US keyboard layout",
    mmm ++ "-F6                 Custom Arab-Jawi keyboard layout",
    --mmm ++ "-F7                  Custom-group keyboard layout",
    "",
    "Toggle touchpad",
    "------------------------------",
    "",
    mmm ++ "-F3                 Toggle touchpad enable/disable",
    "",
    "Screen Snapshot",
    "------------------------------",
    "",
    mmm ++ "-PrtScr             Take a screen-shot of current workspace",
    mmm ++ "-Shift-PrtScr       Take a screen-shot of all workspaces (whole desktop)",
    "",
    ""
    ]
