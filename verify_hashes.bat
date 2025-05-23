@echo off
echo.
echo Start time: %TIME%
echo.
echo.

if not exist "C:\Users\buick\hashes" (
    echo ERROR: The 'hashes' directory does not exist at C:\Users\buick
    echo Run generate_hashes.bat before running this script.
    exit /b 1
)

echo Verifying hashes for .gnupg
python C:\Users\buick\scripts\hash_check.py C:\Users\buick\.gnupg\ --verify C:\Users\buick\hashes\dotgnupg.json
echo.
echo.
echo.
echo Verifying hashes for gnupg
python C:\Users\buick\scripts\hash_check.py C:\Users\buick\AppData\Roaming\gnupg\ --verify C:\Users\buick\hashes\gnupg.json
echo.
echo.
echo.
echo Verifying hashes for bin
python C:\Users\buick\scripts\hash_check.py C:\Users\buick\bin\ --verify C:\Users\buick\hashes\bin-hashes.json
echo.
echo.
echo.
echo Verifying hashes for Desktop
python C:\Users\buick\scripts\hash_check.py C:\Users\buick\Desktop\ --verify C:\Users\buick\hashes\desktop-hashes.json
echo.
echo.
echo.
echo Verifying hashes for Pictures
python C:\Users\buick\scripts\hash_check.py C:\Users\buick\Pictures\ --verify C:\Users\buick\hashes\picture-hashes.json
echo.
echo.
echo.
echo Verifying hashes for Documents
python C:\Users\buick\scripts\hash_check.py C:\Users\buick\Documents\ --verify C:\Users\buick\hashes\document-hashes.json
echo.
echo.
echo.
echo Verifying hashes for Music
python C:\Users\buick\scripts\hash_check.py C:\Users\buick\Music\ --verify C:\Users\buick\hashes\music-hashes.json
echo.
echo.
echo.
echo Verifying hashes for Videos
python C:\Users\buick\scripts\hash_check.py C:\Users\buick\Videos\ --verify C:\Users\buick\hashes\video-hashes.json
echo.
echo.
echo.

echo Hash verification complete
echo End time: %TIME%