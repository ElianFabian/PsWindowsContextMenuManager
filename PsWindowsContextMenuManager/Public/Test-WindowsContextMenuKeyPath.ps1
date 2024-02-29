function Test-WindowsContextMenuKeyPath {

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
            $registryPath = ConvertTo-WindowsContextMenuRegistryPath -LiteralKeyPath $LiteralKeyPath -Type $Type -ErrorAction Ignore

            $null -ne $registryPath
        }
    }
}
