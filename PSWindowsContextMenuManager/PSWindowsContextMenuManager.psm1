# Get scripts to load
$Script = @(Get-ChildItem -Path $PSScriptRoot\*.ps1 -Recurse -ErrorAction SilentlyContinue)

# Dot source the files
foreach ($import in @($Script)) {
    try {
        . $import.FullName
    }
    catch {
        Write-Error "Failed to import preloaded script '$($import.FullName)': $_"
    }
}


# Get public function definition files
$PublicFunction = @(Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -Recurse -ErrorAction SilentlyContinue)


Export-ModuleMember -Function $PublicFunction.BaseName
