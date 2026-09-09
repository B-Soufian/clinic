# Fromza EMR - Dependency Conflict Detector & Fixer
# This script detects and resolves common dependency conflicts before setup

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "Fromza EMR - Dependency Conflict Checker" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Check Node.js version
Write-Host "1. Checking Node.js version..." -ForegroundColor Yellow
$nodeVersion = node --version
Write-Host "   Current: $nodeVersion" -ForegroundColor Green

if ($nodeVersion -match "v(1[6-9]|2[0-9])") {
    Write-Host "   ⚠️  WARNING: Node v$nodeVersion is too new! Angular 7 requires Node v14.x" -ForegroundColor Red
    Write-Host "   " -ForegroundColor Red
    Write-Host "   SOLUTIONS:" -ForegroundColor Yellow
    Write-Host "   Option 1: Download Node v14 from https://nodejs.org/en/download/releases/" -ForegroundColor Cyan
    Write-Host "            Then uninstall your current version and install v14" -ForegroundColor Cyan
    Write-Host "   " -ForegroundColor Cyan
    Write-Host "   Option 2: Use NVM to switch versions:" -ForegroundColor Cyan
    Write-Host "            nvm install 14.21.3" -ForegroundColor Cyan
    Write-Host "            nvm use 14.21.3" -ForegroundColor Cyan
    Write-Host "   " -ForegroundColor Cyan
    exit 1
} elseif ($nodeVersion -notmatch "v14") {
    Write-Host "   ⚠️  WARNING: You don't have Node v14 installed" -ForegroundColor Red
    exit 1
} else {
    Write-Host "   ✅ Node v14 detected - OK!" -ForegroundColor Green
}

Write-Host ""

# Check npm version
Write-Host "2. Checking npm version..." -ForegroundColor Yellow
$npmVersion = npm --version
Write-Host "   Current: $npmVersion" -ForegroundColor Green

Write-Host ""

# Check for node_modules and package-lock.json
Write-Host "3. Checking for old dependencies..." -ForegroundColor Yellow

$nodeModulesPath = Join-Path (Get-Location) "Code/Websites/FromzaEMR/wwwroot/FromzaApp/node_modules"
$lockPath = Join-Path (Get-Location) "Code/Websites/FromzaEMR/wwwroot/FromzaApp/package-lock.json"

if (Test-Path $nodeModulesPath) {
    Write-Host "   Found old node_modules folder" -ForegroundColor Yellow
    $cleanOld = Read-Host "   Delete old dependencies? (y/n)"
    
    if ($cleanOld -eq "y" -or $cleanOld -eq "Y") {
        Write-Host "   Deleting node_modules..." -ForegroundColor Cyan
        Remove-Item -Recurse -Force $nodeModulesPath -ErrorAction SilentlyContinue
        Write-Host "   ✅ Deleted" -ForegroundColor Green
    }
} else {
    Write-Host "   ✅ No old node_modules found" -ForegroundColor Green
}

if (Test-Path $lockPath) {
    Write-Host "   Found old package-lock.json" -ForegroundColor Yellow
    $cleanLock = Read-Host "   Delete package-lock.json? (y/n)"
    
    if ($cleanLock -eq "y" -or $cleanLock -eq "Y") {
        Write-Host "   Deleting package-lock.json..." -ForegroundColor Cyan
        Remove-Item -Force $lockPath -ErrorAction SilentlyContinue
        Write-Host "   ✅ Deleted" -ForegroundColor Green
    }
} else {
    Write-Host "   ✅ No old package-lock.json found" -ForegroundColor Green
}

Write-Host ""

# Clean npm cache
Write-Host "4. Cleaning npm cache..." -ForegroundColor Yellow
npm cache clean --force | Out-Null
Write-Host "   ✅ Cache cleaned" -ForegroundColor Green

Write-Host ""

# Summary
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "✅ Dependency conflict check complete!" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Navigate to: Code/Websites/FromzaEMR/wwwroot/FromzaApp" -ForegroundColor Cyan
Write-Host "2. Run: npm install --legacy-peer-deps" -ForegroundColor Cyan
Write-Host "3. Run: npm start" -ForegroundColor Cyan
Write-Host ""
Write-Host "Note: npm install may show peer dependency warnings - this is normal for Angular 7!" -ForegroundColor Gray
Write-Host ""
