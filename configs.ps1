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

# - powershell configs need work:
#   - install fonts

#####################################################################
## CLONE SOME REPOS
#####################################################################

# Clone GlazeWM configs
git clone https://github.com/DavidVogelxyz/glazewm-configs "$env:USERPROFILE\.glzr"

# Clone Neovim configs
git clone https://github.com/DavidVogelxyz/nvim "$env:USERPROFILE\AppData\Local\nvim"

# Clone PowerShell configs
git clone https://github.com/DavidVogelxyz/powershell-profile "$env:USERPROFILE\Documents\WindowsPowershell"

# Clone `posh-git`
git clone https://github.com/dahlbyk/posh-git "C:\tools\poshgit\dahlbyk-posh-git-9bda399"

#####################################################################
## EDIT SOME CONFIGS - GLAZEWM
#####################################################################

# Enable GlazeWM to run at startup
cp 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\GlazeWM.lnk' "${env:USERPROFILE}\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"

#####################################################################
## EDIT SOME CONFIGS - NEOVIM
#####################################################################

# Remove "Linux" Neovim files
rm "$env:USERPROFILE\AppData\Local\nvim\lua\default\lazy\lsp.lua"
rm "$env:USERPROFILE\AppData\Local\nvim\lua\default\lazy\treesitter.lua"

#####################################################################
## EDIT SOME CONFIGS - POWERSHELL
#####################################################################

# Download the "CaskaydiaCove Nerd Font" fonts pack
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/CascadiaCode.zip -OutFile "$env:USERPROFILE\Downloads\CascadiaCode.zip"

# Alternate download method
#(New-Object Net.WebClient).DownloadFile("https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/CascadiaCode.zip", "$env:USERPROFILE\Downloads\CascadiaCode.zip")

# Unarchive `CascadiaCode.zip`
Expand-Archive -LiteralPath "$env:USERPROFILE\Downloads\CascadiaCode.zip" -DestinationPath "$env:USERPROFILE\Downloads\CascadiaCode"

# Install CaskaydiaCove Nerd Font
Get-ChildItem -Path "$env:USERPROFILE\Downloads\CascadiaCode" -Include '*.ttf', '*.otf' -Recurse | ForEach { (New-Object -ComObject Shell.Application).Namespace(0x14).CopyHere($_.FullName, 0x10) }
