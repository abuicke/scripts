@echo off
echo Start time: %TIME%

REM Make sure D:\ is my external hard drive by looking for the .HDD file in the root directory
if not exist "D:\HDD" (
    echo ERROR: Couldn't find .HDD file in D:\
    pause
    exit /b
)

echo.
echo ===== gnupg =====
rclone sync C:\Users\buick\AppData\Roaming\gnupg D:\gnupg --dry-run 2>&1 | gawk "!/NOTICE:/ || /Skipped (copy|delete)/" | sed -e "/Skipped copy/ s/^[0-9\/:\ ]*NOTICE: \(.*\): Skipped.*/COPY: \1/" -e "/Skipped delete/ s/^[0-9\/:\ ]*NOTICE: \(.*\): Skipped.*/DELETE: \1/"
echo.

echo.
echo ===== .gnupg =====
rclone sync C:\Users\buick\.gnupg D:\.gnupg --dry-run 2>&1 | gawk "!/NOTICE:/ || /Skipped (copy|delete)/" | sed -e "/Skipped copy/ s/^[0-9\/:\ ]*NOTICE: \(.*\): Skipped.*/COPY: \1/" -e "/Skipped delete/ s/^[0-9\/:\ ]*NOTICE: \(.*\): Skipped.*/DELETE: \1/"
echo.

echo.
echo ===== bin =====
rclone sync C:\Users\buick\bin D:\bin --dry-run 2>&1 | gawk "!/NOTICE:/ || /Skipped (copy|delete)/" | sed -e "/Skipped copy/ s/^[0-9\/:\ ]*NOTICE: \(.*\): Skipped.*/COPY: \1/" -e "/Skipped delete/ s/^[0-9\/:\ ]*NOTICE: \(.*\): Skipped.*/DELETE: \1/"
echo.

echo.
echo ===== Desktop =====
rclone sync C:\Users\buick\Desktop D:\Desktop --dry-run 2>&1 | gawk "!/NOTICE:/ || /Skipped (copy|delete)/" | sed -e "/Skipped copy/ s/^[0-9\/:\ ]*NOTICE: \(.*\): Skipped.*/COPY: \1/" -e "/Skipped delete/ s/^[0-9\/:\ ]*NOTICE: \(.*\): Skipped.*/DELETE: \1/"
echo.

echo.
echo ===== Documents =====
rclone sync C:\Users\buick\Documents D:\Documents --dry-run 2>&1 | gawk "!/NOTICE:/ || /Skipped (copy|delete)/" | sed -e "/Skipped copy/ s/^[0-9\/:\ ]*NOTICE: \(.*\): Skipped.*/COPY: \1/" -e "/Skipped delete/ s/^[0-9\/:\ ]*NOTICE: \(.*\): Skipped.*/DELETE: \1/"
echo.

echo.
echo ===== Music =====
rclone sync C:\Users\buick\Music D:\Music --dry-run 2>&1 | gawk "!/NOTICE:/ || /Skipped (copy|delete)/" | sed -e "/Skipped copy/ s/^[0-9\/:\ ]*NOTICE: \(.*\): Skipped.*/COPY: \1/" -e "/Skipped delete/ s/^[0-9\/:\ ]*NOTICE: \(.*\): Skipped.*/DELETE: \1/"
echo.

echo.
echo ===== Pictures =====
rclone sync C:\Users\buick\Pictures D:\Pictures --dry-run 2>&1 | gawk "!/NOTICE:/ || /Skipped (copy|delete)/" | sed -e "/Skipped copy/ s/^[0-9\/:\ ]*NOTICE: \(.*\): Skipped.*/COPY: \1/" -e "/Skipped delete/ s/^[0-9\/:\ ]*NOTICE: \(.*\): Skipped.*/DELETE: \1/"
echo.

echo.
echo ===== Videos =====
rclone sync C:\Users\buick\Videos D:\Videos --dry-run 2>&1 | gawk "!/NOTICE:/ || /Skipped (copy|delete)/" | sed -e "/Skipped copy/ s/^[0-9\/:\ ]*NOTICE: \(.*\): Skipped.*/COPY: \1/" -e "/Skipped delete/ s/^[0-9\/:\ ]*NOTICE: \(.*\): Skipped.*/DELETE: \1/"
echo.

echo Proceed with sync?
pause

echo Syncing...

echo End time: %TIME%
pause