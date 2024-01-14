function Get-TypeRegistryPath
{
    param
    (
        [Parameter(Mandatory=$true)]
        [ValidateSet('File', 'Directory', 'Desktop', 'Drive')]
        [string] $Type
    )

    $relativeTypeRegistryPath = switch ($Type)
    {
        'File' 
        {
             '*' 
        }
        'Directory' 
        {
             'Directory' 
        }
        'Desktop' 
        {
             'Directory\background' 
        }
        'Drive' 
        {
             'Drive' 
        }
    }

    return "$BasePath\$relativeTypeRegistryPath"
}

$BasePath = "Microsoft.PowerShell.Core\Registry::HKEY_CLASSES_ROOT"