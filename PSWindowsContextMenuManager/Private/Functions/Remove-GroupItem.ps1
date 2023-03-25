function Remove-GroupItem
{
    param
    (
        [Parameter(Mandatory=$true)]
        [string] $ItemPath,

        [switch] $Recurse
    )

    Remove-Item -LiteralPath $ItemPath -Recurse:$Recurse
    Write-Verbose "Remove item: '$ItemPath'"
}
