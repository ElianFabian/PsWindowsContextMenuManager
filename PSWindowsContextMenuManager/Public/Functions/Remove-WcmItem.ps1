function Remove-WcmItem
{
    param
    (
        [Parameter(Mandatory=$true)]
        [string] $LiteralPathKey,

        [Parameter(Mandatory=$true)]
        [ValidateSet('File', 'Directory', 'Desktop', 'Drive')]
        [string] $Type,

        [switch] $Recurse
    )
    
    $registryPath = Resolve-PathKey -LiteralPathKey $LiteralPathKey -Type $Type

    $itemExists = Get-Item -LiteralPath $registryPath -ErrorAction Ignore
    if (-not $itemExists)
    {
        Write-Error "Cannot find context menu item with key '$LiteralPathKey' and type '$Type' because it does not exist. Full path: '$registryPath'."
        return
    }

    Remove-Item -LiteralPath $registryPath -Recurse:$Recurse
    Write-Verbose "Remove item: '$registryPath'"
}
