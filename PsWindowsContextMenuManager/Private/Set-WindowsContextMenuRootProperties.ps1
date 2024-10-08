function Set-WindowsContextMenuRootProperties {

    param (
        [Parameter(Mandatory)]
        [string] $ItemPath,

        [switch] $Extended,

        [ValidateSet('Top', 'Bottom', '')]
        [string] $Position = ''
    )

    if ($Extended) {
        # Mark as extended (must hold Shift to make the item visible in the context menu)
        New-ItemProperty -LiteralPath $ItemPath -Name Extended > $null
        Write-Verbose "New item property: $ItemPath\Extended"
    }
    if ($Position) {
        # Set the position (Top | Bottom)
        New-ItemProperty -LiteralPath $ItemPath -Name Position -Value $Position > $null
        Write-Verbose "New item property: $ItemPath\Position = ""$Position"""
    }
}
