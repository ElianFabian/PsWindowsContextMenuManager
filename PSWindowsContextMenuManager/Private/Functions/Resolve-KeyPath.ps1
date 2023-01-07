function Resolve-KeyPath([string] $KeyPath)
{
    if ($KeyPath)
    {
        $path = ($KeyPath -replace '/', '\\' -split '\\'| ForEach-Object { "$_\$($RegistryKeys.Shell)\" } | Join-String)

        return $path.Remove($path.Length - 1)
    }
    else { return $KeyPath }
}
