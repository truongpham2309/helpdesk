@echo off
REM Run HelpDesk in QUICKSUPPORT mode

echo ========================================
echo Running HelpDesk - QUICKSUPPORT Mode
echo ========================================
echo.
echo Mode: QUICKSUPPORT (Fast support)
echo   - License check: BYPASSED
echo   - Service: AUTO-START
echo   - Config: .env.quicksupport
echo.

cd flutter
flutter run -d windows --release --dart-define=QUICKSUPPORT=true
cd ..
