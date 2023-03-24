function New-WcmItemObject
{
    [OutputType([PSCustomObject])]
    param
    (
        [Parameter(Mandatory=$true)]
        [string] $Key,

        [Parameter(Mandatory=$true)]
        [string] $Name,

        [ValidatePattern('(.ico|^$)$', ErrorMessage = "The given IconPath '{0}' must be a .ico file.")]
        [string] $IconPath = '',

        [ValidateSet('File', 'Directory', 'Desktop', 'Drive', '')]
        [string] $Type = '',

        [switch] $Extended = $false,

        [ValidateSet('Top', 'Bottom', '')]
        [string] $Position = '',

        [Parameter(ParameterSetName='Command')]
        [string] $Command,

        [Parameter(ParameterSetName='Group')]
        [PSCustomObject[]] $ChildItem
    )

    $newItem = [PSCustomObject]@{
        Key      = $Key
        Name     = $Name
        Extended = $Extended ? $true : $false
    }

    switch ($PSCmdlet.ParameterSetName)
    {
        Command { $newItem | Add-Member -Name Command  -Value $Command   -MemberType NoteProperty }
        Group   { $newItem | Add-Member -Name Children -Value $ChildItem -MemberType NoteProperty }
    }
    if ($Type)     { $newItem | Add-Member -Name Type     -Value $Type     -MemberType NoteProperty }
    if ($IconPath) { $newItem | Add-Member -Name IconPath -Value $IconPath -MemberType NoteProperty }
    if ($Position) { $newItem | Add-Member -Name Position -Value $Position -MemberType NoteProperty }
    if ($Extended) { $newItem | Add-Member -Name Extended -Value $Extended -MemberType NoteProperty }

    return $newItem
}
