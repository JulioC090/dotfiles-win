$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$toGifPath = Join-Path $scriptDir "toGif.psm1"

$profilePath = $PROFILE

# Create the profile file if it doesn't exist
if (-not (Test-Path $profilePath)) {
    New-Item -ItemType File -Path $profilePath -Force | Out-Null
    Write-Host "Created profile file at $profilePath"
}

# Read all lines of the profile (empty array if file is new)
$profileLines = if (Test-Path $profilePath) { Get-Content $profilePath } else { @() }

# Global import
$globalImport = "Import-Module -Name `"$toGifPath`""

# Check if an import already exists in the file
$importExists = $profileLines | ForEach-Object { $_.Trim() } | Where-Object { $_.StartsWith($globalImport) }

if ($importExists) {
    Write-Host "Import 'toGif' already exists in $PROFILE"
} else {
    Add-Content -Path $profilePath -Value $globalImport
    Write-Host "Import 'toGif' added to $PROFILE"
}