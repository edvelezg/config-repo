@echo off
rem xcopy /Y "C:\dev\OpenSpiritProject-v4.0\source\bin\Windows_x86_32\kingdom8.8\osp_Kingdom.dll"                             "C:\Program Files\OpenSpirit\v4.0\bin\windows_x86_32\kingdom8.8"
rem xcopy /Y "C:\dev\OpenSpiritProject-v4.0\source\src\Windows\Runtime\MSDEV2010\osp_Kingdom_88_Release\osp_Kingdom_88.pdb"   "C:\Program Files\OpenSpirit\v4.0\bin\windows_x86_32\kingdom8.8\"
rem echo d | xcopy /Y /I "C:\dev\Prod.DC.Kingdom.Dev\lib\Windows_x86_64\2015\Kingdom.dll"                                     "C:\Program Files\OpenSpirit\v4.1\plugins\Kingdom_2015\Windows_x86_64"
rem echo d | xcopy /Y /I "C:\dev\Prod.DC.Kingdom.Dev\lib\Windows_x86_64\2015\Kingdom.pdb"                                     "C:\Program Files\OpenSpirit\v4.1\plugins\Kingdom_2015\Windows_x86_64"
rem echo d | xcopy /Y /I "C:\dev\Prod.DC.Kingdom.Dev\C++\VS10\Kingdom_2015\Debug\vc100.pdb"                                   "C:\Program Files\OpenSpirit\v4.1\plugins\Kingdom_2015\Windows_x86_64"
rem explorer "C:\Program Files\OpenSpirit\v4.2\plugins\Kingdom_8\Windows_x86_64\8.8"

echo d | xcopy /Y /I "C:\dev\Prod.OpenSpirit.Dev\dev\3rdparty\OspLegacy\src\VS10\x64\Debug\vc100.pdb" "C:\Program Files\OpenSpirit\v4.2\plugins\Kingdom_2015\Windows_x86_64"

echo d | xcopy /Y /I "C:\dev\Prod.DC.Kingdom.Dev\lib\Windows_x86_64\2015\Kingdom.dll"      "C:\Program Files\OpenSpirit\v4.2\plugins\Kingdom_2015\Windows_x86_64"
echo d | xcopy /Y /I "C:\dev\Prod.DC.Kingdom.Dev\lib\Windows_x86_64\2015\Kingdom.pdb"      "C:\Program Files\OpenSpirit\v4.2\plugins\Kingdom_2015\Windows_x86_64"
echo d | xcopy /Y /I "C:\dev\Prod.DC.Kingdom.Dev\C++\VS10\Kingdom_2015\Debug\vc100.pdb"    "C:\Program Files\OpenSpirit\v4.2\plugins\Kingdom_2015\Windows_x86_64"

echo d | xcopy /Y /I "C:\dev\Prod.DC.Kingdom.Dev\lib\Windows_x86_64\8.8\Kingdom.dll"       "C:\Program Files\OpenSpirit\v4.2\plugins\Kingdom_8\Windows_x86_64\8.8"
echo d | xcopy /Y /I "C:\dev\Prod.DC.Kingdom.Dev\lib\Windows_x86_64\8.8\Kingdom.pdb"       "C:\Program Files\OpenSpirit\v4.2\plugins\Kingdom_8\Windows_x86_64\8.8"

explorer "C:\Program Files\OpenSpirit\v4.2\plugins\Kingdom_2015\Windows_x86_64"
pause
