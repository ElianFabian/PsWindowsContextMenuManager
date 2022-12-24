function New-WcmRootCommandItemObject
{
    [OutputType([IWcmRootCommandItem])]
    param(
        [Parameter(Mandatory=$true)]
        [string] $Key,

        [Parameter(Mandatory=$true)]
        [string] $Name,

        [Parameter(Mandatory=$true)]
        [ValidateSet('File', 'Directory', 'Desktop', 'Drive')]
        [string] $Type,

        [switch] $Extended = $false,

        [ValidateSet('Top', 'Bottom', '')]
        [string] $Position = '',

        [ValidatePattern('(.ico)$')]
        [string] $IconPath = '',

        [string] $Command
    )

    $newItem = [WcmRootCommandItem]::new()

    $newItem.Key      = $Key
    $newItem.Name     = $Name
    $newItem.IconPath = $IconPath
    $newItem.Command  = $Command
    $newItem.Type     = $Type
    $newItem.Position = $Position
    $newItem.Extended = $Extended ? $true : $false

    return $newItem
}
