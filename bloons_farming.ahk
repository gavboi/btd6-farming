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
TransitionDelay := 1000
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
	clickHere()				; click play
	Sleep TransitionDelay
	clickHere()				; click expert maps
	Sleep TransitionDelay
	clickHere()				; click infernal
	Sleep TransitionDelay
	clickHere()				; click easy
	Sleep TransitionDelay
	clickHere()				; click deflation
	waitForThis()			; wait for start
	press("b")				; place heli
	clickHere(, 2)
	Send ,,,..
	press("b")				; place heli
	clickHere(, 2)
	Send ,,,..
	; place sniper?
	press("u")				; place hero
	press()					; place fav
	clickHere(, 2)
	Send ,./,./,./
	Send {Space 2}			; start
	; check for level, leave, finish
}
return

clickHere(x, y, n=1) {
	Click, %x% %y% %n%
	Sleep InputDelay
}
return

waitForThis(img) {
	ImageSearch, x, y, 0, 0, 1920, 1080, %img%
	while ErrorLevel > 0 {
	tt("Waiting...")
		ImageSearch, x, y, 0, 0, 1920, 1080, %img%
	}
}

clickThis(img) {
	ImageSearch, x, y, 0, 0, 1920, 1080, %img%
	if ErrorLevel == 0 {
		Click, %x% %y%
		Sleep InputDelay
	}
	return ErrorLevel
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

