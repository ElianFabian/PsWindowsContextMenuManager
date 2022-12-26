function New-WcmRegistryGroupItem
{
    param
    (
        [string] $ItemPath,
        [string] $Name,
        [string] $IconPath
    )

    # Set group name (MUIVerb)
    New-ItemProperty -LiteralPath $ItemPath -Name $RegistryProperties.MUIVerb -Value $Name > $null
    Write-Verbose "New item property: $ItemPath\$($RegistryProperties.MUIVerb) = ""$Name""" -Verbose:$VerbosePreference

    # Allow subitems
    New-ItemProperty -LiteralPath $ItemPath -Name $RegistryProperties.Subcommands > $null
    Write-Verbose "New item property: $ItemPath\$($RegistryProperties.Subcommands)" -Verbose:$VerbosePreference

    # Create shell (container of subitems)
    New-Item -Path "$ItemPath/$($RegistryKeys.Shell)" > $null
    Write-Verbose "New shell item: $ItemPath\$($RegistryKeys.Shell)" -Verbose:$VerbosePreference
}