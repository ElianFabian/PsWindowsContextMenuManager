function Remove-WcmItem
{
    param
    (
        [Parameter(Mandatory=$true)]
        [string] $KeyPath,

        [Parameter(Mandatory=$true)]
        [ValidateSet('File', 'Directory', 'Desktop', 'Drive')]
        [string] $Type,

        [switch] $Recurse
    )
    
    $actualPath = Resolve-KeyPath -KeyPath $KeyPath -Type $Type

    $itemExists = Get-Item -LiteralPath $actualPath -ErrorAction Ignore
    if (-not $itemExists)
    {
        Write-Error "Cannot fin path '$actualPath' because it does not exist."
        return
    }

    Remove-Item -LiteralPath $actualPath -Recurse:$Recurse
    Write-Verbose "Remove item: '$actualPath'"
}
