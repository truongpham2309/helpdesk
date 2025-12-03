#!/usr/bin/env pwsh
# Build script for HelpDesk QuickSupport variant
# This creates a portable version without installation requirement and license check bypass

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Building HelpDesk QuickSupport" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# Step 1: Backup original .env file
Write-Host "[1/5] Backing up original .env..." -ForegroundColor Yellow
if (Test-Path "flutter\.env") {
    Copy-Item "flutter\.env" "flutter\.env.backup" -Force
}

# Step 2: Switch to quicksupport .env
Write-Host "[2/5] Switching to QuickSupport environment..." -ForegroundColor Yellow
Copy-Item "flutter\.env.quicksupport" "flutter\.env" -Force

# Step 3: Build with portable flag
Write-Host "[3/5] Building Flutter Windows portable..." -ForegroundColor Yellow
python build.py --flutter --portable --hwcodec --vram

# Step 4: Restore original .env
Write-Host "[4/5] Restoring original environment..." -ForegroundColor Yellow
if (Test-Path "flutter\.env.backup") {
    Copy-Item "flutter\.env.backup" "flutter\.env" -Force
    Remove-Item "flutter\.env.backup" -Force
}

# Step 5: Rename output
Write-Host "[5/5] Renaming output file..." -ForegroundColor Yellow
$version = (Select-String -Path "Cargo.toml" -Pattern '^version\s*=\s*"(.+)"').Matches.Groups[1].Value

$installFile = "helpdesk-$version-install.exe"
$quicksupportFile = "helpdesk-$version-quicksupport.exe"

if (Test-Path $installFile) {
    Rename-Item $installFile $quicksupportFile -Force
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "BUILD SUCCESSFUL!" -ForegroundColor Green
    Write-Host "Output: $quicksupportFile" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "BUILD FAILED - Output file not found" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
}

Write-Host ""
Write-Host "Press any key to continue..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
