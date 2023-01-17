; /////////////////////////////////// Script for Bloons Tower Defense 6

; ============================== Setup
#NoEnv
#SingleInstance force
#MaxThreadsPerHotkey 1
SendMode Input
SetWorkingDir %A_ScriptDir%
SetTitleMatchMode 2

Hotkey, IfWinActive, %GameTitle%
Hotkey, ^i, info
Hotkey, ^m, favMonkey
Hotkey, ^s, start

Gui, Color, 00ADEF
Gui, +Disabled +LastFound +AlwaysOnTop +Border +Owner -SysMenu
; no interact, winset target, not hidden on click, show outline, not on taskbar, no minimize etc.
WinSet, TransColor, 00ADEF

; ------------------------- Variables
toggle := false
sToggle := false
state := "off"

fav := "dart"
new_fav := "dart"

hotkey_dict := {"dart": "q"
	, "hero": "u"
	, "sniper": "z"
	, "helicopter": "b"}

InputDelay := 50
ThisTitle := "Bloons Tower Defense 6 Farming"
GameTitle := "" ; !!!!!!!!!!!!!!!!!!!!!!!

; ============================== Functions
MsgBox, , %ThisTitle%, %A_ScriptName% started... {Ctrl+i} for info, 5
SetTimer, checkActive, 1000

turnOff:
toggle := false
tt("Functions stopped.")
return

saveToggles:
sToggle := Toggle
return

loadToggles:
Toggle := sToggle
return

setToggleStates:
State := Toggle ? "on" : "off"
return

tt(msg) {
	Tooltip, %msg%, 50, 50
	SetTimer, removeTooltip, -1000
}
return
removeTooltip:
Tooltip
return

; ------------------------- Info Box
info:
Gosub setToggleStates
Gosub saveToggles
MsgBox, 64, %ThisTitle%,
(
// While BTD6 is Active //
{Ctrl+i} -> Information (this)
{Ctrl+m} -> Set favourite monkey (current: %fav%)
{Ctrl+s} -> Start farming (current: %state%)

// Anytime //
{Ctrl+x} -> Close program/turn all toggles off
)
Gosub loadToggles
tt("Functions resumed.")
return

; ------------------------- Exit
^x::Gosub close
close:
if toggle {
	Gosub turnOff
} else {
	Gosub turnOff
	MsgBox, 17, %ThisTitle%, Exit %A_ScriptName%?,
	IfMsgBox, OK
		ExitApp
	MsgBox, , %ThisTitle%, Script continuing..., 1
}
return

; ------------------------- Disable on unactive
checkActive:
if WinActive(GameTitle) {
	WinWaitNotActive, %GameTitle%
	Gosub turnOff
}
return

; ------------------------- Find mouse pos (dev)
^q::
MouseGetPos, x, y
tt(x . "," . y)
return

; ------------------------- Set favourite monkey
favMonkey:
Gosub ask
while i == 0 {
	tt(new_fav . " is not a monkey!")
	Gosub ask
}
fav := new_fav
return
ask:
InputBox, new_fav, %ThisTitle%, Set favourite monkey: , , , , , , , , %fav%
i := 0
for key, value in hotkey_dict {
	i := i + (new_fav == key)
}
return

; ------------------------- Start farming
start:
toggle := true
while toggle {
	tt("Starting round...")
	press()
	Sleep 1000
	; click play
	; click expert maps
	; click infernal
	; click easy
	; click deflation
	; wait
	; place heli
	; place heli
	; place sniper?
	; place hero?
	; place fav
	; start
	; check for level, leave, finish
}
return

clickHere(x, y, n=1) {
	Click, %x% %y% %n%
	Sleep InputDelay
}
return

clickThis(img) {
	; ImageSearch, x, y, ...
	Click, %x% %y%
	Sleep InputDelay
}

press(key=false) {
	if !key {
		global hotkey_dict
		global fav
		key := hotkey_dict[fav]
	}
	Send %key%
	Sleep InputDelay
}

