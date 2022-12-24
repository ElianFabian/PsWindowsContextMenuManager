function Add-WindowsContextMenuItem
{
    param
    (
        [Parameter(Mandatory=$true)]
        [string] $Key,

        [Parameter(Mandatory=$true)]
        [ValidateLength(0, 16383)]
        [string] $Name,

        [Parameter(ParameterSetName='Root-Command', Mandatory=$true)]
        [Parameter(ParameterSetName='Root-Group',   Mandatory=$true)]
        [ValidateSet('File', 'Directory', 'Desktop', 'Drive')]
        [string] $Type,

        [Parameter(ParameterSetName='Root-Command')]
        [Parameter(ParameterSetName='Root-Group')]
        [switch] $Extended = $false,

        [Parameter(ParameterSetName='Root-Command')]
        [Parameter(ParameterSetName='Root-Group')]
        [ValidateSet('Top', 'Bottom', '')]
        [string] $Position = '',

        [ValidateLength(0, 16383)]
        [string] $IconPath = '',

        [Parameter(ParameterSetName='Sub-Command', Mandatory=$true)]
        [Parameter(ParameterSetName='Sub-Group',   Mandatory=$true)]
        [string] $ContainerKeyPath = '',

        [Parameter(ParameterSetName='Root-Command')]
        [Parameter(ParameterSetName='Sub-Command')]
        [ValidateLength(0, 16383)]
        [string] $Command,

        [Parameter(ParameterSetName='Root-Group')]
        [Parameter(ParameterSetName='Sub-Group')]
        [PSCustomObject[]] $ChildItem,

        [ValidateLength(0, 16383)]
        [string[]] $Tag = $null
    )

    $pathType = $ContextMenuPathType.$Type
    
    try
    {
        # Create item
        $itemPath = (New-Item -Path $pathType -Name $Key -ErrorAction Stop).PSPath.Replace("*", "``*")

        Write-Verbose "New item: $itemPath" -Verbose:$VerbosePreference
    }
    catch
    {
        Write-Error "The item '$pathType\$Key' already exists."
        return
    }

    switch ($PSCmdlet.ParameterSetName)
    {
        'Root-Command'
        {
            # Create command
            $commandPath = (New-Item -Path $itemPath -Name $RegistryKeys.Command).PSPath
            Write-Verbose "New command item: $commandPath" -Verbose:$VerbosePreference

            # Set command name
            New-ItemProperty -Path $itemPath -Name $RegistryProperties.Default -Value $Name > $null
            Write-Verbose "New item property: $itemPath\$($RegistryProperties.Default) = '$Name'" -Verbose:$VerbosePreference

            # Set command value
            New-ItemProperty -LiteralPath $commandPath -Name  $RegistryProperties.Default -Value $Command > $null
            Write-Verbose "New item property: $commandPath\$($RegistryProperties.Default) = '$Command'" -Verbose:$VerbosePreference

            Add-RootPropertiesIfNotNull -ItemPath $itemPath -Extended:$Extended -Position $Position
        }
        'Sub-Command'
        {
            # [PSCustomObject]
            # @{
            #     key      = $Key
            #     name     = $Name
            #     type     = $Type
            #     iconPath = $IconPath
            #     command  = $Command
            # }  
        }
        'Root-Group'
        {
            # Set group name (MUIVerb)
            New-ItemProperty -Path $itemPath -Name $RegistryProperties.MUIVerb -Value $Name > $null
            Write-Verbose "New item property: $itemPath\$($RegistryProperties.MUIVerb) = '$Name'" -Verbose:$VerbosePreference

            # Create shell (container of subitems)
            $itemShellPath = (New-Item -Path $itemPath -Name $RegistryKeys.Shell).PSPath.Replace("*", "``*")
            Write-Verbose "New item: $itemShellPath" -Verbose:$VerbosePreference

            # Allow subitems
            New-ItemProperty -Path $itemPath -Name $RegistryProperties.Subcommands > $null
            Write-Verbose "New item property: $itemPath\$($RegistryProperties.Subcommands)" -Verbose:$VerbosePreference

            Add-RootPropertiesIfNotNull -ItemPath $itemPath -Extended:$Extended -Position $Position
        }
        'Sub-Group'
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
