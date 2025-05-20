@echo off
echo.
echo Start time: %TIME%
echo.
echo.

if not exist "D:\" (
    echo ERROR: Couldn't find drive D:\
    echo Exiting...
    exit /b 1
)

if not exist "D:\HDD" (
    echo ERROR: Couldn't verify identity of drive D:\
    echo Exiting...
    exit /b 1
)

if not exist "D:\hashes" (
    echo ERROR: The 'hashes' directory does not exist at D:\hashes
    echo Please run generate_hashes.bat before running this script.
    echo Exiting...
    exit /b 1
)

echo Verifying hashes for .gnupg
python D:\scripts\hash_check.py D:\.gnupg\ --verify D:\hashes\dot-gnupg-hashes.json
echo.
echo.
echo.
echo Verifying hashes for gnupg
python D:\scripts\hash_check.py D:\gnupg --verify D:\hashes\gnupg-hashes.json
echo.
echo.
echo.
echo Verifying hashes for bin
python D:\scripts\hash_check.py D:\bin\ --verify D:\hashes\bin-hashes.json
echo.
echo.
echo.
echo Verifying hashes for Desktop
python D:\scripts\hash_check.py D:\Desktop --verify D:\hashes\desktop-hashes.json
echo.
echo.
echo.
echo Verifying hashes for Documents
python D:\scripts\hash_check.py D:\Documents --verify D:\hashes\documents-hashes.json
echo.
echo.
echo.
echo Verifying hashes for Music
python D:\scripts\hash_check.py D:\Music --verify D:\hashes\music-hashes.json
echo.
echo.
echo.
echo Verifying hashes for Pictures
python D:\scripts\hash_check.py D:\Pictures --verify D:\hashes\pictures-hashes.json
echo.
echo.
echo.
echo Verifying hashes for Videos
python D:\scripts\hash_check.py D:\Videos --verify D:\hashes\videos-hashes.json
echo.
echo.
echo.
echo Hash verification complete
echo End time: %TIME%