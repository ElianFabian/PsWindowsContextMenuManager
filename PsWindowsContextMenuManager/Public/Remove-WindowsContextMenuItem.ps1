function Remove-WindowsContextMenuItem {

    param (
        [Parameter(Mandatory)]
        [string] $LiteralKeyPath,

        [Parameter(Mandatory)]
        [ValidateSet('File', 'Directory', 'Desktop', 'Drive')]
        [string] $Type,

        [switch] $Recurse
    )
    
    $registryPath = ConvertTo-WindowsContextMenuRegistryPath -LiteralKeyPath $LiteralKeyPath -Type $Type -ErrorAction Stop

    $isCommandItem = Test-WindowsContextMenuCommandItem -LiteralKeyPath $LiteralKeyPath -Type $Type
    $isGroupItem = Test-WindowsContextMenuGroupItem   -LiteralKeyPath $LiteralKeyPath -Type $Type

    if ($isCommandItem) {
        Remove-Item -LiteralPath $registryPath -Recurse

        Write-Verbose "Remove item: path key: $LiteralKeyPath, type: $Type | registry path: '$registryPath'."
        return
    }
    if ($isGroupItem) {
        if ($Recurse) {
            Remove-Item -LiteralPath $registryPath -Recurse

            Write-Verbose "Remove item: KeyPath = '$LiteralKeyPath', Type = '$Type' | RegistryPath = '$registryPath'."
            return
        }
        else {
            $hasSubitems = (Get-WindowsContextMenuChildItem -LiteralKeyPath $LiteralKeyPath -Type $Type).Count -gt 0

            if ($hasSubitems) {
                Write-Error "The item at path key '$LiteralKeyPath' and type '$Type' with registry path: '$registryPath' has subitems. Use the -Recurse to remove the item and its subitems."
                return
            }
            else {
                Remove-Item -LiteralPath $registryPath -Recurse

                Write-Verbose "Remove item: KeyPath = '$LiteralKeyPath', Type = '$Type' | RegistryPath = '$registryPath'."
                return
            }
        }
        return
    }

    Write-Error "The item at path key '$LiteralKeyPath' and type '$Type' with registry path: '$registryPath' does not exist or it's not a valid context menu item."
}
