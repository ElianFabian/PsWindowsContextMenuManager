function Test-WcmItem
{
    param
    (
        [Parameter(Mandatory=$true)]
        [AllowEmptyString()]
        [string] $LiteralPathKey,

        [Parameter(Mandatory=$true)]
        [ValidateSet('File', 'Directory', 'Desktop', 'Drive')]
        [string] $Type
    )

    $isCommandItem = Test-WcmCommandItem -LiteralPathKey $LiteralPathKey -Type $Type
    $isGroupItem = Test-WcmGroupItem -LiteralPathKey $LiteralPathKey -Type $Type

    return ($isCommandItem -or $isGroupItem)
}