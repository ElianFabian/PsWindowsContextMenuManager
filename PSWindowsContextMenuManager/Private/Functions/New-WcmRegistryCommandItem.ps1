function New-WcmRegistryCommandItem
{
    param
    (
        [string] $ItemPath,
        [string] $Name,
        [string] $IconPath,
        [string] $Command
    )

    $commandPath = "$ItemPath\Command"

    # Create command
    New-Item $commandPath > $null
    Write-Verbose "New item: $commandPath"

    # Set command name
    New-ItemProperty -LiteralPath $ItemPath -Name '(default)' -Value $Name > $null
    Write-Verbose "New item property: $ItemPath\(default) = ""$Name"""

    # Set command value
    New-ItemProperty -LiteralPath $commandPath -Name '(default)' -Value $Command > $null
    Write-Verbose "New item property: $commandPath\(default) = ""$Command"""

    if ($IconPath)
    {
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
}
