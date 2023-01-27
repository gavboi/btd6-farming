; /////////////////////////////////// Script for Bloons Tower Defense 6

; ============================== Setup
#NoEnv
#SingleInstance force
#MaxThreadsPerHotkey 1
SendMode Input
SetWorkingDir %A_ScriptDir%
SetTitleMatchMode 2

; ------------------------- Variables
toggle := false
sToggle := false
state := "off"

xsh := 0
ysh := 0
width := 1920
height := 1080
full := false
fullState := "No"

currentGames := 0
games := 0
totalTime := 0
time := 0
timeEnd := 0

fav := "dart"
new_fav := "dart"

hotkey_dict := {"dart": "q"
	, "boomerang": "w"
	, "bomb": "e"
	, "cannon": "e"
	, "tack": "r"
	, "ice": "t"
	, "glue": "y"
	, "sniper": "z"
	, "sub": "x"
	, "buccaneer": "c"
	, "ship": "c"
	, "ace": "v"
	, "plane": "v"
	, "heli": "b"
	, "helicopter": "b"
	, "mortar": "n"
	, "dartling": "m"
	, "gunner": "m"
	, "wizard": "a"
	, "super": "s"
	, "ninja": "d"
	, "alchemist": "f"
	, "druid": "g"
	, "farm": "h"
	, "engineer": "l"
	, "spike": "j"
	, "village": "k"
	, "hero": "u"}

InputDelay := 150
TransitionDelay := 500
ThisTitle := "Bloons Tower Defense 6 Farming"
GameTitle := "BloonsTD6" 

; ------------------------- Hotkeys
Hotkey, IfWinActive, %GameTitle%
Hotkey, ^i, info
Hotkey, ^m, favMonkey
Hotkey, ^s, start

; ============================== Functions
MsgBox, , %ThisTitle%, %A_ScriptName% started... {Ctrl+i} for info, 5
SetTimer, checkActive, 500

return

turnOff:
toggle := false
currentGames := 0
timeEnd := A_TickCount
totalTime := totalTime + (timeEnd - time) / 1000
tt("Functions stopped.")
return

saveToggles:
sToggle := toggle
return

loadToggles:
toggle := sToggle
return

setStates:
state := toggle ? "on" : "off"
fullState := full ? "Yes" : "No"
return

; When windowed, game is 18 pixels wider and 47 pixels higher (9 on all sides,
; except top which is 38). Therefore, the offset from the top and from left
; must be added to correct a non-fullscreen game's mouse coordinates. The
; correct game resolution can also be achieved by subtracting the 
; aforementioned values from GetWinPos.
scaling:
WinGetPos, , , width, height, %GameTitle%
t := Mod(height, 10)
if (t = 0 || t = 4 || t = 8) {
	xsh := 0
	ysh := 0
	full := true
} else {
	xsh := 9
	ysh := 38
	width := width - 18
	height := height - 47
	full := false
}
return

tt(msg) {
	Tooltip, %msg%, 50, 50
	SetTimer, removeTooltip, -2000
}
return
removeTooltip:
Tooltip
return

; ------------------------- Info Box
info:
Gosub scaling
Gosub setStates
Gosub saveToggles
currentBestXP := 57000*currentGames
bestXP := 57000*games
currentBestMoney := 66*currentGames
bestMoney := 66*games
if sToggle
	t := (A_TickCount - time) / 1000
else
	t := (timeEnd - time) / 1000
tm := Floor(t / 60)
ts := Mod(t, 60)
timeDisp := tm . "min " . ts . "s"
if sToggle
	t := t + totalTime
else
	t := totalTime
tm := Floor(t / 60)
ts := Mod(t, 60)
totalTimeDisp := tm . "min " . ts . "s" 
MsgBox, 64, %ThisTitle%,
(
// Window //
Detected size: %width%x%height%
Fullscreen: %fullState%

// While BTD6 is Active //
{Ctrl+i} -> Information (this)
{Ctrl+m} -> Set favourite monkey (current: %fav%)
{Ctrl+s} -> Start farming (current: %state%)

// Anytime //
{Ctrl+x} -> Close program/turn all toggles off

// Stats //
Games: %currentGames% (total: %games%)
Best XP: %currentBestXP% (total: %bestXP%)
Best Money: %currentBestMoney% (total: %bestMoney%)
Time: %timeDisp% (total active: %totalTimeDisp%) 
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
Gosub scaling
toggle := true
time := A_TickCount
while toggle {
	tt("Starting round...")
	clickHere(835, 935)						; click play
	Sleep TransitionDelay
	clickHere(1340, 975)					; click expert maps
	Sleep TransitionDelay
	clickHere(535, 580)						; click infernal
	Sleep TransitionDelay
	clickHere(625, 400)						; click easy
	Sleep TransitionDelay
	clickHere(1290, 445)					; click deflation
	ErrorLevel := 1
	while ErrorLevel > 0 and toggle {		; wait for start
		tt("Waiting...")
		ImageSearch, x, y, 0, 0, A_ScreenWidth, A_ScreenHeight, ok.png
		Sleep InputDelay
	}
	if !toggle {
		break
	}
	clickHere(0, 0)
	Sleep 2*TransitionDelay
	tt("Placing towers...")
	press("b")								; place heli
	clickHere(1560, 575)
	clickHere(1560, 575)
	pressStream(",,,..")
	clickHere(0, 0)
	press("z") 								; place sniper
	clickHere(835, 330)
	clickHere(835, 330)
	pressStream(",,////")
	press("{Tab}")
	press("{Tab}")
	press("{Tab}")
	clickHere(0, 0)
	press("b")								; place heli
	clickHere(110, 575)
	clickHere(110, 575)
	pressStream(",,,..")
	clickHere(0, 0)
	press()									; place fav
	clickHere(835, 745)
	clickHere(835, 745)
	pressStream(",./,./,./,./,./,./")
	clickHere(30, 0)
	press("{Space}")						; start
	press("{Space}")	
	err := 1
	x := 0
	y := 0
	while err > 0 and toggle {				; check for level, leave, finish
		tt("Watching...")
		clickHere(30, 0)
		ImageSearch, x, y, 0, 0, 1920, 1080, home.png
		err := ErrorLevel
		if ErrorLevel = 0
			clickHere(x, y)
		ImageSearch, x, y, 0, 0, 1920, 1080, home2.png
		err := err*ErrorLevel
		if ErrorLevel = 0
			clickHere(x, y)
		ImageSearch, x, y, 0, 0, 1920, 1080, next.png
		if ErrorLevel = 0
			clickHere(x, y)
		Sleep TransitionDelay
	}
	if !toggle {
		break
	}
	games := games + 1
	currentGames := currentGames + 1
	ErrorLevel := 1
	while ErrorLevel > 0 and toggle {		; wait for home
		tt("Waiting...")
		ImageSearch, x, y, 0, 0, A_ScreenWidth, A_ScreenHeight, play.png
		Sleep InputDelay
	}
}
return

clickHere(x, y) {
	global InputDelay
	global xsh
	global ysh
	global width
	global height
	x := (x * width // 1920) + xsh
	y := (y * height // 1080) + ysh
	Click, %x% %y%
	Sleep InputDelay
	return
}

press(key:=false) {
	global hotkey_dict
	global fav
	global InputDelay
	if !key
		key := hotkey_dict[fav]
	SendInput %key%
	Sleep InputDelay
	return
}

pressStream(keys) {
	k := StrSplit(keys)
	for c in StrSplit(keys)
		press(k[c])
	return
}
