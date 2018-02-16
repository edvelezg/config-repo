:Variables
SET LogFilesPath=C:\Users\egutarra\AppData\Local\OpenSpirit\v4.2\logs\DataServer\Kingdom_2015

echo.
echo Restore WebServer Database
FOR /F "delims=|" %%I IN ('DIR "%LogFilesPath%\*.log" /B /O:D') DO SET NewestFile=%%I
echo The most recently created file is %LogFilesPath%\%NewestFile%
vs %LogFilesPath%\%NewestFile%

