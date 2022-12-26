class WcmItem
{
    [string] $Key
    [string] $Name
    [ValidatePattern('(\.ico|^$)$')]
    [string] $IconPath
    [ValidateSet('File', 'Directory', 'Desktop', 'Drive', '')]
    [string] $Type


    [bool] $Extended = $false
    [ValidateSet('Top', 'Bottom', '')]
    [string] $Position = ''
}

class WcmCommandItem : WcmItem
{
    [string] $Command
}

class WcmGroupItem : WcmItem
{
    [WcmItem[]] $Children
}
