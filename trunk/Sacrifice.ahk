if not A_IsAdmin
{
    Run *RunAs "%A_ScriptFullPath%"
    ExitApp
}

#SingleInstance force
#HotkeyInterval 0		;disable the warning dialog if a key is held down
#InstallKeybdHook		;Forces the unconditional installation of the keyboard hook
#UseHook On			;might increase responsiveness of hotkeys
#MaxThreads 20			;use 20 (the max) instead of 10 threads
SetBatchLines, -1		;makes the script run at max speed
SetKeyDelay , -1, -1		;faster response (might be better with -1, 0)
;Thread, Interrupt , -1, -1	;not sure what this does, could be bad for timers
SetTitleMatchMode, 3 ;title Warcraft III must match exactly

!n::
MouseGetPos, xpos, ypos 
Msgbox, The cursor is at X%xpos% Y%ypos%. 
return

; This example allows you to move the mouse around to see
; the title of the window currently under the cursor:
; #Persistent
; SetTimer, WatchCursor, 100
; return
; 
; WatchCursor:
; MouseGetPos, , , id, control
; WinGetTitle, title, ahk_id %id%
; WinGetClass, class, ahk_id %id%
; ToolTip, ahk_id %id%`nahk_class %class%`n%title%`nControl: %control%
; return

#IfWinActive, Sacrifice
Lwin::
SetKeyDelay,300
Send {Blind}{- DownTemp}
Send {Blind}{- Up}
return

; #IfWinActive, Sacrifice
^Lwin::0
SetKeyDelay,300
Send {Blind}{n DownTemp}
Send {Blind}{Control DownTemp}
Send {Blind}{n Up}
Send {Blind}{Control Up}
return

;#IfWinActive, Sacrifice
~V::
if (A_PriorHotkey <> "~V" or A_TimeSincePriorHotkey > 400)
{
    ; Too much time between presses, so this isn't a double-press.
    KeyWait, RControl
    return
}
SetKeyDelay, 300 
Send {Blind}{n DownTemp}
Send {Blind}{n Up}
return

;#IfWinActive, Sacrifice
;#NoEnv
;#Persistent
;#SingleInstance, force
;#InstallKeybdHook
;#UseHook
;SetBatchLines, -1
;SendMode, Input

;a::
;WinGetPos,,, w, h, A
;FileAppend,%w% %h% %A%, %A_ScriptDir%\LogFile.txt
;MouseGetPos, Px, Py
;FileAppend, MouseGetPos %Px% %Py% `n, %A_ScriptDir%\LogFile.txt

FileAppend,%w% %h% %A%, %A_ScriptDir%\LogFile.txt
~F::
if (A_PriorHotkey <> "~F" or A_TimeSincePriorHotkey > 400)
{
    ; Too much time between presses, so this isn't a double-press.
    KeyWait, RControl
    return
}
;this might help with the problem you're having, but I'm not entirely sure
WinGetPos,,, w, h, A
MouseGetPos, mousex, mousey, activewindow
Msgbox, The cursor is at X%mousex% Y%mousey%. 
return 

;WinGetPos,,, w, h, A
;Msgbox, The winPos is at w%w% h%h% A%A%. 
;;DllCall("SetCursorPos", int, 100, int, 100)
;MouseGetPos, Px, Py
;Msgbox, The cursor is at X%Px% Y%Py%. 
;Px += 20
;Py += 25
;MouseMove, 100, 200
;return
; MouseGetPos, iMousePosX, IMousePosY
; iMouseGotoX := 382
; iMouseGotoY := 436
; Send {Click, 0, 0, 10}
; return


