function Remove-CommandItem
{
    param
    (
        [Parameter(Mandatory=$true)]
        [string] $ItemPath
    )

    Remove-Item -LiteralPath "$ItemPath\Command"
    Remove-Item -LiteralPath $ItemPath

    Write-Verbose "Remove item: '$ItemPath\Command'"
    Write-Verbose "Remove item: '$ItemPath'"
}
