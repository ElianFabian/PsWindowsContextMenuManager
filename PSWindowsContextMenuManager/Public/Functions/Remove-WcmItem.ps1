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
    
    $registryPath = Resolve-PathKey -LiteralPathKey $LiteralPathKey -Type $Type -ErrorAction Stop

    $isCommandItem = Test-WcmCommandItem -LiteralPathKey $LiteralPathKey -Type $Type

    if ($isCommandItem)
    {
        Remove-Item -LiteralPath $registryPath -Recurse
        return
    }

    Remove-Item -LiteralPath $registryPath -Recurse:$Recurse
    
    Write-Verbose "Remove item: '$registryPath'"
}
