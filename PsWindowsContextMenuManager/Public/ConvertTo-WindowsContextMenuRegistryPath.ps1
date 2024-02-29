function ConvertTo-WindowsContextMenuRegistryPath {

    [OutputType([string])]
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
        [string] $Type
    )

    # TODO: think about if it actually makes sense to do any validation in here or just do the conversion.

    process {
        if ($PSCmdlet.ParameterSetName -eq "Default") {
            return Get-WindowsContextMenuTypeRegistryPath -Type $Type
        }

        foreach ($keyPath in $LiteralKeyPath) {
            $typeRegistryPath = Get-WindowsContextMenuTypeRegistryPath -Type $Type

            $trimmedLiteralKeyPath = $keyPath.Trim('\').Trim('/')

            $registryPath = if ($trimmedLiteralKeyPath) {
                "$typeRegistryPath\Shell\$($trimmedLiteralKeyPath -replace '(\\|\/)','\Shell\')"
            } else {
                $typeRegistryPath
            }

            if (-not (Test-Path -LiteralPath $registryPath)) {
                Write-Error "The context menu item with key '$keyPath' and type '$Type' does not exist. Registry path: '$registryPath'."
            } 
            else {
                $registryItem = Get-Item -LiteralPath $registryPath

                $isCommandItem = $null -ne $registryItem.OpenSubKey('Command')
                $isGroupItem = $null -ne $registryItem.GetValue('Subcommands') -and $null -ne $registryItem.OpenSubKey('Shell')
    
                $isContextMenuItem = $isGroupItem -or $isCommandItem
    
                if (-not $isContextMenuItem) {
                    Write-Error "The context menu item with key '$LiteralKeyPath' and type '$Type' it's not a valid context menu item. Registry path: '$registryPath'."
                } else {
                    $registryPath
                }
            }
        }
    }
}

