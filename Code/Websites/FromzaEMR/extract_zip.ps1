# Resolve repo root from script location (script is in Code\Websites\FromzaEMR)
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..\..")).Path

$zipPath = Join-Path $repoRoot "Database\2. EMR-Db\FromzaInternationalDB\Dev_FromzaEMR_INT1.zip"
$destPath = Join-Path $repoRoot "Database\2. EMR-Db\FromzaInternationalDB\extracted"

if (Test-Path $destPath) {
    Remove-Item -Recurse -Force $destPath
}
New-Item -ItemType Directory -Force -Path $destPath | Out-Null
Expand-Archive -Path $zipPath -DestinationPath $destPath -Force
Get-ChildItem -Path $destPath -Recurse | Select-Object FullName
