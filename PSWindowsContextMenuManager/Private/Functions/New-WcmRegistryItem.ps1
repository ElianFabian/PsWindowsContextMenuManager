function New-WcmRegistryItem
{
    param
    (
        [string] $ItemPath,
        [string] $Name,
        [string] $IconPath,
        [string] $Command
    )

    # Create command
    $commandPath = (New-Item -Path $ItemPath -Name $RegistryKeys.Command).PSPath
    Write-Verbose "New command item: $commandPath" -Verbose:$VerbosePreference

    # Set command name
    New-ItemProperty -Path $ItemPath -Name $RegistryProperties.Default -Value $Name > $null
    Write-Verbose "New item property: $ItemPath\$($RegistryProperties.Default) = ""$Name""" -Verbose:$VerbosePreference

    # Set command value
    New-ItemProperty -LiteralPath $commandPath -Name  $RegistryProperties.Default -Value $Command > $null
    Write-Verbose "New item property: $commandPath\$($RegistryProperties.Default) = ""$Command""" -Verbose:$VerbosePreference

    if ($IconPath)
    {
        $actualIconPath = $IconPath

        if (-not (Test-Path $actualIconPath))
        {
            Write-Warning "The icon '$actualIconPath' does not exist."
        }
        else { $actualIconPath = Resolve-Path $IconPath }

        # Set item image
        New-ItemProperty -Path $ItemPath -Name $RegistryProperties.Icon -Value $actualIconPath > $null
        Write-Verbose "New item property: $ItemPath\$($RegistryProperties.Icon) = $actualIconPath" -Verbose:$VerbosePreference
    }
}
