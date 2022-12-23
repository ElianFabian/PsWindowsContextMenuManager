function Add-WindowsContextMenuItem
{
    param
    (
        [Parameter(Mandatory=$true)]
        [string] $Key,

        [Alias('Title', 'MUIVerb')]
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
        [ValidateSet('Top', 'Bottom')]
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

    switch ($PSCmdlet.ParameterSetName)
    {
        'Root-Command'
        {
            $pathType = $ContextMenuPathType.$Type

            try
            {
                # Create item
                $itemPath = (New-Item -Path $pathType -Name $Key -ErrorAction Stop).PSPath.Replace("*", "``*")

                Write-Verbose "New item: '$itemPath'" -Verbose:$VerbosePreference
            }
            catch
            {
                Write-Error "The item '$pathType\$Key' already exists."
                return
            }

            # Create command
            $commandPath = (New-Item -Path $itemPath -Name $RegistryKeys.Command).PSPath

            Write-Verbose "New command item: '$commandPath'" -Verbose:$VerbosePreference

            # Set command name
            New-ItemProperty -Path $itemPath -Name $RegistryProperties.Default -Value $Name > $null

            # Set command value
            New-ItemProperty -LiteralPath $commandPath -Name  $RegistryProperties.Default -Value $Command > $null


            if ($null -ne $Extended -and $Extended -like $true)
            {
                # Mark as extended (must hold Shift to make the option visible)
                New-ItemProperty -Path $itemPath -Name $RegistryProperties.Extended > $null

                Write-Verbose "New item property: '$itemPath\$($RegistryProperties.Extended)'" -Verbose:$VerbosePreference
            }
            if ($null -ne $Position)
            {
                # Set the position of the item (Top | Bottom)
                New-ItemProperty -Path $itemPath -Name $RegistryProperties.Position -Value $Position > $null
    
                Write-Verbose "New item property: '$itemPath\$($RegistryProperties.Position)'" -Verbose:$VerbosePreference
            }
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
        #     [PSCustomObject]
        #     @{
        #         key      = $Key
        #         name     = $Name
        #         iconPath = $IconPath
        #         children = $ChildItem
        #         type     = $Type
        #         extended = $Extended
        #         position = $Position
        #     } 
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
