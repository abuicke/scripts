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
    exit /b 1
)

echo.
echo ===== .gnupg =====
rclone sync C:\Users\buick\.gnupg D:\.gnupg --dry-run 2>&1 | gawk "!/NOTICE:/ || /Skipped (copy|delete)/" | sed -e "/Skipped copy/ s/^[0-9\/:\ ]*NOTICE: \(.*\): Skipped.*/COPY: \1/" -e "/Skipped delete/ s/^[0-9\/:\ ]*NOTICE: \(.*\): Skipped.*/DELETE: \1/"
echo.

echo Proceed with sync?
pause

rclone sync C:\Users\buick\.gnupg D:\.gnupg



echo.
echo.
echo.
echo ===== gnupg =====
rclone sync C:\Users\buick\AppData\Roaming\gnupg D:\gnupg --dry-run 2>&1 | gawk "!/NOTICE:/ || /Skipped (copy|delete)/" | sed -e "/Skipped copy/ s/^[0-9\/:\ ]*NOTICE: \(.*\): Skipped.*/COPY: \1/" -e "/Skipped delete/ s/^[0-9\/:\ ]*NOTICE: \(.*\): Skipped.*/DELETE: \1/"
echo.

echo Proceed with sync?
pause

rclone sync C:\Users\buick\AppData\Roaming\gnupg D:\gnupg



echo.
echo.
echo.
echo ===== bin =====
rclone sync C:\Users\buick\bin D:\bin --dry-run 2>&1 | gawk "!/NOTICE:/ || /Skipped (copy|delete)/" | sed -e "/Skipped copy/ s/^[0-9\/:\ ]*NOTICE: \(.*\): Skipped.*/COPY: \1/" -e "/Skipped delete/ s/^[0-9\/:\ ]*NOTICE: \(.*\): Skipped.*/DELETE: \1/"
echo.

echo Proceed with sync?
pause

rclone sync C:\Users\buick\bin D:\bin



echo.
echo.
echo.
echo ===== Desktop =====
rclone sync C:\Users\buick\Desktop D:\Desktop --dry-run --exclude "~*" --exclude "desktop.ini" --exclude ".tmp.driveupload/**" 2>&1 | gawk "!/NOTICE:/ || /Skipped (copy|delete)/" | sed -e "/Skipped copy/ s/^[0-9\/:\ ]*NOTICE: \(.*\): Skipped.*/COPY: \1/" -e "/Skipped delete/ s/^[0-9\/:\ ]*NOTICE: \(.*\): Skipped.*/DELETE: \1/"
echo.

echo Proceed with sync?
pause

rclone sync C:\Users\buick\Desktop D:\Desktop --exclude "~*" --exclude "desktop.ini" --exclude ".tmp.driveupload/**"



echo.
echo.
echo.
echo ===== Documents =====
rclone sync C:\Users\buick\Documents D:\Documents --exclude "~*" --dry-run --exclude "desktop.ini" --exclude "My Pictures" --exclude "My Music" --exclude "My Videos" 2>&1 | gawk "!/NOTICE:/ || /Skipped (copy|delete)/" | sed -e "/Skipped copy/ s/^[0-9\/:\ ]*NOTICE: \(.*\): Skipped.*/COPY: \1/" -e "/Skipped delete/ s/^[0-9\/:\ ]*NOTICE: \(.*\): Skipped.*/DELETE: \1/"
echo.

echo Proceed with sync?
pause

rclone sync C:\Users\buick\Documents D:\Documents --exclude "~*" --exclude "desktop.ini" --exclude "My Pictures" --exclude "My Music" --exclude "My Videos"



echo.
echo.
echo.
echo ===== Music =====
rclone sync C:\Users\buick\Music D:\Music --dry-run --exclude "~*" --exclude "desktop.ini" 2>&1 | gawk "!/NOTICE:/ || /Skipped (copy|delete)/" | sed -e "/Skipped copy/ s/^[0-9\/:\ ]*NOTICE: \(.*\): Skipped.*/COPY: \1/" -e "/Skipped delete/ s/^[0-9\/:\ ]*NOTICE: \(.*\): Skipped.*/DELETE: \1/"
echo.

echo Proceed with sync?
pause

rclone sync C:\Users\buick\Music D:\Music --exclude "~*" --exclude "desktop.ini"



echo.
echo.
echo.
echo ===== Pictures =====
rclone sync C:\Users\buick\Pictures D:\Pictures --dry-run --exclude "~*" --exclude "desktop.ini" 2>&1 | gawk "!/NOTICE:/ || /Skipped (copy|delete)/" | sed -e "/Skipped copy/ s/^[0-9\/:\ ]*NOTICE: \(.*\): Skipped.*/COPY: \1/" -e "/Skipped delete/ s/^[0-9\/:\ ]*NOTICE: \(.*\): Skipped.*/DELETE: \1/"
echo.

echo Proceed with sync?
pause

rclone sync C:\Users\buick\Pictures D:\Pictures --exclude "~*" --exclude "desktop.ini"



echo.
echo.
echo.
echo ===== Videos =====
rclone sync C:\Users\buick\Videos D:\Videos --dry-run --exclude "~*" --exclude "desktop.ini" 2>&1 | gawk "!/NOTICE:/ || /Skipped (copy|delete)/" | sed -e "/Skipped copy/ s/^[0-9\/:\ ]*NOTICE: \(.*\): Skipped.*/COPY: \1/" -e "/Skipped delete/ s/^[0-9\/:\ ]*NOTICE: \(.*\): Skipped.*/DELETE: \1/"
echo.

echo Proceed with sync?
pause

rclone sync C:\Users\buick\Videos D:\Videos --exclude "~*" --exclude "desktop.ini"


echo.
echo.
echo.
echo Sync complete
echo End time: %TIME%