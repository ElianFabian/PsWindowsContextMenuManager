function New-WindowsContextMenuRegistryCommandItem {

    param (
        [Parameter(Mandatory)]
        [string] $ItemPath,

        [Parameter(Mandatory)]
        [string] $Name,

        [string] $IconPath,

        [string] $Command
    )

    $commandPath = "$ItemPath\Command"

    # Create command
    New-Item $commandPath > $null
    Write-Verbose "New item: $commandPath"

    # Set command name
    New-ItemProperty -LiteralPath $ItemPath -Name '(default)' -Value $Name > $null
    Write-Verbose "New item property: $ItemPath\(default) = ""$Name"""

    # Set command value
    New-ItemProperty -LiteralPath $commandPath -Name '(default)' -Value $Command > $null
    Write-Verbose "New item property: $commandPath\(default) = ""$Command"""

   
    Set-WindowsContextMenuIconProperty -ItemPath $ItemPath -IconPath $IconPath
}
