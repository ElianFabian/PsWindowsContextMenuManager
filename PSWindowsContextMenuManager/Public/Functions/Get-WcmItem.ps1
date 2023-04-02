function Get-WcmItem
{
    [OutputType([PSCustomObject])]
    param
    (
        [Parameter(Mandatory=$true)]
        [string] $KeyPath,

        [Parameter(Mandatory=$true)]
        [ValidateSet('File', 'Directory', 'Desktop', 'Drive')]
        [string] $Type,

        [switch] $Copy
    )

    if ($Copy)
    {
        return Get-WcmItemCopy -KeyPath $KeyPath -Type $Type
    }
    else
    {
        return Get-WcmItemReference -KeyPath $KeyPath -Type $Type
    }
}
