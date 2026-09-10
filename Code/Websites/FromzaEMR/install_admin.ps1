Start-Process "msiexec.exe" -ArgumentList "/i `"$(Join-Path $PSScriptRoot 'SqlLocalDB.msi')`" /qn IACCEPTSQLLOCALDBLICENSETERMS=YES" -Wait
"DONE" | Out-File (Join-Path $PSScriptRoot "install_done.txt")
