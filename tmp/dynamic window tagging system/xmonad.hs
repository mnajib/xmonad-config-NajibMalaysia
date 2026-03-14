--
-- xmonad.hs
--

import XMonad
import XMonad.Util.EZConfig
import XMonad.Util.Ungrab
import XMonad.Hooks.EwmhDesktops
import qualified XMonad.StackSet as W
import XMonad.Actions.TagWindows
import XMonad.Actions.CopyWindow
import Control.Monad (forM_, when)
import Data.List (intersect, (\\))

-- The main function. 
main :: IO ()
main = xmonad . ewmhFullscreen . ewmh $ def
    { modMask            = mod4Mask  -- Use Windows key as mod key
    , terminal           = "alacritty"
    , workspaces         = myWorkspaces
    , logHook            = myLogHook
    , manageHook         = myManageHook
    }
    `additionalKeysP` myKeys

-- Define custom workspaces
myWorkspaces :: [WorkspaceId]
myWorkspaces = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]

-- Configuration: Workspace ID to Tags mapping
workspaceTags :: [(WorkspaceId, [String])]
workspaceTags = 
    [ ("1", ["web"])
    , ("2", ["dev"])
    , ("3", ["web", "dev"])
    , ("4", ["chat"])
    , ("5", ["media"])
    , ("6", ["docs"])
    , ("7", ["misc"])
    , ("8", ["sys"])
    , ("9", ["scratch"])
    ]

-- Helper to remove a window from a specific workspace
removeFromWorkspace :: (Ord a, Eq i) => a -> i -> W.StackSet i l a s sd -> W.StackSet i l a s sd
removeFromWorkspace w tag = W.mapWorkspace (\ws -> 
    if W.tag ws == tag 
    then ws { W.stack = W.stack ws >>= W.filter (/= w) } 
    else ws)

-- Helper to find which workspaces a window is on
workspacesOf :: Window -> W.StackSet i l a s sd -> [i]
workspacesOf w ws = [ W.tag i | i <- W.workspaces ws, w `elem` W.index i ]

-- Sync function: ensures windows are on workspaces based on tags
syncTags :: X ()
syncTags = withWindowSet $ \ws -> do
    let allWindows = W.allWindows ws
    forM_ allWindows $ \win -> do
        winTags <- getTags win
        forM_ workspaceTags $ \(wsId, tags) -> do
            let shouldBeOnWS = not (null (winTags `intersect` tags))
            let isOnWS = wsId `elem` workspacesOf win ws
            if shouldBeOnWS && not isOnWS
                then windows (copyWindow win wsId)
                else if not shouldBeOnWS && isOnWS
                    then windows (removeFromWorkspace win wsId)
                    else return ()

-- Keybindings
myKeys :: [(String, X ())]
myKeys = 
    [ ("M-S-q", kill1) -- Close focused window, or remove from current workspace if copied
    , ("M-S-c", spawn "alacritty") -- Spawn a new terminal
    , ("M-p", spawn "dmenu_run") -- Launch dmenu
    , ("M-S-t", withFocused $ \w -> do -- Add a tag to the focused window
          tagPrompt def $ \s -> addTag s w
          syncTags)
    , ("M-C-t", withFocused $ \w -> do -- Remove a tag from the focused window
          tagPrompt def $ \s -> delTag s w
          syncTags)
    , ("M-S-a", withFocused copyToAll) -- Copy focused window to all workspaces
    , ("M-C-a", killAllOtherCopies) -- Remove focused window from all other workspaces
    ]
    ++
    [ ("M-" ++ show i, windows $ W.greedyView ws)     | (i, ws) <- zip [1..9] myWorkspaces ]  -- Switch to workspace
    ++
    [ ("M-S-" ++ show i, windows $ W.shift ws)        | (i, ws) <- zip [1..9] myWorkspaces ]  -- Move window to workspace
    ++
    [ ("M-C-" ++ show i, windows $ copyWindow w ws) | (i, ws) <- zip [1..9] myWorkspaces, w <- [W.focus ws]] -- Copy window to workspace

-- ManageHook to apply tags on window creation
myManageHook :: ManageHook
myManageHook = composeAll
    [ className =? "Firefox" --> doF (addTag "web")
    , className =? "Alacritty" --> doF (addTag "dev")
    , className =? "discord" --> doF (addTag "chat")
    , className =? "mpv" --> doF (addTag "media")
    , className =? "Zathura" --> doF (addTag "docs")
    , className =? "Gimp" --> doF (addTag "misc")
    , className =? "htop" --> doF (addTag "sys")
    , className =? "scratchpad" --> doF (addTag "scratch")
    , isDialog --> doFloat

    ]

-- LogHook to synchronize tags after every action
myLogHook :: X ()
myLogHook = do
    syncTags


-- EWMH support for extended window manager hints
-- This is necessary for things like fullscreen to work correctly
-- and for some applications to behave properly.
-- You might need to import XMonad.Hooks.EwmhDesktops
-- import XMonad.Hooks.EwmhDesktops
-- main = xmonad . ewmhFullscreen . ewmh $ def
