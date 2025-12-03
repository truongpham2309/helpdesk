@echo off
REM Build script for HelpDesk Normal (Full version)

echo ========================================
echo Building HelpDesk Normal Version
echo ========================================
echo.
echo Building standard version with:
echo   - License check enabled
echo   - Full installation
echo   - Service management
echo.

echo Starting build process...
python build.py --flutter --portable --hwcodec --vram

echo.
echo Build completed! Check output file.
pause
