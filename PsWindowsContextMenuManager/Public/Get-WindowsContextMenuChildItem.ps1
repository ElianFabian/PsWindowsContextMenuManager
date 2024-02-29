function Get-WindowsContextMenuChildItem {

    [OutputType([PSCustomObject])]
    [CmdletBinding(DefaultParameterSetName = "Default")]
    param (
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            ParameterSetName = "KeyPath"
        )]
        [string[]] $LiteralKeyPath,

        [Parameter(Mandatory)]
        [ValidateSet('File', 'Directory', 'Desktop', 'Drive')]
        [string] $Type,

        [switch] $Recurse,

        [uint] $Depth = 0
    )

    process {
        if (-not $LiteralKeyPath) {
            return GetWindowsContextMenuChildItemInternal -Type $Type -Recurse:$Recurse -Depth $Depth
        }
        if (Test-WindowsContextMenuCommandItem -LiteralKeyPath $LiteralKeyPath -Type $Type) {
            return Get-WindowsContextMenuItem -LiteralKeyPath $LiteralKeyPath -Type $Type
        }

        foreach ($keyPath in $LiteralKeyPath) {
            GetWindowsContextMenuChildItemInternal -LiteralKeyPath $keyPath -Type $Type -Recurse:$Recurse -Depth $Depth
        }
    }
}

function GetWindowsContextMenuChildItemInternal {

    [OutputType([PSCustomObject[]])]
    param (
        [string] $LiteralKeyPath = '',

        [Parameter(Mandatory)]
        [ValidateSet('File', 'Directory', 'Desktop', 'Drive')]
        [string] $Type,

        [switch] $Recurse,

        [uint] $Depth = 0
    )

    $registryPath = if ($LiteralKeyPath) {
        ConvertTo-WindowsContextMenuRegistryPath -LiteralKeyPath $LiteralKeyPath -Type $Type -ErrorAction Ignore
    }
    else {
        ConvertTo-WindowsContextMenuRegistryPath -Type $Type -ErrorAction Ignore
    }

    $registryChildItems = Get-ChildItem -LiteralPath "$registryPath\Shell" -ErrorAction Ignore

    foreach ($childItem in $registryChildItems) {
        $literalChildKeyPath = if ($LiteralKeyPath) {
            "$LiteralKeyPath\$($childItem.PSChildName)"
        }
        else { $childItem.PSChildName }

        $isGroupItem = Test-WindowsContextMenuGroupItem -LiteralKeyPath $literalChildKeyPath -Type $Type
        $isCommandItem = Test-WindowsContextMenuCommandItem -LiteralKeyPath $literalChildKeyPath -Type $Type

        if ($isGroupItem) {
            $items = if ($Recurse -or $Depth -gt 0) {
                Get-WindowsContextMenuChildItem -LiteralKeyPath $literalChildKeyPath -Type $Type -Recurse:$Recurse -Depth ([math]::Max($Depth - 1, 0))
            }
            else { [array]::Empty[PSCustomObject]() }

            $currentItem = Get-WindowsContextMenuItem -LiteralKeyPath $literalChildKeyPath -Type $Type

            $currentItem
            $items
        }
        elseif ($isCommandItem) {
            Get-WindowsContextMenuItem -LiteralKeyPath $literalChildKeyPath -Type $Type
        }
    }
}