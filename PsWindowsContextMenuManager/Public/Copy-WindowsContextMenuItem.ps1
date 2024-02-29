function Copy-WindowsContextMenuItem {

    [OutputType([PSCustomObject])]
    param (
        [Parameter(Mandatory)]
        [string] $LiteralKeyPath,

        [Parameter(Mandatory)]
        [ValidateSet('File', 'Directory', 'Desktop', 'Drive')]
        [string] $Type,

        [Parameter(Mandatory)]
        [string] $DestinationKeyPath,

        [Parameter(Mandatory)]
        [ValidateSet('File', 'Directory', 'Desktop', 'Drive')]
        [string] $DestinationType
    )

    $isCommandItem = Test-WindowsContextMenuCommandItem -LiteralKeyPath $LiteralKeyPath -Type $Type
    $isGroupItem = Test-WindowsContextMenuGroupItem -LiteralKeyPath $LiteralKeyPath -Type $Type

    if (-not ($isCommandItem -and $isGroupItem)) {
        Write-Error "The context menu item with key '$LiteralKeyPath' and type '$Type' does not exist."
        return $null
    }

    $registryPath = ConvertTo-WindowsContextMenuRegistryPath -LiteralKeyPath $LiteralKeyPath -Type $Type -ErrorAction Stop
    $destinationRegistryPath = ConvertTo-WindowsContextMenuRegistryPath -LiteralKeyPath $DestinationKeyPath -Type $DestinationType -ErrorAction Stop

    # TODO: Learn more about the behaviour of Copy-Item to propertly implement this function.
    Copy-Item -LiteralPath $registryPath -Destination $destinationRegistryPath -Recurse
}
