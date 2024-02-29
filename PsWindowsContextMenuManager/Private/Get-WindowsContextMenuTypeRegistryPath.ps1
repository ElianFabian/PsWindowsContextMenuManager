function Get-WindowsContextMenuTypeRegistryPath {

     [OutputType([string])]
     param (
          [Parameter(Mandatory)]
          [ValidateSet('File', 'Directory', 'Desktop', 'Drive')]
          [string] $Type
     )

     $relativeTypeRegistryPath = switch ($Type) {
          'File' {
               '*' 
          }
          'Directory' {
               'Directory' 
          }
          'Desktop' {
               'Directory\background' 
          }
          'Drive' {
               'Drive' 
          }
     }

     return "$BasePath\$relativeTypeRegistryPath"
}

$BasePath = "Registry::HKEY_CLASSES_ROOT"
