function New-WcmRegistryCommandItem
{
    param
    (
        [string] $ItemPath,
        [string] $Name,
        [string] $IconPath,
        [string] $Command
    )

    $commandPath = "$ItemPath\$($RegistryKeys.Command)"

    # Create command
    New-Item $commandPath > $null
    Write-Verbose "New item: $commandPath" -Verbose:$VerbosePreference

    # Set command name
    New-ItemProperty -LiteralPath $ItemPath -Name $RegistryProperties.Default -Value $Name > $null
    Write-Verbose "New item property: $ItemPath\$($RegistryProperties.Default) = ""$Name""" -Verbose:$VerbosePreference

    # Set command value
    New-ItemProperty -LiteralPath $commandPath -Name  $RegistryProperties.Default -Value $Command > $null
    Write-Verbose "New item property: $commandPath\$($RegistryProperties.Default) = ""$Command""" -Verbose:$VerbosePreference

    if ($IconPath)
    {
        $actualIconPath = $IconPath

        if (-not (Test-Path $actualIconPath))
        {
            Write-Warning "The icon '$actualIconPath' added to '$ItemPath' does not exist."
        }
        else { $actualIconPath = Resolve-Path $IconPath }

        # Set item image
        New-ItemProperty -LiteralPath $ItemPath -Name $RegistryProperties.Icon -Value $actualIconPath > $null
        Write-Verbose "New item property: $ItemPath\$($RegistryProperties.Icon) = ""$actualIconPath""" -Verbose:$VerbosePreference
    }
}
