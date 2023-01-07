function Remove-GroupItem
{
    param
    (
        [Parameter(Mandatory=$true)]
        [string] $ItemPath,

        [switch] $Recurse
    )

    Remove-Item -LiteralPath "$ItemPath\$($RegistryKeys.Shell)" -Recurse:$Recurse
    Remove-Item -LiteralPath $ItemPath

    Write-Verbose "Remove item: '$ItemPath\$($RegistryKeys.Shell)'" -Verbose:$VerbosePreference
    Write-Verbose "Remove item: '$ItemPath'" -Verbose:$VerbosePreference
}
