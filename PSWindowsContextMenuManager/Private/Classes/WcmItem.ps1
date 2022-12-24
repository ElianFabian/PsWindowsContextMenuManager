class WcmItem : IWcmItem
{
    [string] $Key
    [string] $Name
    [ValidatePattern('(.ico|)$')]
    [string] $IconPath
}

class WcmRootItem : WcmItem, IWcmRootItem
{
    [ValidateSet('File', 'Directory', 'Desktop', 'Drive')]
    [string] $Type
    [bool]   $Extended = $false
    [ValidateSet('Top', 'Bottom', '')]
    [string] $Position = ''
}

class WcmRootCommandItem : WcmRootItem, IWcmRootCommandItem
{
    [string] $Command
}
class WcmSubCommandItem : WcmItem, IWcmSubCommandItem
{
    [string] $Command
}

class WcmRootGroupItem : WcmRootItem, IWcmGroupItem
{
    [IWcmItem[]] $Children
}
class WcmSubGroupItem : WcmItem, IWcmGroupItem
{
    [IWcmItem[]] $Children
}