function New-WcmItemObject
{
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
        [WcmItem[]] $ChildItem
    )

    switch ($PSCmdlet.ParameterSetName)
    {
        Command
        {
            $newItem = [WcmCommandItem]::new()

            $newItem.Key      = $Key
            $newItem.Name     = $Name
            $newItem.IconPath = $IconPath
            $newItem.Type     = $Type
            $newItem.Command  = $Command

            $newItem.Position = $Position
            $newItem.Extended = $Extended ? $true : $false

            return $newItem
        }
        Group
        {
            $newItem = [WcmGroupItem]::new()

            $newItem.Key      = $Key
            $newItem.Name     = $Name
            $newItem.IconPath = $IconPath
            $newItem.Type     = $Type
            $newItem.Children = $ChildItem

            $newItem.Position = $Position
            $newItem.Extended = $Extended ? $true : $false

            return $newItem
        }
    }
}
