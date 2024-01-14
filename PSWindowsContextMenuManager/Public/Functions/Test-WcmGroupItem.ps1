function Test-WcmGroupItem
{
    param
    (
        [Parameter(Mandatory=$true)]
        [AllowEmptyString()]
        [string] $LiteralPathKey,

        [Parameter(Mandatory=$true)]
        [ValidateSet('File', 'Directory', 'Desktop', 'Drive')]
        [string] $Type
    )

    $registryPath = Resolve-PathKey -LiteralPathKey $LiteralPathKey -Type $Type -ErrorAction Ignore

    if (-not $registryPath)
    {
        return $false
    }

    [Microsoft.Win32.RegistryKey]`
    $registryItem = Get-Item -LiteralPath $registryPath -ErrorAction Ignore

    $isGroupItem = ('Subcommands' -in $registryItem.Property) -and ('Shell' -in $registryItem.GetSubKeyNames())

    return $isGroupItem
}
