function Remove-GroupItem
{
    param
    (
        [Parameter(Mandatory=$true)]
        [string] $ItemPath,

        [switch] $Recurse
    )

    Remove-Item -LiteralPath "$ItemPath\Shell" -Recurse:$Recurse
    Remove-Item -LiteralPath $ItemPath

    Write-Verbose "Remove item: '$ItemPath\Shell'"
    Write-Verbose "Remove item: '$ItemPath'"
}
