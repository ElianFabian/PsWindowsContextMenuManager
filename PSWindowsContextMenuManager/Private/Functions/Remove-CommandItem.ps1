function Remove-CommandItem
{
    param
    (
        [Parameter(Mandatory=$true)]
        [string] $ItemPath
    )

    Remove-Item -LiteralPath "$ItemPath\$($RegistryKeys.Command)"
    Remove-Item -LiteralPath $ItemPath

    Write-Verbose "Remove item: '$ItemPath\$($RegistryKeys.Command)'"
    Write-Verbose "Remove item: '$ItemPath'"
}
