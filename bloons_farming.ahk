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

TargetMonkey := "dart"

hotkey_dict := {"dart": "q"
	, "boomerang": "w"
	, "bomb": "e"
	, "tack": "r"
	, "ice": "t"
	, "glue": "y"
	, "sniper": "z"
	, "sub": "x"
	, "buccaneer": "c"
	, "ace": "v"
	, "heli": "b"
	, "mortar": "n"
	, "dartling": "m"
	, "wizard": "a"
	, "super": "s"
	, "ninja": "d"
	, "alchemist": "f"
	, "druid": "g"
	, "farm": "h"
	, "engineer": "l"
	, "spike": "j"
	, "village": "k"
    , "handler": "i"
	, "hero": "u"}

InputDelay := 150
TransitionDelay := 500
ThisTitle := "Bloons Tower Defense 6 Farming"
GameTitle := "BloonsTD6" 

; ------------------------- Hotkeys
Hotkey, IfWinActive, %GameTitle%
Hotkey, ^m, menu
Hotkey, ^s, start

; ============================== Functions
MsgBox, , %ThisTitle%, %A_ScriptName% started... Ctrl+m for menu, 5
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

; ------------------------- Menu
menu:
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

Gui, BTDF:New,, %ThisTitle%
Gui, Font, s10, Courier
Gui, Add, Tab3,, Control|Tracking|Help|
Gui, Tab, 1 ; Control
Gui, Add, GroupBox, Section w200 h170, Options
Gui, Add, Text, xp+10 yp+18, Target Monkey:
Gui, Add, DropDownList, vTargetMonkey, Dart||Boomerang|Bomb|Tack|Ice|Glue|Sniper|Sub|Buccaneer|Ace|Heli|Mortar|Dartling|Wizard|Super|Ninja|Alchemist|Druid|Farm|Spike|Village|Engineer|Handler
Gui, Add, Text,, Strategy:
Gui, Add, DropDownList, vStrategy, Legacy||
Gui, Add, CheckBox, cdddddd vSimple, Simple Mode
Gui, Add, CheckBox, cdddddd vExtraDelay, Extra Delay
Gui, Add, Button, gSaveButton xp ym+220 Default w80, &Save
Gui, Add, Button, gExitButton x+m yp w80, E&xit
Gui, Tab, 2 ; Tracking
Gui, Add, Text,, Window Size : %width%x%height%
Gui, Add, Text, y+m, Fullscreen : %fullState%
Gui, Add, Text,, Games Played : %games%
Gui, Add, Text, y+m, Runtime : %totalTimeDisp%
Gui, Add, Text, y+m, XP Estimate : %bestXP%
Gui, Add, Text, y+m, Money Estimate : %bestMoney%
Gui, Tab, 3 ; Help
Gui, Add, Text,, Alt+Z : This menu
Gui, Add, Text, y+m, Ctrl+S : Start (when menu closed)
Gui, Add, Text, y+m, Ctrl+X : Stop (when running) or `n`texit script
Gui, Add, Text,, Simple Mode : Slower and more `nprone to misclicks, but less `nprone to getting stuck
Gui, Add, Text,, 'Save' closes GUI and keeps `nchanges, 'X' closes without `nchanges, and 'Exit' ends script
Gui, Add, Text,, All Strategies require Infernal `nDeflation unlocked
Gui, Add, Link, cgray, Detailed instructions on <a href="https://github.com/gavboi/btd6-farming">github</a>
Gui, Show
return

SaveButton:
Gui, Submit
GuiClose:
Gosub loadToggles
tt("Functions resumed.")
return

; ------------------------- Exit
^x::
ExitButton:
close:
if toggle {
	step := 0
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
if !WinActive(GameTitle) {
    WinWaitNotActive, %GameTitle% 
	Gosub turnOff
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
		clickHere(960, 580)						; click infernal
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
		press()									; place target monkey
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
				if (nearColor(color, 0x00e76e)) {
                    tt("victory!")
					clickHere(1030, 900)
					Sleep TransitionDelay
					clickHere(700, 800) 			; home button
					checking := 0
					games := games + 1
					currentGames := currentGames + 1
				}
				color := colorHere(925, 770)		; check for defeat's restart button
				if (nearColor(color, 0x00ddff)) {
                    tt("defeat")
					clickHere(700, 800) 			; home button
					checking := 0
				}
				color := colorHere(830, 540)		; check for level up
				if (nearColor(color, 0x1d61f5)) {
                    tt("lvl up!")
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
	if (step=4) {								        ; STEP 4: LOAD HOME SCREEN
		color := 0
		while !nearColor(color, 0xffffff) and toggle {	; wait for home screen
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

nearColor(test, target) { ; by user "colt" on ahk wiki
    tolerance := 5
    tb := format("{:d}", "0x" . substr(test,3,2))
    tg := format("{:d}", "0x" . substr(test,5,2))
    tr := format("{:d}", "0x" . substr(test,7,2))
    b := format("{:d}", "0x" . substr(target,3,2))
    g := format("{:d}", "0x" . substr(target,5,2))
    r := format("{:d}", "0x" . substr(target,7,2))
    distance := sqrt((b-tb)**2+(g-tg)**2+(r-tr)**2)
    if(distance<tolerance)
        return true
    return false
}

press(key:=false) {
	global hotkey_dict
	global TargetMonkey
	global InputDelay
	if !key
		key := hotkey_dict[TargetMonkey]
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
