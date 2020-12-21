; IMPORTANT INFO ABOUT GETTING STARTED: Lines that start with a
; semicolon, such as this one, are comments.  They are not executed.

; This script has a special filename and path because it is automatically
; launched when you run the program directly.  Also, any text file whose
; name ends in .ahk is associated with the program, which means that it
; can be launched simply by double-clicking it.  You can have as many .ahk
; files as you want, located in any folder.  You can also run more than
; one .ahk file simultaneously and each will get its own tray icon.

; SAMPLE HOTKEYS: Below are two sample hotkeys.  The first is Win+Z and it
; launches a web site in the default browser.  The second is Control+Alt+N
; and it launches a new Notepad window (or activates an existing one).  To
; try out these hotkeys, run AutoHotkey again, which will load this file.

; #InstallKeybdHook		;Forces the unconditional installation of the keyboard hook
; #UseHook On			;might increase responsiveness of hotkeys
; #MaxThreads 20			;use 20 (the max) instead of 10 threads
; SetBatchLines, -1		;makes the script run at max speed
; SetKeyDelay , -1, -1		;faster response (might be better with -1, 0)
; ;Thread, Interrupt , -1, -1	;not sure what this does, could be bad for timers
; SetTitleMatchMode, 3 ;title Warcraft III must match exactly

::f/e::for each
::ea/::each
::pls::please
::tbl::table
::ure::you're
::ur::your
::svc::service
::th::the
::creds::credentials
::msg::message
::u::you
::/s f::search for
;:*:rat::[n,d] = rat(ans)
::w/::with
::w/o::without
::w/in::within
::]b::\\netapp01c\Build
::]bmp::BuildMirrorProject.rb
::b/f::before
::chgd::changed
::chgs::changes
::btw::by the way
::mthd::method
::chg::change
::jam::just a minute
::jas::Just a second
::ctor::constructor
::btwn::between
::b/c::because
::chged::changed
::]anx::Analysis.docx
::]seea::(See Analysis.docx)
::]seed::(See Development.docx)
::]seev::(See Verification.docx)
::]vex::Verification.docx
::]anx::Analysis.docx
::]elo::Development.docx
:*:]t88::\\TKS88-SQL-DEV
:*:]t14::\\TKS2014-SQL-DEV
:*:]t160::\\TKS2016-SQL-DEV
:*:]t161::\\TKS2016-1-DEV

:*:]d::  ; This hotstring replaces "]d" with the current date and time via the commands below.
FormatTime, CurrentDateTime,, M/d/yyyy h:mm tt  ; It will look like 9/1/2005 3:53 PM
SendInput %CurrentDateTime%
return

!n::
MouseGetPos, xpos, ypos 
Msgbox, The cursor is at X%xpos% Y%ypos%. 
::EGV::
FormatTime, CurrentDateTime,, M/d/yyyy
SendInput, EGV %CurrentDateTime%:
return

:*:..l::
SendInput v751448{tab}
SendRaw Gray@Rabbit!
SendInput {tab}123456
return 

:*:..p::
SendRaw Gray@Rabbit!
return

;^!i::
;Input key, I L1
;IfEqual key,p
;   Run, "E:\Petra\Issues"
;IfEqual key,k
;   Run, "E:\Kingdom\Issues"
;IfEqual key,u
;   Run, "C:\Users\egutarra\Desktop\Current Issue"
;IfEqual key,l
;   Run, "E:\Journal\KingdomIssues.txt"
;   Run, "C:\dev\Prod.DC.Petra.Dev\3\docs\Petra3Issues.txt"
;Return

;Creating a time-sensitive Keyboard Shortcut Chord with Autohotkey
;http://stackoverflow.com/questions/34801868/creating-a-time-sensitive-keyboard-shortcut-chord-with-autohotkey
$^!i::
    Input key1, I L1 T0.8 ;wait 0.8 seconds for a keypress
    If (key1 = "p" || key1 = "k" || key1 = "m" || key1 = "l") { ;if p, k m, or l were pressed
        If (key1 = "p") { ;if the first key we waited for was p:
            Run, "E:\Petra\Issues"
        } Else If (key1 = "k") { ;if the first key we waited for was k:
            Run, "E:\Kingdom\Issues"
        } Else If (key1 = "m") { ;if the first key we waited for was m:
            Run, "http://rofa-nyc.na.tibco.com/request/resources"
            Run, "http://confluence.tibco.com/display/grid/GridServer+Releases"
            Run, "http://confluence.tibco.com/pages/viewpage.action?spaceKey=grid&title=Initial+Information+for+New+Developers"
            Run, "http://confluence.tibco.com/display/grid/GridServer+Home"
            Run, "https://www.bloomberg.com/quote/USDCOP:CUR"
            Run, "https://jira.tibco.com/issues/?filter=79186"
        } Else If (key1 = "l") {
            Run, "E:\Journal\Issues"
            Run, "E:\Journal\BlockChain.txt"
            Run, "E:\Journal\Issues.txt"
            Run, "https://jira.tibco.com/issues/?filter=79186"
        } 
     }
     Else {
        Send, ^!i
     }
Return


;Creating a time-sensitive Keyboard Shortcut Chord with Autohotkey
;http://stackoverflow.com/questions/34801868/creating-a-time-sensitive-keyboard-shortcut-chord-with-autohotkey
$^!p::
    Input key1, I L1 T0.8 ;wait 0.8 seconds for a keypress
    If (key1 = "p" || key1 = "k" || key1 = "u" || key1 = "l") { ;if p, k or u were pressed
        If (key1 = "p") { ;if the first key we waited for was p:
            Run, "\\netapp01c\pdata\petradata\v38"
        } Else If (key1 = "k") { ;if the first key we waited for was k:
            Run, "\\netapp01c\pdata\kingdom\TKS20161_Test_Data"
        } Else If (key1 = "u") { ;if the first key we waited for was u:
            Run, "\\netapp01c\Users"
        } Else If (key1 = "l") {
            Run, "\\netapp01c\downloads"
        }
     }
     Else {
        Send, ^!p
     }
Return


;Creating a time-sensitive Keyboard Shortcut Chord with Autohotkey
;http://stackoverflow.com/questions/34801868/creating-a-time-sensitive-keyboard-shortcut-chord-with-autohotkey
$^!d::
    Input key1, I L1 T0.8 ;wait 0.8 seconds for a keypress
    If (key1 = "p" || key1 = "k" || key1 = "u" || key1 = "l") { ;if p, k or u were pressed
        If (key1 = "p") { ;if the first key we waited for was p:
            Run, "C:\dev\DC-Petra\trunk\tools\scripts\clean\ClearDb.bat"
        } Else If (key1 = "k") { ;if the first key we waited for was k:
            Run, "C:\dev\DC-Kingdom\trunk\tools\scripts\clean\CleanTKS_CUDOnly.bat"
        } Else If (key1 = "u") { ;if the first key we waited for was u:
            Run, "C:\Users\egutarra\Desktop\Current Issue"
        } Else If (key1 = "l") {
            Run, "E:\Journal\KingdomIssues.txt"
            Run, "C:\dev\Prod.DC.Petra.Dev\3\docs\Petra3Issues.txt"
        } 
     }
     Else {
        Send, ^!d
     }
Return

^Numpad1::
   Run, "C:\dev\scripts\getLastBuild.rb"
return

^!m::
    Run, "C:\Users\edvel\Documents\config-repo\trunk"
return

;#IfWinActive ahk_class SunAwtFrame
;^u::
;	Send, %OutputVar%

^+!a::
	MouseGetPos, xPos, yPos
	Click Left, 380, 65
	; Click Left, 242, 158
   MouseMove %xPos%, %yPos%
   return

;+!f::
;	 MouseGetPos, xPos, yPos
;	 Click Left, 140, 82
;   MouseMove %xPos%, %yPos%
;   return


#IfWinActive ahk_class SunAwtFrame
!d::
	Send, {Control Down}{Down}
	Send, {Control Up}
        return 
#IfWinActive ahk_class SunAwtFrame
!e::
	Send, {Control Down}{Up}
	Send, {Control Up}
        return 

#IfWinActive ahk_class SunAwtFrame
!s::
	Send, {Control Down}{F4}
	Send, {Control Up}
        return 

#IfWinActive ahk_class TDirectoryViewerForm
x::
	MouseGetPos, xPos, yPos
        nxPos := xPos + 64
        nyPos := yPos + 255
	Click Left, %nxPos%, %nyPos%
        MouseMove %xPos%, %yPos%
        Send, {Return}
return


^!n::
IfWinExist AutoHotkey.ahk - C:\Users\egutarra\Documents\AutoHotkey.ahk - SlickEdit
	WinActivate
else
	Run Notepad
return


; Note: From now on whenever you run AutoHotkey directly, this script
; will be loaded.  So feel free to customize it to suit your needs.

; Please read the QUICK-START TUTORIAL near the top of the help file.
; It explains how to perform common automation tasks such as sending
; keystrokes and mouse clicks.  It also explains more about hotkeys.

