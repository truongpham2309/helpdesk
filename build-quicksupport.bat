@echo off
REM Build script for HelpDesk QuickSupport variant
REM This creates a portable version without installation requirement and license check bypass

echo ========================================
echo Building HelpDesk QuickSupport
echo ========================================

REM Step 1: Backup original .env file
echo [1/5] Backing up original .env...
if exist flutter\.env (
    copy /Y flutter\.env flutter\.env.backup
)

REM Step 2: Switch to quicksupport .env
echo [2/5] Switching to QuickSupport environment...
copy /Y flutter\.env.quicksupport flutter\.env

REM Step 3: Build with portable flag
echo [3/5] Building Flutter Windows portable...
python build.py --flutter --portable --hwcodec --vram

REM Step 4: Restore original .env
echo [4/5] Restoring original environment...
if exist flutter\.env.backup (
    copy /Y flutter\.env.backup flutter\.env
    del flutter\.env.backup
)

REM Step 5: Rename output
echo [5/5] Renaming output file...
for /f "tokens=2 delims==" %%a in ('findstr "^version" Cargo.toml') do set VERSION=%%a
set VERSION=%VERSION:"=%
set VERSION=%VERSION: =%

if exist helpdesk-%VERSION%-install.exe (
    ren helpdesk-%VERSION%-install.exe helpdesk-%VERSION%-quicksupport.exe
    echo.
    echo ========================================
    echo BUILD SUCCESSFUL!
    echo Output: helpdesk-%VERSION%-quicksupport.exe
    echo ========================================
) else (
    echo.
    echo ========================================
    echo BUILD FAILED - Output file not found
    echo ========================================
)

pause
