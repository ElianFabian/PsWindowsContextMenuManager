function Get-WcmItemReference
{
    [OutputType([PSCustomObject])]
    param
    (
        [Parameter(Mandatory=$true)]
        [string] $LiteralPathKey,

        [ValidateSet('File', 'Directory', 'Desktop', 'Drive')]
        [string] $Type = 'File'
    )

    $registryPath = Resolve-PathKey -LiteralPathKey $LiteralPathKey -Type $Type

    [Microsoft.Win32.RegistryKey] $registryItem = Get-Item -LiteralPath $registryPath -ErrorAction Stop

    $childName = $registryItem.GetSubKeyNames()[0]

    $isGroupItem = ('Subcommands' -in $registryItem.Property) -and ($childName -eq 'Shell')
    $isCommandItem = ($childName -eq 'Command') -and (-not $isGroupItem)

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
        return
    }

    $wcmItem = [PSCustomObject]@{}
        | Add-Member -Name Key          -Value $registryItem.PSChildName -PassThru -MemberType NoteProperty  
        | Add-Member -Name RegistryItem -Value $registryItem             -PassThru -MemberType NoteProperty  
        | Add-Member -Name RegistryPath -Value $registryItem.PSPath      -PassThru -MemberType NoteProperty  
        | Add-Member -Name Type         -Value $Type                     -PassThru -MemberType NoteProperty  
        | Add-Member -Name IconPath                                      -PassThru -MemberType ScriptProperty `
            -Value {$this.RegistryItem.GetValue('Icon') } `
            -SecondValue {
                param
                (
                    [ValidatePattern('(.ico|^$)$')]
                    [string] $value
                )

                Set-ItemProperty -LiteralPath $this.RegistryPath -Name Icon -Value $value
            }
        | Add-Member -Name Position -Value { $this.RegistryItem.GetValue('Position') } -PassThru -MemberType ScriptProperty `
            -SecondValue {
                param
                (
                    [ValidateSet('Top', 'Bottom', '')]
                    [string] $value
                )

                Set-ItemProperty -LiteralPath $this.RegistryPath -Name Position -Value $value
            }
        | Add-Member -Name IsExtended -Value { $null -ne $this.RegistryItem.GetValue('Extended') } -PassThru -MemberType ScriptProperty `
        -SecondValue {
            param([bool] $value)

            if ($value)
            {
                New-ItemProperty -LiteralPath $this.RegistryPath -Name Extended
            }
            else
            {
                Remove-ItemProperty -LiteralPath $this.RegistryPath -Name Extended
            }
        }

    switch ($itemType)
    {
        Command
        {
            $wcmItem
                | Add-Member -Name Name -PassThru -MemberType ScriptProperty `
                    -Value { $this.RegistryItem.GetValue('') } `
                    -SecondValue { param([string] $value)

                        Set-ItemProperty -LiteralPath $this.RegistryPath -Name '(default)' -Value $value
                    }
                | Add-Member -Name Command -MemberType ScriptProperty `
                    -Value { (Get-Item -LiteralPath "$($this.RegistryPath)\Command").GetValue('') } `
                    -SecondValue { param([string] $value)

                        Set-ItemProperty -LiteralPath "$($this.RegistryPath)\Command" -Name '(default)' -Value $value
                    }
        }
        Group
        {
            $wcmItem
                | Add-Member -Name Name -PassThru -MemberType ScriptProperty `
                    -Value { $this.RegistryItem.GetValue('MUIVerb') } `
                    -SecondValue { param([string] $value)

                        Set-ItemProperty -LiteralPath $this.RegistryPath -Name 'MUIVerb' -Value $value
                    }
                | Add-Member -Name ChildCount -Value { (Get-Item -LiteralPath "$($this.RegistryPath)\Shell").SubKeyCount } -MemberType ScriptProperty
        }
    }

    return $wcmItem
}
