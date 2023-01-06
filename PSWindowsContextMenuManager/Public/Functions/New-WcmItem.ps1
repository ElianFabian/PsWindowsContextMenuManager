function New-WcmItem
{
    param
    (
        [Parameter(Mandatory=$true)]
        [string] $Key,

        [Parameter(Mandatory=$true)]
        [string] $Name,
        
        [ValidatePattern('(.ico|^$)$', ErrorMessage = "The given IconPath '{0}' must be a .ico file.")]
        [string] $IconPath = '',

        [Parameter(Mandatory=$true)]
        [ValidateSet('File', 'Directory', 'Desktop', 'Drive')]
        [string] $Type,

        [Parameter(ParameterSetName='Root-Command')]
        [Parameter(ParameterSetName='Root-Group')]
        [switch] $Extended = $false,

        [Parameter(ParameterSetName='Root-Command')]
        [Parameter(ParameterSetName='Root-Group')]
        [ValidateSet('Top', 'Bottom', '')]
        [string] $Position = '',

        [Parameter(ParameterSetName='Sub-Command')]
        [Parameter(ParameterSetName='Sub-Group')]
        [string] $ParentPath = '',

        [Parameter(ParameterSetName='Root-Command')]
        [Parameter(ParameterSetName='Sub-Command')]
        [string] $Command,

        [Parameter(ParameterSetName='Root-Group')]
        [Parameter(ParameterSetName='Sub-Group')]
        [object[]] $ChildItem
    )

    $typePath           = $ContextMenuPathType.$Type
    $parentAbsolutePath = $ParentPath ? "$typePath\$ParentPath" : $typePath


    if (-not (Test-Path -LiteralPath $parentAbsolutePath))
    {
        Write-Error "The path '$parentAbsolutePath' does not exist."
        return
    }

    $itemPath = "$parentAbsolutePath\$Key"

    # Create item
    New-Item $itemPath -ErrorAction SilentlyContinue -ErrorVariable outErrorMessage > $null
    Write-Verbose "New item: $itemPath" -Verbose:$VerbosePreference

    switch ($outErrorMessage)
    {
        'A key in this path already exists.'
        {
            Write-Error "The path '$itemPath' already exists."
            return
        }
    }

    switch -Wildcard ($PSCmdlet.ParameterSetName)
    {
        *-Command
        {
            New-WcmRegistryCommandItem -ItemPath $itemPath -Name $Name -IconPath $IconPath -Command $Command

            Add-RootPropertiesIfPossible -ItemPath $itemPath -Extended:$Extended -Position $Position

            return New-WcmItemObject `
                    -Key $Key `
                    -Name $Name `
                    -IconPath $IconPath `
                    -Type $Type `
                    -Extended:$Extended `
                    -Position $Position `
                    -Command $Command
        }
        *-Group
        {
            New-WcmRegistryGroupItem -ItemPath $itemPath -Name $Name -IconPath $IconPath

            Add-RootPropertiesIfPossible -ItemPath $itemPath -Extended:$Extended -Position $Position

            # Add subitems
            $parentShellPath = "$($ParentPath ? "$ParentPath\$Key" : $Key)\$($RegistryKeys.Shell)"

            foreach ($subitem in $ChildItem)
            {
                if ($subitem.Command)
                {
                    New-WcmItem `
                        -Key $subitem.Key `
                        -Name $subitem.Name `
                        -IconPath $subitem.IconPath `
                        -Type $Type `
                        -Command $subitem.Command `
                        -ParentPath $parentShellPath > $null
                }
                else
                {
                    New-WcmItem `
                        -Key $subitem.Key `
                        -Name $subitem.Name `
                        -IconPath $subitem.IconPath `
                        -Type $Type `
                        -ChildItem $subitem.Children `
                        -ParentPath $parentShellPath > $null
                }
            }

            return New-WcmItemObject `
                    -Key $Key `
                    -Name $Name `
                    -IconPath $IconPath `
                    -Type $Type `
                    -Extended:$Extended `
                    -Position $Position `
                    -ChildItem $ChildItem
        }
    }
}
