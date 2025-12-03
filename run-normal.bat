@echo off
REM Run HelpDesk in NORMAL mode

echo ========================================
echo Running HelpDesk - NORMAL Mode
echo ========================================
echo.
echo Mode: NORMAL (Standard version)
echo   - License check: ENABLED
echo   - Service: Manual start
echo   - Config: .env
echo.

cd flutter
flutter run -d windows --release
cd ..
