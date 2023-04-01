function Resolve-KeyPath
{
    param
    (
        [Parameter(Mandatory=$true)]
        [AllowEmptyString()]
        [string] $KeyPath,

        [Parameter(Mandatory=$true)]
        [ValidateSet('File', 'Directory', 'Desktop', 'Drive')]
        [string] $Type,

        [string] $ChildName = ''
    ) 

    $typePath = $ContextMenuPathType.$Type

    $trimmedKeyPath = $KeyPath.Trim('\').Trim('/')

    if ($trimmedKeyPath)
    {
        $path = ($trimmedKeyPath -replace '/', '\\' -split '\\'| ForEach-Object { "$_\Shell\" } | Join-String)
        $pathWithoutPendingShell = $path.Remove($path.Length - 2 - 'Shell'.Length)

        if ($ChildName)
        {
             return "$typePath\$pathWithoutPendingShell\$ChildName"
        }
        else { return "$typePath\$pathWithoutPendingShell" }
    }
    else { return $typePath }
}



$BasePath = "Registry::HKEY_CLASSES_ROOT"

$ContextMenuPathType =
@{
    File      = "$BasePath\*\shell"
    Directory = "$BasePath\Directory\shell"
    Desktop   = "$BasePath\Directory\background\shell"
    Drive     = "$BasePath\Drive\shell"
}
