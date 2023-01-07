function Resolve-KeyPath([string] $KeyPath, [string] $ChildName = '')
{
    if ($KeyPath)
    {
        $path = ($KeyPath -replace '/', '\\' -split '\\'| ForEach-Object { "$_\$($RegistryKeys.Shell)\" } | Join-String)

        $path = $path.Remove($path.Length - 2 - $RegistryKeys.Shell.Length)

        if ($ChildName)
        {
             return "$path\$ChildName"
        }
        else { return $path }
    }
    else { return $KeyPath }
}
