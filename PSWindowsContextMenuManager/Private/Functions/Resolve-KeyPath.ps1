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

        $path = $path.Remove($path.Length - 2 - 'Shell'.Length)

        if ($ChildName)
        {
             return "$typePath\$path\$ChildName"
        }
        else { return "$typePath\$path" }
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
