@REM NOTE: DOES NOT FULLY WORK
@REM Copyright (c) 2018 TIBCO Software Inc. All Rights Reserved. 
@REM https://stackoverflow.com/questions/6359820/how-to-SET-commands-output-as-a-variable-in-a-batch-file

@echo off
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

SET SCRIPT_DIR=%CD%
cd ..\
SET PROJECT_DIR=%CD%

FOR /F "tokens=* USEBACKQ" %%F IN (`cygpath %PROJECT_DIR%`) DO (
SET CygwinDir=%%F
)

SET /p Primary=Enter the name of the machine to mirror: 
mkdir "%Primary%"
cd "%Primary%"

echo *.class> .gitignore
echo *.#ds_updatecache>>.gitignore
echo *.#dsDirID>>.gitignore
echo *.#dslock>>.gitignore
echo *.1>>.gitignore
echo *.bfc>>.gitignore
echo *.cfg>>.gitignore
echo *.dat>>.gitignore
echo *.data>>.gitignore
echo *.a>>.gitignore
echo *.so>>.gitignore
echo *.png>>.gitignore
echo *.gif>>.gitignore
echo *.vpwhist>>.gitignore
echo *.vtg>>.gitignore
echo *.java>>.gitignore


SET /p UnixHome=Enter the directory in the machine you would like to mirror [/opt/qa]:
if "%UnixHome%" == "" (
    SET UnixHome=/opt/qa
)

@REM https://stackoverflow.com/questions/17279114/split-path-and-take-last-folder-name-in-batch-script
@REM Split path and take last folder name in batch script
for %%f in (%UnixHome%) do set MirrorFolder=%%~nxf
echo Mirror folder will be: %MirrorFolder%

echo rsync -avz --exclude '.git' --exclude 'lost+found' --delete qa@%Primary%:%UnixHome%/* %CygwinDir%/%Primary%/%MirrorFolder% > pull.bat

SET /p Engine=Enter the name of the corresponding Engine machine []: 
IF NOT "%Engine%" == "" (
   mkdir %Engine%

   SET /p "EngineHome=Enter the directory in the engine you would like to mirror [/opt/qa/engine]:"
   ECHO EngineHome: !EngineHome!
   IF "!EngineHome!" EQU "" (
       SET EngineHome=/opt/qa/engine
   )

   for %%f in (%EngineHome%) do set EngineMirrorFolder=%%~nxf
   echo Engine Mirror Folder will be: %EngineMirrorFolder%


   echo rsync -avz --exclude '.git' --delete qa@%Engine%:%EngineHome%/* %CygwinDir%/%Primary%/%Engine%/%EngineMirrorFolder% >> pull.bat
)

echo [Settings] > rsync.ini
echo # Values to work with Rsync macros on slickedit >> rsync.ini
echo Primary=%Primary% >> rsync.ini
echo PrimaryDir=%UnixHome% >> rsync.ini

SET /p User=Enter the user name of the Primary machine [qa]:
if "%User%" == "" (
    SET User=qa
)
echo ssh-copy-id %User%@%Primary%
bash -c "ssh-copy-id %User%@%Primary%"

"C:\Program Files\TortoiseGit\bin\TortoiseGitProc.exe" /command:repocreate
"C:\Program Files\TortoiseGit\bin\TortoiseGitProc.exe" /command:ignore /path:"%CD%\%Primary%.vtg*%CD%\%Primary%.vpwhist" /logmsg:"SE files to be ignored" /closeonend:2
"C:\Program Files\TortoiseGit\bin\TortoiseGitProc.exe" /command:commit /path:"%CD%\.gitignore" /logmsg:"SE files to be ignored" /closeonend:2

rem Copy all profile files to make bash easier
scp -r %SCRIPT_DIR%\buildMirrorProj\.bash_profile %User%@%Primary%:/home/qa
scp -r %SCRIPT_DIR%\buildMirrorProj\.aliases %User%@%Primary%:/home/qa
scp -r %SCRIPT_DIR%\buildMirrorProj\.functions %User%@%Primary%:/home/qa

ENDLOCAL
