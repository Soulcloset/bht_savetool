@echo off
rem Barbie Horse Trails Speedrun Save Replacer Tool
echo The default save directory is C:\Users\YOURNAME\AppData\LocalLow\Outright Games Ltd\barbie
echo.

rem vv black magic from stackoverflow bc pwd doesn't work on windows xdd
FOR /F "tokens=* USEBACKQ" %%g IN (`cd`) do (SET "workingdir=%%g")

echo Your current directory is: %workingdir%
echo If is not the directory where your system.barb is located, please move this tool to the correct directory and run it again.
pause

echo.
echo Available subfolders:
dir /B /A:D

:usersetdir
echo ----------
echo Please enter the name of the directory where your alternate saves are located.
echo Enter the name as shown above (do not enter the full path or any slashes) and press Enter.
set /p shortdir=Directory name: 
set "fullpath=%workingdir%\%shortdir%"

if exist "%fullpath%\" (
    echo.
    echo That path exists, let's goooo
    echo.
) else (
    echo Path does not exist, let's try again.
    echo.
    goto usersetdir
    pause
)

:usersetsave
cd %fullpath%
echo Available saves:
dir /b *.barb

echo ----------
echo Above, you should see the filename of any .barb save files located in %shortdir%.
echo Please enter the name of the save file as shown above (NOT including .barb): 
set /p savename=File name: 
set "savename=%savename%.barb"
set "fullsave=%fullpath%\%savename%"

if exist "%fullsave%" (
    echo.
    echo That file exists!
    echo.
) else (
    echo File does not exist, let's try again.
    echo.
    pause
    goto usersetsave
)

:backup
cls
echo Target save: %savename%
echo ----------
echo.

set "backupdir=%workingdir%\backups"

if exist "%workingdir%\game.barb" (
    rem we have a save already! gotta back it up
    echo The tool has detected a game.barb present in your game directory. Would you like to back it up?
    echo backups are saved to %backupdir%
    echo.

) else (
    echo No save file located. Skipping backup...
    goto copy
)

set /p backupbool=[Y]es/[N]o (default Yes): 
if /I '%backupbool%'=='N' (
    goto copy
)

:backupcheck
if exist "%backupdir%\" (
    echo Backup folder located.
    echo.
) else (
    echo Creating a backup folder...
    mkdir "%backupdir%"
    cd %backupdir%
    goto backupcheck
)

rem now we have to copy game.barb to a backup save
echo Your existing game.barb will be backed up.
echo ----------

:backupdesignation
cd %backupdir%
echo existing saves:
dir /b *.barb
echo Above, you should see the filename of any .barb save files located in your backup folder.
echo Please enter the name to use for your backup (NOT including .barb): 
set /p backupname=File name: 
set "backupname=%backupname%.barb"
set "fullback=%backupdir%\%backupname%"

if exist "%fullback%" (
    echo A save with name %backupname% already exists. Try again!
    goto backupdesignation
) else (
    copy "%workingdir%\game.barb" "%fullback%"
    echo Backed up file successfully!
    pause
)

:copy
del "%workingdir%\game.barb"
copy "%fullsave%" "%workingdir%\game.barb"
echo Your save file has been successfully replaced!

pause