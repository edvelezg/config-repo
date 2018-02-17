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

;FileAppend,%w% %h% %A%, %A_ScriptDir%\LogFile.txt
;~F::
;if (A_PriorHotkey <> "~F" or A_TimeSincePriorHotkey > 400)
;{
;    ; Too much time between presses, so this isn't a double-press.
;    KeyWait, RControl
;    return
;}
;;this might help with the problem you're having, but I'm not entirely sure
;WinGetPos,,, w, h, A
;MouseGetPos, mousex, mousey, activewindow
;Msgbox, The cursor is at X%mousex% Y%mousey%. 
;return 

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


; Movement Up is E 
; Movement Down is D 
; Movement Left is S 
; Movement Right Is F 
; 
; Guardian is A 
; Teleport is G 
; Drop Soul is B 
; Manahoar is Q 
; 
; Level 1 Melee is F3 
; Level 1 Ranged is F4 
; Level 1 Flyer is F5 
; 
; Speed Up is X 
; Level 1 Nuke is R (Wrath, Rock, Lightning, Swarm, Fireball) 
; Heal is C 
; Level 2 Spell Shield is ALT (use thumb) 
; Level 3 Spell is W (Soul Mole, Slime, Grasping Vines, Rings of Fire, Freeze) 
; Level 4 Spell is T (Rainbow, Dragon Fire, Chain Lightning, Animate Dead, Erupt) 
; Level 5 Spell is Space Bar (use thumb) (Soul Wind, Explosion, Halo of Earth, Rift, Rain of Frogs) 
; Level 6 Spell is V (Wall of Spikes, Firewall, Healing Aura, Frozen Ground, Wailing Wall) 
; Level 7 Spell is Z (Fence, Rain of Fire, Wall of Vines, Bombardment, Plague) 
; Level 8 Spell #1 is Y (Bovine Intervention, Charm, Cloudkill, Blind Rage, Intestinal Vaporization) 
; Level 8 Spell #2 is H (Tornado, Mean Stalks, Bore, Volcano, Death) 
; 
; 
; NEW ADDED KEYS: 
; 
; Level 1 Melee Creature = Shift + Q 
; Level 1 Ranged Creature = Shift + W 
; Level 1 Flyer Creature = Shift + R 
; Level 2 Creature = Shift + T 
; Level 3 Creature = Shift + A 
; Level 4 Creature = Shift + Z 
; Level 5 Creature = Shift + X 
; Level 6 Creature = Shift + C 
; Level 7 Creature = Shift + V 
; Level 9 Titan Creature = Shift + Space Bar 
; Cast Desecrate = Shift + G 
; Cast Shrine = Shift + Alt 
; Flank Left Formation = Shift + H (For Titan Manalith Melee Attacking) 
; Flank Right Formation = Shift + Y (For Titan Manalith Melee Attacking) 
