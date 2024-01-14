function Test-PathKey
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

    $registryPath = Resolve-PathKey -LiteralPathKey $LiteralPathKey -Type $Type -ErrorAction Ignore

    if (-not $registryPath)
    {
        return $false
    }

    return Test-Path -LiteralPath $registryPath
}
