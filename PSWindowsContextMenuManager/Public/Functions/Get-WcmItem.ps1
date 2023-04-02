function Get-WcmItem
{
    [OutputType([PSCustomObject])]
    param
    (
        [Parameter(Mandatory=$true)]
        [string] $LiteralPathKey,

        [Parameter(Mandatory=$true)]
        [ValidateSet('File', 'Directory', 'Desktop', 'Drive')]
        [string] $Type,

        [switch] $Copy
    )

    if ($Copy)
    {
        return Get-WcmItemCopy -LiteralPathKey $LiteralPathKey -Type $Type
    }
    else
    {
        return Get-WcmItemReference -LiteralPathKey $LiteralPathKey -Type $Type
    }
}
