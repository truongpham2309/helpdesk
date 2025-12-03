#!/usr/bin/env pwsh
# Run HelpDesk in QUICKSUPPORT mode (no license, auto-start)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Running HelpDesk - QUICKSUPPORT Mode" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Mode: QUICKSUPPORT (Fast support)" -ForegroundColor Yellow
Write-Host "  • License check: BYPASSED" -ForegroundColor Green
Write-Host "  • Service: AUTO-START" -ForegroundColor Green
Write-Host "  • Config: .env.quicksupport" -ForegroundColor Gray
Write-Host ""

Set-Location flutter
flutter run -d windows --release --dart-define=QUICKSUPPORT=true
Set-Location ..
