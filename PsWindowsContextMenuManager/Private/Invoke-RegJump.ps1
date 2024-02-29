<#
.SYNOPSIS
    Jumps to a specified registry key using Sysinternals RegJump.
.DESCRIPTION
    Invoke-RegJump function allows you to jump directly to a specified registry key using the Sysinternals RegJump tool.
.PARAMETER LiteralPath
    Specifies the registry key to jump to. Must be provided in the form of a registry path.
.EXAMPLE
    Invoke-RegJump "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion"
.NOTES
    This function uses the Sysinternals RegJump tool. Download it from: https://learn.microsoft.com/sysinternals/downloads/regjump.
#>
function Invoke-RegJump {

    param (
        [Parameter(Mandatory)]
        [string] $LiteralPath
    )

    # Removes any "Registry::" or "Microsoft.Powershell.Core\Registry::" prefix, if present, from the path.
    $validRegistryPathForRegJump = $LiteralPath -replace "^.+::"

    & "$PSScriptRoot\regjump\regjump.exe" $validRegistryPathForRegJump
}
