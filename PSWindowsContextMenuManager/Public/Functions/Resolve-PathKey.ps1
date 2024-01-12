function Resolve-PathKey
{
    param
    (
        [Parameter(Mandatory=$true)]
        [AllowEmptyString()]
        [string] $LiteralPathKey,

        [Parameter(Mandatory=$true)]
        [ValidateSet('File', 'Directory', 'Desktop', 'Drive')]
        [string] $Type,

        [string] $ChildName = ''
    ) 

    $typePath = $ContextMenuPathType.$Type

    $trimmedLiteralPathKey = $LiteralPathKey.Trim('\').Trim('/')

    $registryPath = if ($trimmedLiteralPathKey)
    {
        $path = ($trimmedLiteralPathKey -replace '/', '\\' -split '\\'| ForEach-Object { "$_\Shell\" } | Join-String)
        $pathWithoutPendingShell = $path.Remove($path.Length - 2 - 'Shell'.Length)

        if ($ChildName)
        {
             "$typePath\$pathWithoutPendingShell\$ChildName"
        }
        else { "$typePath\$pathWithoutPendingShell" }
    }
    else { $typePath }

    if (-not (Test-Path -LiteralPath $registryPath))
    {
        Write-Error "The context menu item with key '$LiteralPathKey' and type '$Type' does not exist. Full path: '$registryPath'."
        return $null
    }

    return $registryPath
}



$BasePath = "Microsoft.PowerShell.Core\Registry::HKEY_CLASSES_ROOT"

$ContextMenuPathType =
@{
    File      = "$BasePath\*\shell"
    Directory = "$BasePath\Directory\shell"
    Desktop   = "$BasePath\Directory\background\shell"
    Drive     = "$BasePath\Drive\shell"
}
