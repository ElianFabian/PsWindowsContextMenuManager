function New-WcmItem
{
    param
    (
        [Parameter(Mandatory=$true)]
        [string] $Key,

        [Parameter(Mandatory=$true)]
        [string] $Name,

        [Parameter(Mandatory=$true)]
        [ValidateSet('File', 'Directory', 'Desktop', 'Drive')]
        [string] $Type,

        [switch] $Extended = $false,

        [ValidateSet('Top', 'Bottom', '')]
        [string] $Position = '',

        [ValidatePattern('(.ico|^$)$', ErrorMessage = "The given IconPath '{0}' must be a .ico file.")]
        [string] $IconPath = '',

        [string] $ParentPath = '',

        [Parameter(ParameterSetName='Command')]
        [string] $Command,

        [Parameter(ParameterSetName='Group')]
        [object[]] $ChildItem
    )

    $typePath           = $ContextMenuPathType.$Type
    $parentAbsolutePath = $ParentPath ? "$typePath\$ParentPath" : "$typePath"


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
            Write-Error "The path 'itemPath' already exists."
            return
        }
    }

    switch ($PSCmdlet.ParameterSetName)
    {
        Command
        {
            New-WcmRegistryCommandItem -ItemPath $itemPath -Name $Name -IconPath $IconPath -Command $Command

            Add-RootPropertiesIfPossible -ItemPath $itemPath -Extended:$Extended -Position $Position
        }
        Group
        {
            New-WcmRegistryGroupItem -ItemPath $itemPath -Name $Name -IconPath $IconPath

            Add-RootPropertiesIfPossible -ItemPath $itemPath -Extended:$Extended -Position $Position

            # Add subitems
            foreach ($subitem in $ChildItem)
            {
                $parentShellPath = "$($ParentPath ? "$ParentPath\$Key" : $Key)\$($RegistryKeys.Shell)"

                if ($subitem.Command)
                {
                    New-WcmItem `
                        -Key $subitem.Key `
                        -Name $subitem.Name `
                        -Type $Type `
                        -IconPath $subitem.IconPath `
                        -Command $subitem.Command `
                        -ParentPath $parentShellPath `
                }
                else
                {
                    New-WcmItem `
                        -Key $subitem.Key `
                        -Name $subitem.Name `
                        -Type $Type `
                        -IconPath $subitem.IconPath `
                        -ChildItem $subitem.Children `
                        -ParentPath $parentShellPath `
                }
            }
        }
    }
}
