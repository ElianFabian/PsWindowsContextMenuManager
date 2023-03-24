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

    Add-IconProperty -ItemPath $ItemPath -IconPath $IconPath
}
