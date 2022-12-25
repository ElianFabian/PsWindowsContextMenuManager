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
        [ValidateScript({ Test-Path $_ }, ErrorMessage = "The given IconPath '{0}' does not exists.")]
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


    try
    {
        # Create item
        $itemPath = (New-Item -Path $locationPath -Name $Key -ErrorAction Stop).PSPath.Replace("*", "``*")
    }
    catch { Write-Error -Message "Failed to import script '$($import.FullName)': $_" }


    switch ($PSCmdlet.ParameterSetName)
    {
        Root-Command
        {
            # Create command
            $commandPath = (New-Item -Path $itemPath -Name $RegistryKeys.Command).PSPath
            Write-Verbose "New command item: $commandPath" -Verbose:$VerbosePreference

            # Set command name
            New-ItemProperty -Path $itemPath -Name $RegistryProperties.Default -Value $Name > $null
            Write-Verbose "New item property: $itemPath\$($RegistryProperties.Default) = ""$Name""" -Verbose:$VerbosePreference

            # Set command value
            New-ItemProperty -LiteralPath $commandPath -Name  $RegistryProperties.Default -Value $Command > $null
            Write-Verbose "New item property: $commandPath\$($RegistryProperties.Default) = ""$Command""" -Verbose:$VerbosePreference

            if ($IconPath)
            {
                # Set item image
                New-ItemProperty -Path $itemPath -Name $RegistryProperties.Icon -Value $iconPath > $null
                Write-Verbose "New item property: $itemPath\$($RegistryProperties.Icon) = $iconPath" -Verbose:$VerbosePreference
            }

            # Set root properties
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
                    Add-WcmItem `
                        -Key $subCommand.Key `
                        -Name $subCommand.Name `
                        -IconPath $subCommand.IconPath `
                        -Command $subCommand.Command `
                        -ParentPath $itemShellPath
                }
                elseif ($subGroup = [IWcmSubGroupItem] $subitem)
                {
                    Add-WcmItem `
                        -Key $subGroup.Key `
                        -Name $subGroup.Name `
                        -IconPath $subGroup.IconPath `
                        -ChildItem $subGroup.Children `
                        -ParentPath $itemShellPath
                }
            }
        }
        Sub-Command
        {
            # [PSCustomObject]
            # @{
            #     key      = $Key
            #     name     = $Name
            #     iconPath = $IconPath
            #     command  = $Command
            # } 

            # Create command
            $commandPath = (New-Item -Path $itemPath -Name $RegistryKeys.Command).PSPath
            Write-Verbose "New command item: $commandPath" -Verbose:$VerbosePreference

            # Set command name
            New-ItemProperty -Path $itemPath -Name $RegistryProperties.Default -Value $Name > $null
            Write-Verbose "New item property: $itemPath\$($RegistryProperties.Default) = ""$Name""" -Verbose:$VerbosePreference

            # Set command value
            New-ItemProperty -LiteralPath $commandPath -Name  $RegistryProperties.Default -Value $Command > $null
            Write-Verbose "New item property: $commandPath\$($RegistryProperties.Default) = ""$Command""" -Verbose:$VerbosePreference

            if ($IconPath)
            {
                # Set item image
                New-ItemProperty -Path $itemPath -Name $RegistryProperties.Icon -Value $IconPath > $null
                Write-Verbose "New item property: $itemPath\$($RegistryProperties.Icon) = ""$IconPath""" -Verbose:$VerbosePreference
            }

            Add-RootPropertiesIfPossible -ItemPath $itemPath -Extended:$Extended -Position $Position
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
