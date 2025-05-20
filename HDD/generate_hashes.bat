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

if exist "D:\hashes" (
    echo ERROR: The 'hashes' directory already exists.
    echo Exiting...
    exit /b 1
) else (
    mkdir "D:\hashes"
    echo Created directory: D:\hashes
)

echo Generating hashes for .gnupg
python D:\scripts\hash_check.py D:\.gnupg --generate D:\hashes\dot-gnupg-hashes.json

echo Generating hashes for gnupg
python D:\scripts\hash_check.py D:\gnupg --generate D:\hashes\gnupg-hashes.json

echo Generating hashes for bin
python D:\scripts\hash_check.py D:\bin --generate D:\hashes\bin-hashes.json

echo Generating hashes for Desktop
python D:\scripts\hash_check.py D:\Desktop --generate D:\hashes\desktop-hashes.json

echo Generating hashes for Documents
python D:\scripts\hash_check.py D:\Documents --generate D:\hashes\documents-hashes.json

echo Generating hashes for Music
python D:\scripts\hash_check.py D:\Music --generate D:\hashes\music-hashes.json

echo Generating hashes for Pictures
python D:\scripts\hash_check.py D:\Pictures --generate D:\hashes\pictures-hashes.json

echo Generating hashes for Videos
python D:\scripts\hash_check.py D:\Videos --generate D:\hashes\videos-hashes.json

echo Generating hashes for damien echols
python D:\scripts\hash_check.py "D:\damien echols" --generate D:\hashes\damien-echols-hashes.json

echo Generating hashes for magic
python D:\scripts\hash_check.py D:\magic --generate D:\hashes\magic-hashes.json

echo Generating hashes for vault
python D:\scripts\hash_check.py D:\vault --generate D:\hashes\vault-hashes.json

echo Generating hashes for workout
python D:\scripts\hash_check.py D:\workout --generate D:\hashes\workout-hashes.json

echo Generating hashes for yoga
python D:\scripts\hash_check.py D:\yoga --generate D:\hashes\yoga-hashes.json

echo.
echo Hash generation complete
echo End time: %TIME%