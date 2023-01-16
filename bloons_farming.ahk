; /////////////////////////////////// Script for Bloons Tower Defense 6

; ============================== Setup
#NoEnv
#SingleInstance force
#MaxThreadsPerHotkey 2
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
Toggle := false
State := "off"

Fav := "dart

ThisTitle := "Bloons Tower Defense 6 Farming"
GameTitle := "BTD6" ; !!!!!!!!!!!!!!!!!!!!!!!

; ============================== Functions
MsgBox, , %ThisTitle%, %A_ScriptName% started... {i} for info, 5
SetTimer, checkActive, 1000

TurnOff:
Toggle := false
return

saveToggles() {
	global Toggle
	global sToggle
	sToggle := Toggle
}
return

loadToggles() {
	global Toggle
	global sToggle
	Toggle := sToggle
}
return

setToggleStates() {
	global Toggle
	global sToggle
	State := Toggle ? "on" : "off"
}
return

Tt(msg) {
	Tooltip, %msg%, 50, 50
	SetTimer, RemoveTooltip, -1000
}
return
RemoveTooltip:
Tooltip
return

; ------------------------- Info Box
info:
setToggleStates()
saveToggles()
MsgBox, 64, %ThisTitle%,
(
// While BTD6 is Active //
{Ctrl+i} -> Information (this)
{Ctrl+m} -> Set favourite monkey (current: %Fav%)
{Ctrl+s} -> Start farming (current: %State%)

// Anytime //
{Ctrl+x} -> Close program/turn all toggles off
)
loadToggles()
Tt("Functions resumed.")
return

; ------------------------- Exit
^x::Gosub close
close:
Gosub TurnOff
Tt("Functions stopped.")
MsgBox, 17, %ThisTitle%, Exit %A_ScriptName%?,
IfMsgBox, OK
	ExitApp
MsgBox, , %ThisTitle%, Script continuing..., 1
return

; ------------------------- Disable on unactive
checkActive:
if WinActive(GameTitle) {
	WinWaitNotActive, Cookie Clicker
	Gosub TurnOff
	Tt("Functions stopped.")
}
return

; ------------------------- Home
setHome:
MouseGetPos, hx, hy
Tt("Home set.")
return

; ------------------------- Autobuy Buildings
buy:
BToggle := !BToggle
if BToggle {
	SetTimer, bLoop, 100
	Tt("Building clicker on.")
} else {
	SetTimer, bLoop, Off
	Tt("Building clicker off.")
}
return
bLoop:
PixelSearch, px, py, Max(x1,x2), Max(y1,y2), Min(x1,x2), Min(y1,y2), 0xFFFFFF, , Fast
if !ErrorLevel and BToggle {
	Click, %px% %py%
	Tt("Bought building.")
	Gosub GoHome
}
Sleep BDelay
return

coord1:
MouseGetPos, x1, y1
Tt("Coord 1 set.")
ShowBox()
return

coord2:
MouseGetPos, x2, y2
Tt("Coord 2 set.")
ShowBox()
return

; ------------------------- Autoclick
click:
AToggle := !AToggle
if AToggle {
	SetTimer, aLoop, %ADelay%
	Tt("Autoclicker on.")
} else {
	SetTimer, aLoop, Off
	Tt("Autoclicker off.")
}
return
aLoop:
Send {LButton}
Sleep ADelay
return 

delay:
InputBox, ADelay, %ThisTitle%, New autoclick delay (ms), , , , , , , , %ADelay%
if ADelay is not number
	delay := 50
return

; ------------------------- Golden
checkGolden:
GToggle := !GToggle
if GToggle {
	SetTimer, gLoop, 1500
	Tt("Golden clicker on.")
} else {
	SetTimer, gLoop, Off
	Tt("Golden clicker off.")
}
return
gLoop:
Tt("Looking for golden cookies...")
Loop 5 {
	PixelSearch, gx, gy, 0, 0, A_ScreenWidth, A_ScreenHeight, 0x66C2DC, 1, Fast
	if !ErrorLevel and GToggle {
		Click, %gx% %gy%
		Tt("Found golden cookie!")
		Gosub GoHome
		Sleep 100
	}
}
return