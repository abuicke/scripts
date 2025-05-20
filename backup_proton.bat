@echo off
echo.
echo Start time: %TIME%
echo.
echo.

echo ===== .gnupg =====
rclone sync C:\Users\buick\.gnupg proton:\.gnupg -v

echo.
echo.
echo.
echo ===== gnupg =====
rclone sync C:\Users\buick\AppData\Roaming\gnupg proton:\gnupg -v

echo.
echo.
echo.
echo ===== bin =====
rclone sync C:\Users\buick\bin proton:\bin -v

echo.
echo.
echo.
echo ===== Desktop =====
rclone sync C:\Users\buick\Desktop proton:\Desktop -v --exclude "~*" --exclude "desktop.ini" --exclude ".tmp.driveupload/**"

echo.
echo.
echo.
echo ===== Documents =====
rclone sync C:\Users\buick\Documents proton:\Documents -v --exclude "~*" --exclude "desktop.ini" --exclude "My Pictures" --exclude "My Music" --exclude "My Videos"

echo.
echo.
echo.
echo ===== Music =====
rclone sync C:\Users\buick\Music proton:\Music -v --exclude "~*" --exclude "desktop.ini"

echo.
echo.
echo.
echo ===== Pictures =====
rclone sync C:\Users\buick\Pictures proton:\Pictures -v --exclude "~*" --exclude "desktop.ini"

echo.
echo.
echo.
echo ===== Videos =====
rclone sync C:\Users\buick\Videos proton:\Videos -v --exclude "~*" --exclude "desktop.ini"

echo.
echo.
echo.
echo Sync complete
echo End time: %TIME%