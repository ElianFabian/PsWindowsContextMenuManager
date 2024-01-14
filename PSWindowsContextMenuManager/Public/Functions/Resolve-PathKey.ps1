function Resolve-PathKey
{
    param
    (
        [string] $LiteralPathKey = '',

        [Parameter(Mandatory=$true)]
        [ValidateSet('File', 'Directory', 'Desktop', 'Drive')]
        [string] $Type
    )

    $typeRegistryPath = Get-TypeRegistryPath -Type $Type

    if (-not $LiteralPathKey)
    {
        return $typeRegistryPath
    }
   
    $trimmedLiteralPathKey = $LiteralPathKey.Trim('\').Trim('/')

    $registryPath = if ($trimmedLiteralPathKey)
    {
        $path = ($trimmedLiteralPathKey -replace '/', '\' -split '\\'| ForEach-Object { "$_\Shell\" } | Join-String)
        $pathWithoutPendingShell = $path.Remove($path.Length - 2 - 'Shell'.Length)

        "$typeRegistryPath\Shell\$pathWithoutPendingShell" 
    }
    else { "$typeRegistryPath\Shell" }

    if (-not (Test-Path -LiteralPath $registryPath))
    {
        Write-Error "The context menu item with key '$LiteralPathKey' and type '$Type' does not exist. Full registry path: '$registryPath'."
        return $null
    }

    return $registryPath
}
