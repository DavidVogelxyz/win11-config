function Set-WinUtilRegistry {
    <#

    .SYNOPSIS
        Modifies the registry based on the given inputs

    .PARAMETER Name
        The name of the key to modify

    .PARAMETER Path
        The path to the key

    .PARAMETER Type
        The type of value to set the key to

    .PARAMETER Value
        The value to set the key to

    .EXAMPLE
        Set-WinUtilRegistry -Name "PublishUserActivities" -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Type "DWord" -Value "0"

    #>
    param (
        $Name,
        $Path,
        $Type,
        $Value
    )

    try {
        if(!(Test-Path 'HKU:\')) {New-PSDrive -PSProvider Registry -Name HKU -Root HKEY_USERS}

        If (!(Test-Path $Path)) {
            Write-Host "$Path was not found, Creating..."
            New-Item -Path $Path -Force -ErrorAction Stop | Out-Null
        }

        if ($Value -ne "<RemoveEntry>") {
            Write-Host "Set $Path\$Name to $Value"
            Set-ItemProperty -Path $Path -Name $Name -Type $Type -Value $Value -Force -ErrorAction Stop | Out-Null
        }
        else{
            Write-Host "Remove $Path\$Name"
            Remove-ItemProperty -Path $Path -Name $Name -Force -ErrorAction Stop | Out-Null
        }
    } catch [System.Security.SecurityException] {
        Write-Warning "Unable to set $Path\$Name to $Value due to a Security Exception"
    } catch [System.Management.Automation.ItemNotFoundException] {
        Write-Warning $psitem.Exception.ErrorRecord
    } catch [System.UnauthorizedAccessException] {
       Write-Warning $psitem.Exception.Message
    } catch {
        Write-Warning "Unable to set $Name due to unhandled exception"
        Write-Warning $psitem.Exception.StackTrace
    }
}

# Dark mode (going to let WinUtil handle this for now)
#Set-WinUtilRegistry -Name AppsUseLightTheme -Path "HKCU:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize" -Type DWord -Value 0
#Set-WinUtilRegistry -Name SystemUsesLightTheme -Path "HKCU:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize" -Type DWord -Value 0

# Disable Bing in taskbar
Set-WinUtilRegistry -Name BingSearchEnabled -Path "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Search" -Type DWord -Value 0

# Hide "Recommended Section" in taskbar
Set-WinUtilRegistry -Name HideRecommendedSection -Path "HKLM:\\SOFTWARE\\Microsoft\\PolicyManager\\current\\device\\Start" -Type DWord -Value 1

# Set education environment to "yes"
Set-WinUtilRegistry -Name IsEducationEnvironment -Path "HKLM:\\SOFTWARE\\Microsoft\\PolicyManager\\current\\device\\Education" -Type DWord -Value 1

# Hide "Recommended Section" in Explorer
Set-WinUtilRegistry -Name HideRecommendedSection -Path "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows\\Explorer" -Type DWord -Value 1

# Set "Show Task View" to off
Set-WinUtilRegistry -Name ShowTaskViewButton -Path "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced" -Type DWord -Value 0

# Disable widgets in taskbar
#Set-WinUtilRegistry -Name TaskbarDa -Path "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced" -Type DWord -Value 0

# Move the taskbar items back to the left -- the way it should be
Set-WinUtilRegistry -Name TaskbarAl -Path "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced" -Type DWord -Value 0

# Enable the "Searchbox Taskbar" mode (will be disabled in next step)
Set-WinUtilRegistry -Name SearchboxTaskbarMode -Path "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Search" -Type DWord -Value 1

# Disable the "Searchbox Taskbar" mode (will be disabled in next step)
Set-WinUtilRegistry -Name SearchboxTaskbarMode -Path "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Search" -Type DWord -Value 0
