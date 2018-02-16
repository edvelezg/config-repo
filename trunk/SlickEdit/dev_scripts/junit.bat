@echo off
REM This script calls the junit data query program for validating data. 
REM To run this program, the following is needed:  
REM TestScope.xml - File containing the queries to run for a particular test case. This file will need to reside in the 
REM                 %OSP_TEST_DIR%\tests\RegressionTestFiles\data\query\%OSP_TESTSCOPE_DIR% directory. This is typically found at
REM                 \\osp1\pdata\testing\junit\tests\RegressionTestFiles\data\query\"test case name".
REM
REM DGD (04/10/2015) - Initial script.
REM DGD (06/17/2015) - Add the keyword "Error" to the error messages.
REM DGD (06/26/2015) - Change how we determine the build number.   

REM We check for 2 arguments.
set /a ARG_COUNT=0
for %%A in (%*) do set /a ARG_COUNT+=1
if %ARG_COUNT% gtr 1 goto ENOUGH_ARGS
   echo Error: At least 2 parameters (osp_test_dir, osp_testscope_dir) are requied to run the script.  
   echo. 
   goto USAGE   
:ENOUGH_ARGS


REM Initial variables
set OSP_VERS=
set OSP_HOME=
set OSP_CONFIG=
set OSP_BLD_DIR=
set OSP_JRE=DIR=
set EXIT_CODE=0
set OSP_TEST_DIR=%1
set OSP_TESTSCOPE_DIR=%2 


REM Check Windows Version so you can set the config directory
REM If no OpenSpirit version is passed then we assume the latest (4.1).
if "%3" == "" goto SET_OSP_VERS_DEFAULT 
   set OSP_VERS=%3
   goto :OSP_VERS_SET
:SET_OSP_VERS_DEFAULT
   set OSP_VERS=4.1
:OSP_VERS_SET
REM Check for Windows XP (32-bit)
ver | findstr /i "5\.1\." > nul
if %errorlevel% equ 0 set OSP_CONFIG=C:\Documents and Settings\All Users\Application Data\OpenSpirit\v%OSP_VERS%
REM Check for Windows XP (64-bit)
ver | findstr /i "5\.2\." > nul
if %errorlevel% equ 0 set OSP_CONFIG=C:\Documents and Settings\All Users\Application Data\OpenSpirit\v%OSP_VERS%
REM Check for Windows Vista
ver | findstr /i "6\.0\." > nul
if %errorlevel% equ 0 set OSP_CONFIG=C:\ProgramData\OpenSpirit\v%OSP_VERS%
REM Check for Windows 7
ver | findstr /i "6\.1\." > nul
if %errorlevel% equ 0 set OSP_CONFIG=C:\ProgramData\OpenSpirit\v%OSP_VERS%
if exist "%OSP_CONFIG%\config.properties" goto OSP_CONFIG_FILE_FOUND
   echo Error: OpenSpirit config file (%OSP_CONFIG%\config.properties) is missing and is needed for execution. 
   echo.
   set EXIT_CODE=1    
   goto USAGE    
:OSP_CONFIG_FILE_FOUND
for /f "tokens=1-2 delims==" %%A in ('find /N "HOME=" "%OSP_CONFIG%"\config.properties') do set OSP_HOME=%%B
REM Remove extra backspace in front of the drive letter.
set OSP_HOME=%OSP_HOME:\:=:%


REM Check for the root directory where the junit data query program expects all xml files to reside.
if exist "%OSP_TEST_DIR%\tests\RegressionTestFiles\data/query\%OSP_TESTSCOPE_DIR%" goto JUNIT_DIR_FOUND
   echo Error: Directory (%OSP_TEST_DIR%\RegressionTestFiles\data\query\%OSP_TESTSCOPE_DIR%) needed for the junit data query program could not be found. 
   echo.
   set EXIT_CODE=1    
   goto USAGE  
:JUNIT_DIR_FOUND


REM Determine whether you are running on a 32-bit or 64-bit machine. Set the jre path based upon that. 
set RegQry=HKLM\Hardware\Description\System\CentralProcessor\0
REG.exe Query %RegQry% > checkOS.txt
find /i "x86" < checkOS.txt > stringcheck.txt
if %ERRORLEVEL% == 0 goto 32_BIT
    set OSP_JRE_DIR=Windows_x86_64
    goto END_BIT_CHECK
:32_BIT
    set OSP_JRE_DIR=Windows_x86_32
:END_BIT_CHECK


REM Determine the build path for the junit.jar file.
REM Grab the build version from an OpenSpirit.jar. 
for /f "tokens=1 delims==" %%I in ('""%OSP_HOME%\jre\%OSP_JRE_DIR%\bin\java.exe" -jar \\osp1\pdata\testing\bin\GetManifestVersion.jar "%OSP_HOME%\lib\OpenSpirit.jar""') do set RESULT=%%I
REM Replace "." with "_"
set RESULT=%RESULT:.=_%
set OSP_BLD_DIR=\\osp1\build\v%RESULT%


REM Call the junit data query program.
set JRE=%OSP_HOME%\jre\%OSP_JRE_DIR%\bin\java.exe
set CLASSPATH="%OSP_HOME%\lib\OpenSpirit.jar";"%OSP_HOME%\lib\OpenSpirit-Ext.jar";"%OSP_HOME%\lib\3rdparty\orb.jar";"%OSP_HOME%\plugins\corba\OspCorba-2.jar";"%OSP_HOME%\plugins\corba\RemoteDataProvider-2.jar";"%OSP_BLD_DIR%\lib\tests.jar";"%OSP_BLD_DIR%\dev\3rdparty\junit\junit.jar"
echo.
echo "Command executed:" "%JRE%"  -Xmx1200m -Dopenspirit.relativeTestScopePath=%OSP_TESTSCOPE_DIR% -classpath %CLASSPATH% tests.impl.data.query.QueryTestSuite
echo.
"%JRE%"  -Xmx1200m -Dopenspirit.relativeTestScopePath=%OSP_TESTSCOPE_DIR% -classpath %CLASSPATH% tests.impl.data.query.QueryTestSuite
goto END_PROGRAM


:USAGE
  echo Command executed: %0 %1 %2 %3 %4
  echo Program accepts the following parameters:
  echo Usage: \\osp1\pdata\testing\bin\junit.bat 'osp_test_dir' 'osp_testscope_dir' 'osp_vers'
  echo.
  echo osp_test_dir - Root directory where the junit data query program expects all xml files to reside.
  echo osp_testscope_dir - Relative directory to osp_test_dir where the TestScope.xml file resides for that test case.
  echo osp_vers - Version of OpenSpirit software (4.0, 4.1, etc...). The parameter is optional and the default value is 4.1. 
  set EXIT_CODE=1

  
:END_PROGRAM