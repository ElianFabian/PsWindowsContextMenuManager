function Add-IconProperty
{
    param
    (
        [Parameter(Mandatory=$true)] 
        [string] $ItemPath,

        [string] $IconPath
    )

    if ($IconPath -and -not $IconPath.EndsWith('.ico'))
    {
        Write-Warning "The given IconPath '$IconPath' it's not a .ico file. It won't be visible in the context menu."
    }

    $actualIconPath = $IconPath

    if (-not (Test-Path $actualIconPath))
    {
        Write-Warning "The icon '$actualIconPath' added to '$ItemPath' does not exist."
    }
    else { $actualIconPath = Resolve-Path $IconPath }

    # Set item icon
    New-ItemProperty -LiteralPath $ItemPath -Name Icon -Value $actualIconPath > $null
    Write-Verbose "New item property: $ItemPath\Icon = ""$actualIconPath"""
}
