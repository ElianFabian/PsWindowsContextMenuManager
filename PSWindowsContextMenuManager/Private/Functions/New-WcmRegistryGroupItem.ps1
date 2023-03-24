function New-WcmRegistryGroupItem
{
    param
    (
        [string] $ItemPath,
        [string] $Name,
        [string] $IconPath
    )

    # Set group name (MUIVerb)
    New-ItemProperty -LiteralPath $ItemPath -Name MUIVerb -Value $Name > $null
    Write-Verbose "New item property: $ItemPath\MUIVerb = ""$Name"""

    # Allow subitems
    New-ItemProperty -LiteralPath $ItemPath -Name Subcommands > $null
    Write-Verbose "New item property: $ItemPath\Subcommands"

    # Create shell (container of subitems)
    New-Item -Path "$ItemPath\Shell" > $null
    Write-Verbose "New item: $ItemPath\Shell"
}