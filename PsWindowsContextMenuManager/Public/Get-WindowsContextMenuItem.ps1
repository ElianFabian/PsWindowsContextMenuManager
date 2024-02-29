function Get-WindowsContextMenuItem {

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            ParameterSetName = "LiteralPath"
        )]
        [string[]] $LiteralKeyPath,

        [Parameter(Mandatory)]
        [ValidateSet('File', 'Directory', 'Desktop', 'Drive')]
        [string] $Type
    )

    process {
        foreach ($keyPath in $LiteralKeyPath) {
            $registryPath = ConvertTo-WindowsContextMenuRegistryPath -LiteralKeyPath $keyPath -Type $Type -ErrorAction Stop

            $registryItem = [Microsoft.Win32.RegistryKey] (Get-Item -LiteralPath $registryPath -ErrorAction Ignore)
    
            $isGroupItem = Test-WindowsContextMenuGroupItem -LiteralKeyPath $keyPath -Type $Type
            $isCommandItem = Test-WindowsContextMenuCommandItem -LiteralKeyPath $keyPath -Type $Type
    
            $itemType = if ($isGroupItem) {
                'Group'
            }
            elseif ($isCommandItem) {
                'Command'
            }
            else {
                Write-Error "The context menu item with key '$keyPath' and type '$Type' does not exist. Registry path: '$registryPath'."
                return $null
            }
    
            $wcmItem = [PSCustomObject] @{
                Key          = $registryItem.PSChildName
                KeyPath      = $keyPath
                # It's not strictly necessary to remove it, but it makes it look cleaner
                RegistryPath = $registryItem.PSPath.Replace('Microsoft.PowerShell.Core\', '')
                Type         = $Type
                IconPath     = $registryItem.GetValue('Icon')
                Position     = $registryItem.GetValue('Position')
                IsExtended   = $null -ne $registryItem.GetValue('Extended')
            }
    
            switch ($itemType) {
                Command {
                    $wcmItem
                    | Add-Member -Name Name    -Value $registryItem.GetValue('')                                   -MemberType NoteProperty -PassThru
                    | Add-Member -Name Command -Value (Get-Item -LiteralPath "$registryPath\Command").GetValue('') -MemberType NoteProperty
                }
                Group {
                    $wcmItem
                    | Add-Member -Name Name       -Value $registryItem.GetValue('MUIVerb')                         -MemberType NoteProperty -PassThru
                    | Add-Member -Name ChildCount -Value (Get-Item -LiteralPath "$registryPath\Shell").SubKeyCount -MemberType NoteProperty
                }
            }
    
            $wcmItem
        }
    }
}
