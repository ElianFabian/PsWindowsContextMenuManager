function Get-WcmChildItem
{
    param
    (
        [string] $LiteralPathKey = '',

        [Parameter(Mandatory=$true)]
        [ValidateSet('File', 'Directory', 'Desktop', 'Drive')]
        [string] $Type,

        [switch] $Recurse,

        [uint] $Depth = 0
    )

    if (Test-WcmCommandItem -LiteralPathKey $LiteralPathKey -Type $Type)
    {
        return Get-WcmItem -LiteralPathKey $LiteralPathKey -Type $Type
    }

    $registryPath = Resolve-PathKey -LiteralPathKey $LiteralPathKey -Type $Type -ErrorAction

    $registryChildItems = Get-ChildItem -LiteralPath "$registryPath\Shell" -ErrorAction Ignore

    $childItems = foreach ($childItem in $registryChildItems)
    {
        $literalChildPathKey = "$LiteralPathKey\$($childItem.PSChildName)"

        $isGroupItem = Test-WcmGroupItem -LiteralPathKey $literalChildPathKey -Type $Type
        $isCommandItem = Test-WcmCommandItem -LiteralPathKey $literalChildPathKey -Type $Type

        if (($Depth -gt 0 -or $Recurse) -and $isGroupItem)
        {
           Get-WcmChildItem -LiteralPathKey $literalChildPathKey -Type $Type -Recurse:$Recurse -Depth ([math]::Max($Depth - 1, 0))
        }
        elseif ($isCommandItem)
        {
            Get-WcmItem -LiteralPathKey $literalChildPathKey -Type $Type
        }
    }

    $currentItem = if ($LiteralPathKey)
    {
        Get-WcmItem -LiteralPathKey $LiteralPathKey -Type $Type
    }

    return @($currentItem) + $childItems
}
