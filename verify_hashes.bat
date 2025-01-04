@echo off
setlocal EnableDelayedExpansion

if "%1"=="" (
    echo Error: Please specify a location [local^|HDD^|SSD]
    echo Example: verify_hashes.bat local
    exit /b 1
)

if /i "%1"=="local" (
    set "BASE_PATH=C:\Users\buick"
    set "GNUPG_PATH=!BASE_PATH!\AppData\Roaming\gnupg"
) else if /i "%1"=="HDD" (
    set "BASE_PATH=E:\laptop"
    set "GNUPG_PATH=!BASE_PATH!\gnupg"
) else if /i "%1"=="SSD" (
    set "BASE_PATH=D:\laptop"
    set "GNUPG_PATH=!BASE_PATH!\gnupg"
) else (
    echo Error: Invalid location specified. Use local, HDD, or SSD
    exit /b 1
)

if not exist "C:\Users\buick\hashes" (
    echo Error: The 'hashes' directory does not exist at C:\Users\buick
    echo Please create the directory before running this script.
    pause
    exit /b 1
)

echo Using base path: !BASE_PATH!
echo.

echo Verifying hashes for Pictures
python C:\Users\buick\scripts\hash_check.py !BASE_PATH!\Pictures\ --verify C:\Users\buick\hashes\picture-hashes.json
echo.
echo.
echo.
echo Verifying hashes for Documents
python C:\Users\buick\scripts\hash_check.py !BASE_PATH!\Documents\ --verify C:\Users\buick\hashes\document-hashes.json
echo.
echo.
echo.
echo Verifying hashes for Music
python C:\Users\buick\scripts\hash_check.py !BASE_PATH!\Music\ --verify C:\Users\buick\hashes\music-hashes.json
echo.
echo.
echo.
echo Verifying hashes for Videos
python C:\Users\buick\scripts\hash_check.py !BASE_PATH!\Videos\ --verify C:\Users\buick\hashes\video-hashes.json
echo.
echo.
echo.
echo Verifying hashes for bin
python C:\Users\buick\scripts\hash_check.py !BASE_PATH!\bin\ --verify C:\Users\buick\hashes\bin-hashes.json
echo.
echo.
echo.
echo Verifying hashes for .gnupg
python C:\Users\buick\scripts\hash_check.py !BASE_PATH!\.gnupg\ --verify C:\Users\buick\hashes\dotgnupg.json
echo.
echo.
echo.
echo Verifying hashes for gnupg
python C:\Users\buick\scripts\hash_check.py !GNUPG_PATH!\ --verify C:\Users\buick\hashes\gnupg.json

echo Hash verification complete
pause