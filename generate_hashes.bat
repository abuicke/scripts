@echo off
if exist "C:\Users\buick\hashes" (
    echo Error: The 'hashes' directory already exists.
    pause
    exit /b 1
) else (
    mkdir "C:\Users\buick\hashes"
    echo Created directory: C:\Users\buick\hashes
)

echo Generating hashes for Pictures
python C:\Users\buick\scripts\hash_check.py C:\Users\buick\Pictures\ --generate C:\Users\buick\hashes\picture-hashes.json
echo Generating hashes for Documents
python C:\Users\buick\scripts\hash_check.py C:\Users\buick\Documents\ --generate C:\Users\buick\hashes\document-hashes.json
echo Generating hashes for Music
python C:\Users\buick\scripts\hash_check.py C:\Users\buick\Music\ --generate C:\Users\buick\hashes\music-hashes.json
echo Generating hashes for Videos
python C:\Users\buick\scripts\hash_check.py C:\Users\buick\Videos\ --generate C:\Users\buick\hashes\video-hashes.json
echo Generating hashes for bin
python C:\Users\buick\scripts\hash_check.py C:\Users\buick\bin\ --generate C:\Users\buick\hashes\bin-hashes.json
echo Generating hashes for .gnupg
python C:\Users\buick\scripts\hash_check.py C:\Users\buick\.gnupg\ --generate C:\Users\buick\hashes\dotgnupg.json
echo Generating hashes for gnupg
python C:\Users\buick\scripts\hash_check.py C:\Users\buick\AppData\Roaming\gnupg\ --generate C:\Users\buick\hashes\gnupg.json

echo Hash generation complete
pause