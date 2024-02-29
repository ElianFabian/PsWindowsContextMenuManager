function Invoke-WindowsContextMenuItem {

    param (
        [Parameter(Mandatory=$true)]
        [string] $LiteralKeyPath,

        [Parameter(Mandatory=$true)]
        [ValidateSet('File', 'Directory', 'Desktop', 'Drive')]
        [string] $Type
    )

    $registryPath = ConvertTo-WindowsContextMenuRegistryPath -LiteralKeyPath $LiteralKeyPath -Type $Type
    
    Invoke-RegJump -LiteralPath $registryPath
}
