function New-WindowsContextMenuItem {

    [OutputType([PSCustomObject])]
    [CmdletBinding(DefaultParameterSetName = 'Root-Item')]
    param (
        [Parameter(Mandatory)]
        [string] $Key,

        [Parameter(Mandatory)]
        [string] $Name,

        [ValidateSet('Command', 'Group')]
        [string] $ItemType = 'Command',

        [string] $IconPath = '',

        [Parameter(Mandatory)]
        [ValidateSet('File', 'Directory', 'Desktop', 'Drive')]
        [string] $Type,

        [Parameter(ParameterSetName = 'Root-Item')]
        [switch] $Extended,

        [Parameter(ParameterSetName = 'Root-Item')]
        [ValidateSet('Top', 'Bottom', '')]
        [string] $Position = '',

        [Parameter(ParameterSetName = 'Sub-Item')]
        [string] $ParentLiteralKeyPath = '',

        [string] $Command
    )

    process {
        # TODO: convert this function to an advanced function
    }

    $registryParentPath = ConvertTo-WindowsContextMenuRegistryPath -LiteralKeyPath $ParentLiteralKeyPath -Type $Type

    if (-not (Test-Path -LiteralPath $registryParentPath)) {
        Write-Error "The path key '$ParentLiteralKeyPath\$Key' does not exist. Registry path: '$registryParentPath'."
        return
    }

    $itemPath = "$registryParentPath\Shell\$Key"

    New-Item $itemPath -ErrorAction SilentlyContinue -ErrorVariable outErrorMessage > $null
    Write-Verbose "New item: $itemPath"

    switch ($outErrorMessage) {
        'A key in this path already exists.' {
            Write-Error "The path key '$ParentLiteralKeyPath\$Key' already exists. Registry path: '$itemPath'."
            return
        }
    }

    switch ($ItemType) {
        Command {
            New-WindowsContextMenuRegistryCommandItem -ItemPath $itemPath -Name $Name -IconPath $IconPath -Command $Command
        }
        Group {
            New-WindowsContextMenuRegistryGroupItem -ItemPath $itemPath -Name $Name -IconPath $IconPath
        }
    }

    Set-WindowsContextMenuRootProperties -ItemPath $itemPath -Extended:$Extended -Position $Position

    return Get-WindowsContextMenuItem -LiteralKeyPath ($ParentLiteralKeyPath ? "$ParentLiteralKeyPath\$Key" : $Key) -Type $Type
}
