# Windows configs

Set of scripts to run after installing Windows 11, so it's configured a certain way.

Note that, even with the script, a Windows setup still takes nearly an hour.

- About 50 minutes from `oobe\BypassNRO.exe` to "reboot after second WinUtil run"

Bottlenecks are:

- Windows install (pre `oobe`)
- Windows inital boot (after `oobe`)
- Windows updates, and reboot
- Installing `OpenSSH Server`
    - Takes forever, for what is purportedly less than 2MB
    - This goes away when grabbing repo from GitHub
- Other package install
    - This is going as fast as it ever will

## Table of contents

- [Instructions](#instructions)
- [What this script does](#what-this-script-does)
- [What this script does NOT do](#what-this-script-does-not-do)
- [References](#references)

## Instructions

Testing only; all others **skip to main section**:

- Allocate Proxmox VM:
    - Select Windows ISO, then select "Guest OS > Type > Windows".
        - Then, select "Add additional drive for VirtIO drivers".
    - Before booting the VM:
        - Check allocated GPU memory.
        - "Disconnect" the network card.
        - Add a sound device.
- Install Windows:
    - At the point of "selecting a drive", load the driver found at:
        - `vioscsi/w11/amd64`
            - should be something like `D:\vioscsi\w11\amd64\vioscsi.inf`
    - Then, select the drive and select "Next".
    - `oobe\BypassNRO.exe` still works
    - Skip the security questions by leaving the password field blank
- Boot into Windows as the new user
- Update drivers
    - Search `dev man` in Windows search. Open "Device Manager".
    - Update 4 drivers:
        - `Display adapters > Microsoft Basic Display Adapter`
            - installs VirtIO display driver
        - `Other Devices > Ethernet Controller`
            - installs VirtIO Ethernet Adapter driver
        - `Other Devices > PCI Device`
            - installs VirtIO balloon driver
        - `Other Devices > PCI Simple Communications Controller`
            - installs VirtIO serial driver
- Re-enable Ethernet, if it's been disconnected
- Change the network type to "Private":
    - `Settings > Network & internet > Properties - Public network`
- Set password for user.
- Force Windows to perform any updates
- Open us "PowerShell as Administrator":
    - SSH:
        - Install `OpenSSH Server`:
            - Search for "Optional Features".
            - Can be installed at the same time as Windows updates step.
        - Enable and start service:
            - `Set-Service sshd`
            - `Start-Service sshd`
    - keep this window open for future steps
- `scp` the repo onto the Windows VM
- Once the updates are done, **reboot the Windows machine**:
    - Otherwise, WinUtil will fail.

**Main section**:

- Force Windows to perform any updates:
    - if any major updates are not performed, WinUtil may fail.
- **If updates**, then reboot the computer:
    - if the reboot isn't performed, WinUtil may fail.
- Run Chris Titus' WinUtil:
    - Command:
        - `irm "https://christitus.com/win" | iex`
    - Tasks:
        - Set dark mode only
        - Perform the "debloat":
            - Use the "Recommended > Standard" option:
                - But, unselect "Create Restore Point".
            - Select "Run Tweaks".
        - keep this window open for future steps
- Browser (skip if `scp`):
    - URL:
        - `https://github.com/DavidVogelxyz/windows-configs`
    - Tasks:
        - Download the repo from GitHub
        - Unarchive the `*.zip` file
- Open up "PowerShell as Administrator".
    - Allow user scripts to be executable:
        - Command:
            - `Set-ExecutionPolicy bypass`
        - Tasks:
            - Select `a` at the prompt.
    - Change directory into user's directory:
        - Command:
            - `cd "${env:USERPROFILE}"`
        - Tasks:
            - change directory
            - keep this window open for future steps
- Run `windows-config`:
    - Run the scripts in this order:
        - `ui-registry-tweaks.ps1` as "Administrator PowerShell"
            - This should take about 5 seconds to complete.
        - `installs.ps1` as "Administrator PowerShell"
            - This may take a few minutes to complete.
        - `configs.ps1` as "regular user PowerShell"
            - 🚨 This "regular user PowerShell" should be a **new terminal** that is opened after `installs.ps1` completes!
            - The may take about a minute to complete.
- Run Chris Titus' WinUtil again:
    - Tasks:
        - Make any additional UI tweaks
        - Perform the "debloat" again
- Reboot the Windows machine.

## What this script does NOT do

There are some things the user still has to do on their own. For reference, this is the "cheat sheet", in the correct order:

- Run Chris Titus' WinUtil:
    - Tasks:
        - (Re)do the UI tweaks
            - Enable dark mode
            - Disable widgets
                - Widgets seems to have a problem. Both WinUtil and I get:
                    - `WARNING: Attempted to perform an unauthorized operation.`
                - Just do it in regular "Taskbar settings" menu
        - Perform the "debloat"
- Start GlazeWM, and enable at startup
    - Tasks:
        - Copy a shortcut of the program into a certain directory.
            - This could almost certainly be automated.
- Install Neovim plugins automatically:
    - Tasks:
        - Open Neovim and execute `:PlugInstall`, and then close Neovim.
    - This could likely be automated, as it is on Linux.
- Configure PowerShell:
    - Tasks:
        - Set the fonts for the default profile for the regular user's PowerShell
        - Set the transparency for the default profile for the regular user's PowerShell
        - Set the fonts for the default profile for the admin Powershell
        - Set the transparency for the default profile for the admin Powershell
- PowerToys:
    - Keyboard Manager:
        - "Caps Lock" as "Escape"
        - Other keybinds
- Other configurations:
    - Add user's home directory to the "Quick access" panel in Windows Explorer

## What this script does

This script speeds up the Windows configuration process by:

- Performing UI tweaks (`ui-registry-tweaks.ps1`, run as an Administrator):
    - Tweaks:
        - Doing some (but not all) of the taskbar UI stuff that has to normally be done with clicks
    - Time benefit:
        - **The time this saves is negligible** -- this is just for reproducibility.
- Installing various programs (`installs.ps1`, run as an Administrator):
    - Programs:
        - Web browser:          Brave
        - Development:          git
        - Text editor:          neovim
        - PowerShell prompt:    ohmyposh
        - Keyboard manager:     powertoys
        - Systen info:          fastfetch
        - Fuzzy finder:         fzf
        - Window manager:       glazewm
        - File transfer:        magic wormhole
        - File search:          ripgrep
    - Time benefit:
        - The install takes as long as it would when running WinUtil; the difference comes from "how long it takes to select the right programs":
            - So, this saves time by automatically choosing all the correct programs, every time, and getting them installed ASAP.
                - Reproducibility.
            - It also guarantees the programs:
                - Often forget to install any programs when running WinUtil for debloat
        - **This saves about a minute.**
- Performing other configurations (`configs.ps1`, run as a regular user):
    - Tasks:
        - Clones `git` repos with configs for various software:
            - Neovim
            - GlazeWM
            - PowerShell
        - Configures Neovim so it runs on Windows without errors
        - Downloads and installs the correct font pack for PowerShell profile
    - Time benefit:
        - This saves the most time out of anything:
            - Before:
                - Assuming the correct Git was installed, PowerShell should be configured so work can be done.
                - In order to get PowerShell working, a Git repo has to be cloned.
                - Clone Git repo for PowerShell, take some time to get it in the right spot.
                - Now, probably noticed no WM. So, same deal for GlazeWM.
                - After a minute or two, this repo is set up as well.
                - Then, Neovim is much more involved, as it requires following additional steps to get it working.
                - New updates have also exacerbated the problem.
                - But, after a while, Neovim is set up.
            - Now:
                - Run `configs.ps1` as a regular user.
        - **The time benefits here could easily be 30-60 minutes, depending on how slow Windows is, how much of the steps have been forgotten, etc**

Therefore, it's fair to say that this set of scripts has increased personal productivity by at least 30 minutes per new Windows VM.

## References

First review:

- [StackOverflow - Get path to the user home directory on Windows in PowerShell?](https://stackoverflow.com/questions/65123462/get-path-to-the-user-home-directory-on-windows-in-powershell/65123463#65123463)
- [ServerFault - Downloading a file using Windows CMD line with curl/wget](https://serverfault.com/questions/1083759/downloading-a-file-using-windows-cmd-line-with-curl-wget/1084289#1084289)
- [Powershell - Why is Using Invoke-WebRequest Much Slower Than a Browser Download? - SilentlyContinue](https://stackoverflow.com/questions/28682642/powershell-why-is-using-invoke-webrequest-much-slower-than-a-browser-download/43477248#43477248)
- [Powershell - Why is Using Invoke-WebRequest Much Slower Than a Browser Download? - Different method](https://stackoverflow.com/questions/28682642/powershell-why-is-using-invoke-webrequest-much-slower-than-a-browser-download/58809758#58809758)
- [Brave - powershell install font](https://search.brave.com/search?q=powershell+install+font&source=desktop&summary=1&conversation=ece8c783c45e0de5c5fb5e)

Second review:

- [GitHub - ChrisTitusTech/winutil - Issue #3316 - winget failure when trying to install any application](https://github.com/ChrisTitusTech/winutil/issues/3316#issuecomment-2797570197)
