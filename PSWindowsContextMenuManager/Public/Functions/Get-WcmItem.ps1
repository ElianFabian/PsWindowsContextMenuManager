function Get-WcmItem
{
    [OutputType([PSCustomObject])]
    param
    (
        [Parameter(Mandatory=$true)]
        [string] $LiteralPathKey,

        [Parameter(Mandatory=$true)]
        [ValidateSet('File', 'Directory', 'Desktop', 'Drive')]
        [string] $Type
    )

    $registryPath = Resolve-PathKey -LiteralPathKey $LiteralPathKey -Type $Type

    [Microsoft.Win32.RegistryKey]`
    $registryItem = Get-Item -LiteralPath $registryPath -ErrorAction Ignore

    if (-not $registryItem)
    {
        Write-Error "Cannot find context menu item with key '$LiteralPathKey' and type '$Type' because it does not exist or it's not a valid context menu item. Full path: '$registryPath'."
        return
    }

    $isGroupItem = Test-WcmGroupItem -LiteralPathKey $LiteralPathKey -Type $Type
    $isCommandItem = Test-WcmCommandItem -LiteralPathKey $LiteralPathKey -Type $Type

    $itemType = if ($isGroupItem)
    {
        'Group'
    }
    elseif ($isCommandItem)
    {
        'Command'
    }
    else
    {
        Write-Error "The item '$registryPath' is not a Windows context menu item."
        return $null
    }

    $wcmItem = [PSCustomObject] @{
        Key          = $registryItem.PSChildName
        RegistryPath = $registryItem.PSPath
        Type         = $Type
        IconPath     = $registryItem.GetValue('Icon')
        Position     = $registryItem.GetValue('Position')
        IsExtended   = $null -ne $registryItem.GetValue('Extended')
    }

    switch ($itemType)
    {
        Command
        {
            $wcmItem
                | Add-Member -Name Name    -Value $registryItem.GetValue('')                                   -MemberType NoteProperty -PassThru
                | Add-Member -Name Command -Value (Get-Item -LiteralPath "$registryPath\Command").GetValue('') -MemberType NoteProperty
        }
        Group
        {
            $wcmItem
                | Add-Member -Name Name       -Value $registryItem.GetValue('MUIVerb')                         -MemberType NoteProperty -PassThru
                | Add-Member -Name ChildCount -Value (Get-Item -LiteralPath "$registryPath\Shell").SubKeyCount -MemberType NoteProperty
        }
    }

    return $wcmItem
}
