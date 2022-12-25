function New-WcmItem
{
    param
    (
        [Parameter(Mandatory=$true)]
        [string] $Key,

        [Parameter(Mandatory=$true)]
        [string] $Name,

        [ValidateSet('File', 'Directory', 'Desktop', 'Drive')]
        [string] $Type,

        [Parameter(ParameterSetName='Root-Command')]
        [Parameter(ParameterSetName='Root-Group')]
        [switch] $Extended = $false,

        [Parameter(ParameterSetName='Root-Command')]
        [Parameter(ParameterSetName='Root-Group')]
        [ValidateSet('Top', 'Bottom', '')]
        [string] $Position = '',

        [ValidateScript({ $_ -match '^.+\.ico$' }, ErrorMessage = "The given IconPath '{0}' must be a .ico file.")]
        [string] $IconPath = '',

        [Parameter(ParameterSetName='Sub-Command', Mandatory=$true)]
        [Parameter(ParameterSetName='Sub-Group',   Mandatory=$true)]
        [string] $ParentPath = '',

        [Parameter(ParameterSetName='Root-Command')]
        [Parameter(ParameterSetName='Sub-Command')]
        [string] $Command,

        [Parameter(ParameterSetName='Root-Group')]
        [Parameter(ParameterSetName='Sub-Group')]
        [IWcmItem[]] $ChildItem,

        [string[]] $Tag = $null
    )

    $typePath     = $ContextMenuPathType.$Type
    $locationPath = $PSCmdlet.ParameterSetName.StartsWith('Root') ? $typePath : "$typePath\$ParentPath\$($RegistryKeys.Shell)"

    if (-not (Test-Path $locationPath))
    {
        Write-Error "The path '$locationPath' does not exist."
        return
    }

    # Create item
    $itemPath = (New-Item -Path $locationPath -Name $Key -ErrorAction Stop).PSPath.Replace("*", "``*")

    switch ($PSCmdlet.ParameterSetName)
    {
        Root-Command
        {
            New-WcmRegistryItem -ItemPath $itemPath -Name $Name -IconPath $IconPath -Command $Command

            Add-RootPropertiesIfPossible -ItemPath $itemPath -Extended:$Extended -Position $Position
        }
        Root-Group
        {
            # Set group name (MUIVerb)
            New-ItemProperty -Path $itemPath -Name $RegistryProperties.MUIVerb -Value $Name > $null
            Write-Verbose "New item property: $itemPath\$($RegistryProperties.MUIVerb) = ""$Name""" -Verbose:$VerbosePreference

            # Set root properties
            Add-RootPropertiesIfPossible -ItemPath $itemPath -Extended:$Extended -Position $Position

            # Allow subitems
            New-ItemProperty -Path $itemPath -Name $RegistryProperties.Subcommands > $null
            Write-Verbose "New item property: $itemPath\$($RegistryProperties.Subcommands)" -Verbose:$VerbosePreference

            # Create shell (container of subitems)
            $itemShellPath = (New-Item -Path $itemPath -Name $RegistryKeys.Shell).PSPath.Replace("*", "``*")
            Write-Verbose "New item: $itemShellPath" -Verbose:$VerbosePreference

            # Add subitems
            foreach ($subitem in $ChildItem)
            {
                if ($subCommand = [IWcmSubCommandItem] $subitem)
                {
                    New-WcmItem `
                        -Key $subCommand.Key `
                        -Name $subCommand.Name `
                        -Type $Type `
                        -IconPath $subCommand.IconPath `
                        -Command $subCommand.Command `
                        -ParentPath $itemShellPath `
                }
                elseif ($subGroup = [IWcmSubGroupItem] $subitem)
                {
                    New-WcmItem `
                        -Key $subGroup.Key `
                        -Name $subGroup.Name `
                        -Type $Type `
                        -IconPath $subGroup.IconPath `
                        -ChildItem $subGroup.Children `
                        -ParentPath $itemShellPath `
                }
            }
        }
        Sub-Command
        {
            New-WcmRegistryItem -ItemPath $itemPath -Name $Name -IconPath $IconPath -Command $Command
        }
        Sub-Group
        {
            # [PSCustomObject]
            # @{
            #     key      = $Key
            #     name     = $Name
            #     iconPath = $IconPath
            #     children = $ChildItem
            # } 
        }
    }
}
