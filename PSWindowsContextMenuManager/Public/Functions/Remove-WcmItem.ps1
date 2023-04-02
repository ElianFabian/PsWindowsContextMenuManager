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
    
    $registryPath = Resolve-KeyPath -KeyPath $KeyPath -Type $Type

    $itemExists = Get-Item -LiteralPath $registryPath -ErrorAction Ignore
    if (-not $itemExists)
    {
        Write-Error "Cannot fin path '$registryPath' because it does not exist."
        return
    }

    Remove-Item -LiteralPath $registryPath -Recurse:$Recurse
    Write-Verbose "Remove item: '$registryPath'"
}
