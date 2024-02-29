function Test-WindowsContextMenuCommandItem {

    [OutputType([bool])]
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory,
            ValueFromPipeline
        )]
        [string[]] $LiteralKeyPath,

        [Parameter(Mandatory)]
        [ValidateSet('File', 'Directory', 'Desktop', 'Drive')]
        [string] $Type
    )

    process {
        foreach ($keyPath in $LiteralKeyPath) {
            $registryPath = ConvertTo-WindowsContextMenuRegistryPath -LiteralKeyPath $keyPath -Type $Type -ErrorAction Ignore

            if (-not $registryPath) {
                $false
            }
            else {
                $registryItem = [Microsoft.Win32.RegistryKey] (Get-Item -LiteralPath $registryPath -ErrorAction Ignore)
    
                $isCommandItem = $null -ne $registryItem.OpenSubKey('Command')
        
                $isCommandItem
            }
        }
    }
}
