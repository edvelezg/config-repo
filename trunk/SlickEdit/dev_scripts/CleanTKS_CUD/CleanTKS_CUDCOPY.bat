rem README: For the PsExec commmand to work correlcty. The user id 
rem egutarra or whatever user is running the script needs to be added to the
rem remote desktop user group. Also, the remote machine full name needs to be
rem specified, tks2014-sql-dev.openspirit.com.

rem \\tks2014-sql-dev\scripts:
rem This will run the script run_cudcopy.bat in the TKS2014-SQL-DEV vm. 
rem The contents of run_cudcopy .bat are as follows:
rem     sqlcmd -S TKS2014-SQL-DEV -i C:\scripts\clear_tkscudcopy.sql
rem The contents of clear_tkscudcopy.sql are as follows:
rem     RESTORE DATABASE [TKS_CUD_1] FROM  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\MSSQL\Backup\TKS_CUD_1.bak' WITH  FILE = 3,  NOUNLOAD,  REPLACE,  STATS = 10
rem     GO

cd C:\Program Files\OpenSpirit\v4.1\bin\etc 
CALL dataprovider.bat Kingdom 2015 Kingdom_2015 TKS_CUD_COPY stop
@echo on
pushd \\tks2014-sql-dev\KingdomData
cd TKS_CUD_COPY
git status
git checkout -f
git clean -f
rem delete contents in BulkData for the given project
cd ..\BulkData
for /d %%i in (TKS_CUD_COPY*) do rd /Q /S "%%i"
popd
set Path=%Path%;C:\dev\scripts\CleanTKS_CUD\PSTools
rem EGV 6/8/2015: Firewall change from a month ago has made TKS2014-SQL-DEV invalid, now need to specify TKS2014-SQL-DEV.openspirit.com
PsExec \\TKS2014-SQL-DEV.openspirit.com -u sql -p OpenSpirit! C:\scripts\run_cudcopy.bat
pause
