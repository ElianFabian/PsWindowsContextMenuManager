# Code from: https://github.com/RamblingCookieMonster/PSStackExchange/blob/master/PSStackExchange/PSStackExchange.psm1



# Get public and private function definition files.
$Public  = @(Get-ChildItem -Path $PSScriptRoot\Public\*.ps1  -Recurse -ErrorAction SilentlyContinue)
$Private = @(Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -Recurse -ErrorAction SilentlyContinue)

# Dot source the files
foreach ($import in @($Public + $Private))
{
    try
    {
        . $import.fullname
    }
    catch
    {
        Write-Error -Message "Failed to import script '$($import.fullname)': $_"
    }
}



Export-ModuleMember -Function $Public.Basename
