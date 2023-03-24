function Remove-WcmItem
{
    param
    (
        [Parameter(Mandatory=$true)]
        [string] $KeyPath,

        [Parameter(Mandatory=$true)]
        [ValidateSet('File', 'Directory', 'Desktop', 'Drive')]
        [string] $Type,

        [switch] $Recurse
    )
    
    $actualPath = Resolve-KeyPath -KeyPath $KeyPath -Type $Type

    $itemExists = Get-Item -LiteralPath $actualPath -ErrorAction Ignore
    if (-not $itemExists)
    {
        Write-Warning "Attempt to remove a non-existing item: '$actualPath'."
        return
    }

    $isCommand = -not (Get-ItemProperty -LiteralPath $actualPath -Name Subcommands -ErrorAction Ignore)
    if ($isCommand)
    {
        Remove-CommandItem -ItemPath $actualPath
    }
    else
    {
        Remove-GroupItem -ItemPath $actualPath -Recurse:$Recurse
    }
}