function New-WcmItemObject
{
    [OutputType([PSCustomObject])]
    param
    (
        [Parameter(Mandatory=$true)]
        [string] $Key,

        [Parameter(Mandatory=$true)]
        [string] $Name,

        [Parameter(Mandatory=$true)]
        [string] $RegistryPath,

        [ValidateSet('Command', 'Group')]
        [string] $ItemType = 'Command',

        [ValidatePattern('(.ico|^$)$', ErrorMessage = "The given IconPath '{0}' must be a .ico file.")]
        [string] $IconPath = '',

        [ValidateSet('File', 'Directory', 'Desktop', 'Drive', '')]
        [string] $Type = '',

        [switch] $Extended = $false,

        [ValidateSet('Top', 'Bottom', '')]
        [string] $Position = '',

        [string] $Command,

        [bool] $IsRootItem
    )

    $newItem = [PSCustomObject]@{
        Key          = $Key
        Name         = $Name
        RegistryPath = $RegistryPath
    }

    if ($IsRootItem)
    {
        if ($Position) { $newItem | Add-Member -Name Position -Value $Position -MemberType NoteProperty }
        if ($Extended) { $newItem | Add-Member -Name Extended -Value $Extended -MemberType NoteProperty }
    }
    if ($ItemType -eq 'Command')
    {
        $newItem | Add-Member -Name Command -Value $Command -MemberType NoteProperty
    }
    if ($Type)     { $newItem | Add-Member -Name Type     -Value $Type     -MemberType NoteProperty }
    if ($IconPath) { $newItem | Add-Member -Name IconPath -Value $IconPath -MemberType NoteProperty }

    return $newItem
}
