cd C:\tibco\ftl\5.2\bin
start cmd /k tibrealmserver.bat --http localhost:12000
netstat -a -n -o | findstr :12000

sleep 5

cd C:\tibco\ftl\5.2\samples\src\java
call ..\..\setup.bat
start cmd /k java com.tibco.ftl.samples.TibRecv

rem sleep 10
rem 
rem start http://localhost:10010/

rem for /f "TOKENS=1" %a in ('wmic PROCESS where "Name='cmd'" get ProcessID ^| findstr [0-9]') do set MyPID=%a
rem echo  %MyPID%
