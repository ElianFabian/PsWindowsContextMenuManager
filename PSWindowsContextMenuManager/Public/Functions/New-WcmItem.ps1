function New-WcmItem
{
    [CmdletBinding(DefaultParameterSetName='Root-Item')]
    param
    (
        [Parameter(Mandatory=$true)]
        [string] $Key,

        [Parameter(Mandatory=$true)]
        [string] $Name,

        [ValidateSet('Command', 'Group')]
        [string] $ItemType = 'Command',

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
        [string] $ParentLiteralPathKey = '',

        [string] $Command
    )

    $registryParentPath = Resolve-PathKey -LiteralPathKey $ParentLiteralPathKey -Type $Type -ChildName Shell

    if (-not (Test-Path -LiteralPath $registryParentPath))
    {
        Write-Error "The path '$registryParentPath' does not exist."
        return
    }

    $itemPath = "$registryParentPath\$Key"

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

    switch ($ItemType)
    {
        Command
        {
            New-WcmRegistryCommandItem -ItemPath $itemPath -Name $Name -IconPath $IconPath -Command $Command
        }
        Group
        {
            New-WcmRegistryGroupItem -ItemPath $itemPath -Name $Name -IconPath $IconPath
        }
    }

    Add-RootPropertiesIfPossible -ItemPath $itemPath -Extended:$Extended -Position $Position

    return Get-WcmItem -LiteralPathKey ($ParentLiteralPathKey ? "$ParentLiteralPathKey\$Key" : $Key) -Type $Type
}
