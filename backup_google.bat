@echo off
echo Start time: %TIME%

echo.
echo ===== gnupg =====
rclone sync C:\Users\buick\AppData\Roaming\gnupg google:\gnupg -v

echo.
echo.
echo.
echo ===== .gnupg =====
rclone sync C:\Users\buick\.gnupg google:\.gnupg -v

echo.
echo.
echo.
echo ===== bin =====
rclone sync C:\Users\buick\bin google:\bin -v

echo.
echo.
echo.
echo ===== Desktop =====
rclone sync C:\Users\buick\Desktop google:\Desktop -v --exclude "~*" --exclude "desktop.ini" --exclude ".tmp.driveupload/**"

echo.
echo.
echo.
echo ===== Documents =====
rclone sync C:\Users\buick\Documents google:\Documents -v --exclude "~*" --exclude "desktop.ini" --exclude "My Pictures" --exclude "My Music" --exclude "My Videos"

echo.
echo.
echo.
echo ===== Music =====
rclone sync C:\Users\buick\Music google:\Music -v --exclude "~*" --exclude "desktop.ini"

echo.
echo.
echo.
echo ===== Pictures =====
rclone sync C:\Users\buick\Pictures google:\Pictures -v --exclude "~*" --exclude "desktop.ini"

echo.
echo.
echo.
echo ===== Videos =====
rclone sync C:\Users\buick\Videos google:\Videos -v --exclude "~*" --exclude "desktop.ini"

echo.
echo.
echo.
echo Sync complete...
echo End time: %TIME%