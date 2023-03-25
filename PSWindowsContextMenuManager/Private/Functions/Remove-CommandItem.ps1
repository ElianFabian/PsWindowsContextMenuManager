function Remove-CommandItem
{
    param
    (
        [Parameter(Mandatory=$true)]
        [string] $ItemPath
    )

    Remove-Item -LiteralPath $ItemPath -Recurse
    Write-Verbose "Remove item: '$ItemPath'"
}
