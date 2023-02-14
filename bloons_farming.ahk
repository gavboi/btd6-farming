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

step := 0

xsh := 0
ysh := 0
width := 1920
height := 1080
full := false
fullState := "No"

currentGames := 0
games := 0
lvls := 0
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
Level ups: %lvls%
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
	if (step=0) {								; STEP 0: MENU
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
		Sleep TransitionDelay
		clickHere(1100, 720)					; try and click overwrite
		step := 1
	}
	if (step=1) {								; STEP 1: WAIT FOR LOAD
		color := 0
		while color != 0x00e15d and toggle {	; wait for start
			tt("Waiting for game...")
			color := colorHere(1020, 760)
			Sleep InputDelay
		}
		if toggle {
			step := 2
		}
	}
	if (step=2) {								; STEP 2: PLACING TOWERS
		clickHere(1020, 760)
		clickHere(10, 10)
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
		step := 3
	}
	if (step=3) {								; STEP 3: WAIT FOR STATE CHANGE
		color := 0
		checking := 1
		while checking and toggle {				; wait for things to happen
			if WinActive(GameTitle) {
				tt("Waiting for end...")
				color := colorHere(1030, 900)	 	; check for victory stats's next button
				if (color = 0x00e76e) {
					clickHere(1030, 900)
					Sleep TransitionDelay
					clickHere(700, 800) 			; home button
					checking := 0
					games := games + 1
					currentGames := currentGames + 1
				}
				color := colorHere(1000, 780)		; check for defeat's restart button
				if (color = 0x00ddff) {
					clickHere(700, 800) 			; home button
					checking := 0
				}
				color := colorHere(830, 540)		; check for level up
				if (color = 0x1d61f5) {
					clickHere(30, 30)	 			; out of the way for level number
					Sleep TransitionDelay
					clickHere(30, 30)	 			; out of the way for knowledge
					lvls := lvls + 1
				}
			}
			Sleep InputDelay
		}
		if toggle {
			step := 4
		}
	}
	if (step=4) {								; STEP 4: LOAD HOME SCREEN
		color := 0
		while color != 0xffffff and toggle {	; wait for home screen
			tt("Waiting for menu...")
			color := colorHere(830, 930)
			Sleep InputDelay
		}
		step := 0
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

colorHere(x, y) {
	global xsh
	global ysh
	global width
	global height
	x := (x * width // 1920) + xsh
	y := (y * height // 1080) + ysh
	PixelGetColor, color, x, y
	return color
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
