@echo off
echo %~dps0
echo "%~dp0%~n0%~x0"

start http://localhost:10010/

netstat -a -n -o | findstr :12000
FOR /F "tokens=4 delims= " %%P IN ('netstat -a -n -o ^| findstr :12000') DO @ECHO TaskKill.exe /PID %%P

pause
