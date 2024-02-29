function Set-WindowsContextMenuIconProperty {

    param (
        [Parameter(Mandatory)] 
        [string] $ItemPath,

        [string] $IconPath
    )


    if (-not $IconPath) {
        return
    }
    if (-not $IconPath.EndsWith('.ico')) {
        Write-Warning "The given IconPath '$IconPath' it's not a .ico file. It won't be visible in the context menu."
    }

    $actualIconPath = if (-not (Test-Path $IconPath)) {
        Write-Warning "The icon '$actualIconPath' added to '$ItemPath' does not exist."
        $IconPath
    }
    else { Resolve-Path $IconPath }

    New-ItemProperty -LiteralPath $ItemPath -Name Icon -Value $actualIconPath > $null
    Write-Verbose "New item property: $ItemPath\Icon = ""$actualIconPath"""
}
