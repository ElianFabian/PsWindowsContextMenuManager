function Add-IconProperty
{
    param
    (
        [Parameter(Mandatory=$true)] 
        [string] $ItemPath,

        [ValidatePattern('(.ico|^$)$', ErrorMessage = "The given IconPath '{0}' must be a .ico file.")]
        [string] $IconPath
    )

    $actualIconPath = $IconPath

    if (-not (Test-Path $actualIconPath))
    {
        Write-Warning "The icon '$actualIconPath' added to '$ItemPath' does not exist."
    }
    else { $actualIconPath = Resolve-Path $IconPath }

    # Set item image
    New-ItemProperty -LiteralPath $ItemPath -Name Icon -Value $actualIconPath > $null
    Write-Verbose "New item property: $ItemPath\Icon = ""$actualIconPath"""
}
