#####################################################################
# WINDOWS CONFIG SCRIPT
#####################################################################

#####################################################################
## INTRO / TROUBLESHOOTING
#####################################################################

# If not already set, run this command to allow execution of the script
#Set-ExecutionPolicy bypass

#####################################################################
## LIST OF FEATURES TO IMPLEMENT
#####################################################################

# - neovim configs are all good, from download to tweak
#   - just need to install `neovim`
# - glazewm configs are all good, from download to tweak
#   - just need to install `glazewm`
# - powershell configs need work:
#   - install fonts

#####################################################################
## CREATE SOME DIRS - MAY BE UNNECESSARY
#####################################################################

# these may not be needed
# the `git clone` command will create any directories necessary in order to perform the clone

# create directory to store Git repos
#mkdir "$env:USERPROFILE\git-repos"
#mkdir "$env:USERPROFILE\.glzr"

#####################################################################
## CLONE SOME REPOS
#####################################################################

# Clone GlazeWM configs
git clone https://github.com/DavidVogelxyz/glazewm-configs "$env:USERPROFILE\.glzr\glazewm"

# Clone Neovim configs
git clone https://github.com/DavidVogelxyz/nvim "$env:USERPROFILE\AppData\Local\nvim"

# Clone PowerShell configs
git clone https://github.com/DavidVogelxyz/powershell-profile "$env:USERPROFILE\WindowsPowershell"

# Clone `posh-git`
git clone https://github.com/dahlbyk/posh-git "C:\tools\poshgit\dahlbyk-posh-git-9bda399"

#####################################################################
## EDIT SOME CONFIGS - NEOVIM
#####################################################################

# Remove "Linux" Neovim files
rm "$env:USERPROFILE\AppData\Local\nvim\lua\lsp-v2\cmd.lua"
rm "$env:USERPROFILE\AppData\Local\nvim\after\plugin\lsp.lua"
rm "$env:USERPROFILE\AppData\Local\nvim\after\plugin\treesitter.lua"

# Copy the "Windows" Neovim files
cp "$env:USERPROFILE\AppData\Local\nvim\lua\windows\cmd.lua" "$env:USERPROFILE\AppData\Local\nvim\lua\default\cmd.lua"

# Create the `nvim\autoload` directory
mkdir "$env:USERPROFILE\AppData\Local\nvim\autoload"

# Dowload the `plug.vim` file
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest https://raw.githubusercontent.com/junegunn/vim-plug/refs/heads/master/plug.vim -OutFile "$env:USERPROFILE\AppData\Local\nvim\autoload\plug.vim"

#####################################################################
## EDIT SOME CONFIGS - POWERSHELL
#####################################################################

# Download the "CaskaydiaCove Nerd Font" fonts pack
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/CascadiaCode.zip -OutFile "$env:USERPROFILE\Downloads\CascadiaCode.zip"

# Alternate download method
#(New-Object Net.WebClient).DownloadFile("https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/CascadiaCode.zip", "$env:USERPROFILE\Downloads\CascadiaCode.zip")

# Unarchive `CascadiaCode.zip`
Expand-Archive -LiteralPath "$env:USERPROFILE\Downloads\CascadiaCode.zip" -DestinationPath C:\Reference
