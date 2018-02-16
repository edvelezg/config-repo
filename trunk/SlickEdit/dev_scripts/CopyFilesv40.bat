rem xcopy /Y "C:\dev\OpenSpiritProject-v4.0\source\bin\Windows_x86_32\kingdom8.8\osp_Kingdom.dll"                             "C:\Program Files\OpenSpirit\v4.0\bin\windows_x86_32\kingdom8.8"
rem xcopy /Y "C:\dev\OpenSpiritProject-v4.0\source\src\Windows\Runtime\MSDEV2010\osp_Kingdom_88_Release\osp_Kingdom_88.pdb"   "C:\Program Files\OpenSpirit\v4.0\bin\windows_x86_32\kingdom8.8\"

echo d | xcopy /Y /I "C:\dev\OpenSpiritProject-v4.0\source\bin\Windows_x86_64\kingdom8.8\osp_Kingdom.dll"            "C:\Program Files\OpenSpirit\v4.0\bin\Windows_x86_64\kingdom8.8"
echo d | xcopy /Y /I "C:\dev\OpenSpiritProject-v4.0\source\bin\Windows_x86_64\kingdom8.8\osp_Kingdom.pdb"            "C:\Program Files\OpenSpirit\v4.0\bin\Windows_x86_64\kingdom8.8"

echo d | xcopy /Y /I "C:\dev\OpenSpiritProject-v4.0\source\bin\Windows_x86_64\kingdom2015\osp_Kingdom.dll"           "C:\Program Files\OpenSpirit\v4.0\bin\Windows_x86_64\kingdom2015"
echo f | xcopy /Y /I "C:\dev\OpenSpiritProject-v4.0\source\src\Windows\Runtime\MSDEV2010\osp_Kingdom_2015_64_Release\osp_Kingdom_2015_64.pdb"           "C:\Program Files\OpenSpirit\v4.0\bin\Windows_x86_64\kingdom2015\osp_Kingdom.pdb"

explorer C:\Program Files\OpenSpirit\v4.0\bin\Windows_x86_64\kingdom2015

pause

