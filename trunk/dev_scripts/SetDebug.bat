rem xcopy /Y "C:\dev\OpenSpiritProject-v4.0\source\bin\Windows_x86_32\kingdom8.8\osp_Kingdom.dll"                             "C:\Program Files\OpenSpirit\v4.0\bin\windows_x86_32\kingdom8.8"
rem xcopy /Y "C:\dev\OpenSpiritProject-v4.0\source\src\Windows\Runtime\MSDEV2010\osp_Kingdom_88_Release\osp_Kingdom_88.pdb"   "C:\Program Files\OpenSpirit\v4.0\bin\windows_x86_32\kingdom8.8\"

cd "C:\Program Files\OpenSpirit\v4.2\plugins\Kingdom_2015"
if exist InvocationContext.xml (
echo exists
   mv InvocationContext.xml InvocationContext.xml.b
) else (
   if exist InvocationContext.xml.b (
      mv InvocationContext.xml.b InvocationContext.xml
   )
)

rem cd "C:\Program Files\OpenSpirit\v4.1\plugins\Kingdom_2015"
rem mv InvocationContext.xml InvocationContext.xml.b
rem 
rem cd "C:\Users\egutarra\AppData\Local\OpenSpirit\v4.2"
rem mv osp.debug osp.debug.b

explorer "C:\Program Files\OpenSpirit\v4.2\plugins\Kingdom_2015"
pause
