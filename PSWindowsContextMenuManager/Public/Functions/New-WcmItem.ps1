function New-WcmItem
{
    param
    (
        [Parameter(Mandatory=$true)]
        [string] $Key,

        [Parameter(Mandatory=$true)]
        [string] $Name,

        [ValidateSet('Command', 'Group')]
        [string] $ItemType = 'Command',

        [ValidatePattern('(.ico|^$)$', ErrorMessage = "The given IconPath '{0}' must be a .ico file.")]
        [string] $IconPath = '',

        [Parameter(Mandatory=$true)]
        [ValidateSet('File', 'Directory', 'Desktop', 'Drive')]
        [string] $Type,

        [Parameter(ParameterSetName='Root-Item')]
        [switch] $Extended = $false,

        [Parameter(ParameterSetName='Root-Item')]
        [ValidateSet('Top', 'Bottom', '')]
        [string] $Position = '',

        [Parameter(ParameterSetName='Sub-Item')]
        [string] $ParentKeyPath = '',

        [string] $Command
    )

    $actualParentPath = Resolve-KeyPath -KeyPath $ParentKeyPath -Type $Type -ChildName Shell

    if (-not (Test-Path -LiteralPath $actualParentPath))
    {
        Write-Error "The path '$actualParentPath' does not exist."
        return
    }

    $itemPath = "$actualParentPath\$Key"

    # Create item
    New-Item $itemPath -ErrorAction SilentlyContinue -ErrorVariable outErrorMessage > $null
    Write-Verbose "New item: $itemPath"

    switch ($outErrorMessage)
    {
        'A key in this path already exists.'
        {
            Write-Error "The path '$itemPath' already exists."
            return
        }
    }

    $newWcmItemObject = New-WcmItemObject `
        -Key $Key `
        -Name $Name `
        -RegistryPath $itemPath `
        -ItemType $ItemType `
        -IconPath $IconPath `
        -Type $Type `
        -Extended:$Extended `
        -Position $Position `
        -Command $Command `
        -IsRootItem ($PSCmdlet.ParameterSetName -eq 'Root-Item')

    switch ($ItemType)
    {
        Command
        {
            New-WcmRegistryCommandItem -ItemPath $itemPath -Name $Name -IconPath $IconPath -Command $Command

            Add-RootPropertiesIfPossible -ItemPath $itemPath -Extended:$Extended -Position $Position

            return $newWcmItemObject
        }
        Group
        {
            New-WcmRegistryGroupItem -ItemPath $itemPath -Name $Name -IconPath $IconPath

            Add-RootPropertiesIfPossible -ItemPath $itemPath -Extended:$Extended -Position $Position

            return $newWcmItemObject
        }
    }
}
