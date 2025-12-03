#!/usr/bin/env pwsh
# Build script for HelpDesk Normal (Full version with license check)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Building HelpDesk Normal Version" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Building standard version with:" -ForegroundColor Yellow
Write-Host "  - License check enabled" -ForegroundColor Gray
Write-Host "  - Full installation" -ForegroundColor Gray
Write-Host "  - Service management" -ForegroundColor Gray
Write-Host ""

Write-Host "Starting build process..." -ForegroundColor Green
python build.py --flutter --portable --hwcodec --vram

$version = (Select-String -Path "Cargo.toml" -Pattern '^version\s*=\s*"(.+)"').Matches.Groups[1].Value
$outputFile = "helpdesk-$version-install.exe"

if (Test-Path $outputFile) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "BUILD SUCCESSFUL!" -ForegroundColor Green
    Write-Host "Output: $outputFile" -ForegroundColor Green
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
