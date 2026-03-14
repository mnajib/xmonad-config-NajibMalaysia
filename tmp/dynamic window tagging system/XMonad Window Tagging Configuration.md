> **Author**: Manus AI
> **Date**: 2026-03-15

# XMonad Window Tagging Configuration

This document provides a comprehensive guide to the `xmonad.hs` configuration that implements a dynamic window tagging system. This system allows windows to be associated with one or more tags, and workspaces can be configured to display windows based on these tags. A single window can appear on multiple workspaces simultaneously, providing a flexible and powerful window management experience.

## 1. Core Concepts

The tagging system is built upon several key `xmonad` and `xmonad-contrib` modules:

- **`XMonad.Actions.TagWindows`**: This module provides the foundation for adding, removing, and querying window tags. Tags are stored as string properties on each window.
- **`XMonad.Actions.CopyWindow`**: This module allows a window to be "copied" to multiple workspaces. This is the mechanism used to make a window appear on more than one workspace at a time.
- **`XMonad.StackSet`**: This is the core data structure in xmonad that manages the workspaces, screens, and windows. We manipulate this structure to achieve the desired window placement.

## 2. Configuration Overview

The `xmonad.hs` configuration file is structured as follows:

| Section | Description |
| :--- | :--- |
| **Imports** | Imports all necessary modules for the configuration. |
| **`main` function** | The entry point of the configuration, where the xmonad session is initialized with custom settings. |
| **`myWorkspaces`** | A list of all available workspace IDs. |
| **`workspaceTags`** | A mapping that defines which tags are associated with each workspace. This is the core of the tagging logic. |
| **Helper Functions** | `removeFromWorkspace` and `workspacesOf` are custom functions to manage window placement. |
| **`syncTags`** | The main function that synchronizes window placement based on tags. It is called in the `logHook`. |
| **`myKeys`** | Custom keybindings for interacting with the tagging system and other xmonad functions. |
| **`myManageHook`** | Rules for automatically assigning tags to new windows based on their properties (e.g., class name). |
| **`myLogHook`** | A hook that runs after every xmonad action, ensuring that the `syncTags` function is called to keep window placement up-to-date. |

## 3. How It Works

The `syncTags` function is the heart of this configuration. It iterates through all windows and all workspaces, and for each window and workspace, it checks if the window *should* be on that workspace based on its tags. If a window should be on a workspace but isn't, it's copied there using `copyWindow`. If a window is on a workspace but shouldn't be, it's removed using our custom `removeFromWorkspace` function.

This synchronization is triggered by the `logHook`, which means that after any action you perform in xmonad (e.g., opening a new window, changing focus, switching workspaces), the window placement will be automatically updated to reflect the current tag configuration.

## 4. Keybindings

The following keybindings are provided to interact with the tagging system:

| Keybinding | Action |
| :--- | :--- |
| `M-S-t` | Add a tag to the focused window. |
| `M-C-t` | Remove a tag from the focused window. |
| `M-S-a` | Copy the focused window to all workspaces. |
| `M-C-a` | Remove the focused window from all other workspaces. |

## 5. Installation and Usage

1.  **Save the `xmonad.hs` file:** Place the provided `xmonad.hs` file in your `~/.xmonad/` directory.
2.  **Install `xmonad-contrib`:** Ensure you have the `xmonad-contrib` package installed. You can typically install it through your distribution's package manager (e.g., `sudo apt-get install xmonad-contrib` on Debian/Ubuntu).
3.  **Recompile xmonad:** Press `M-q` to recompile and restart xmonad.

Once recompiled, you can start using the tagging system. New windows will be automatically tagged based on the rules in `myManageHook`, and you can manually add or remove tags using the keybindings.

## References

[1] [XMonad.Actions.TagWindows - Hackage](https://hackage.haskell.org/package/xmonad-contrib/docs/XMonad-Actions-TagWindows.html)
[2] [XMonad.Actions.CopyWindow - Hackage](https://hackage.haskell.org/package/xmonad-contrib/docs/XMonad-Actions-CopyWindow.html)
[3] [XMonad.StackSet - Hackage](https://hackage.haskell.org/package/xmonad-0.18.0/docs/XMonad-StackSet.html)
