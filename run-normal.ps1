#!/usr/bin/env pwsh
# Run HelpDesk in NORMAL mode (with license check)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Running HelpDesk - NORMAL Mode" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Mode: NORMAL (Standard version)" -ForegroundColor Yellow
Write-Host "  • License check: ENABLED" -ForegroundColor Gray
Write-Host "  • Service: Manual start" -ForegroundColor Gray
Write-Host "  • Config: .env" -ForegroundColor Gray
Write-Host ""

Set-Location flutter
flutter run -d windows --release
Set-Location ..
