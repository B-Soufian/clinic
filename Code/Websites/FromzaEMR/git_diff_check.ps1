# Resolve repo root from script location (script is in Code\Websites\FromzaEMR)
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..\..")).Path
Set-Location $repoRoot
git status --porcelain > git_status.txt
