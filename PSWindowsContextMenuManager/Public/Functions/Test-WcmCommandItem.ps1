function Test-WcmCommandItem
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

    $registryPath = Resolve-PathKey -LiteralPathKey $LiteralPathKey -Type $Type

    [Microsoft.Win32.RegistryKey]`
    $registryItem = Get-Item -LiteralPath $registryPath -ErrorAction Ignore

    $childName = $registryItem.GetSubKeyNames()[0]

    $isGroupItem = ('Subcommands' -in $registryItem.Property) -and ($childName -eq 'Shell')
    $isCommandItem = ($childName -eq 'Command') -and (-not $isGroupItem)

    return $isCommandItem
}