function Add-RootPropertiesIfPossible(
    [string] $ItemPath,
    [switch] $Extended,
    [ValidateSet('Top', 'Bottom', '')]
    $Position
) {
    if ($Extended -eq $true)
    {
        # Mark as extended (must hold Shift to make the option visible)
        New-ItemProperty -Path $ItemPath -Name $RegistryProperties.Extended > $null

        Write-Verbose "New item property: $ItemPath\$($RegistryProperties.Extended)" -Verbose:$VerbosePreference
    }
    if ($Position)
    {
        # Set the position of the item (Top | Bottom)
        New-ItemProperty -Path $ItemPath -Name $RegistryProperties.Position -Value $Position > $null

        Write-Verbose "New item property: $ItemPath\$($RegistryProperties.Position) = '$Position'" -Verbose:$VerbosePreference
    }
}
