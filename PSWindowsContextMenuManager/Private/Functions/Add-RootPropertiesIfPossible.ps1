function Add-RootPropertiesIfPossible(
    [string] $ItemPath,
    [switch] $Extended,
    [ValidateSet('Top', 'Bottom', '')]
    $Position
) {
    if ($Extended)
    {
        # Mark as extended (must hold Shift to make the option visible)
        New-ItemProperty -LiteralPath $ItemPath -Name $RegistryProperties.Extended > $null

        Write-Verbose "New item property: $ItemPath\$($RegistryProperties.Extended)" -Verbose:$VerbosePreference
    }
    if ($Position)
    {
        # Set the position (Top | Bottom)
        New-ItemProperty -LiteralPath $ItemPath -Name $RegistryProperties.Position -Value $Position > $null

        Write-Verbose "New item property: $ItemPath\$($RegistryProperties.Position) = ""$Position""" -Verbose:$VerbosePreference
    }
}
