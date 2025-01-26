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
menuOpen := false
step := 1

xsh := 0
ysh := 0
width := 1920
height := 1080
full := false

games := 0
lvls := 0
totalTime := 0
timeStart := 0
timeEnd := 0

TargetMonkey := "dart"
Strategy := "heli"

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
    , "mermonkey": "o"
    , "farm": "h"
    , "engineer": "l"
    , "spike": "j"
    , "village": "k"
    , "handler": "i"
    , "hero": "u"}

InputDelay := 150
BaseInputDelay := 150
TransitionDelay := 500
BaseTransitionDelay := 500
ExtraDelay := 0
ThisTitle := "Bloons Tower Defense 6 Farming"
GameTitle := "BloonsTD6" 

; ------------------------- Hotkeys
Hotkey, IfWinActive, %GameTitle%
Hotkey, ^m, menu
Hotkey, ^s, start
Hotkey, ^d, debug, Off

; ============================== Functions
; Startup message
MsgBox, , %ThisTitle%, %A_ScriptName% started... Ctrl+M for menu, 5
SetTimer, checkActive, 500
return

; Pause main loop
turnOff:
if (toggle) {
    timeEnd := A_TickCount
    totalTime := totalTime + (timeEnd - timeStart) / 1000
    tt("Functions stopped.")
    tt(totalTime)
}
toggle := false
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

; Show status message in top corner
tt(msg) {
    Tooltip, %msg%, 50, 50
    SetTimer, removeTooltip, -2000
}
return

removeTooltip:
Tooltip
return

; Click at location, normalised with delay added
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

; Get colour at location, normalised
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

; Check for colour equivalence under threshold - by user "colt" on ahk wiki
nearColor(test, target) { 
    tolerance := 10
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

; Press key, with delay added
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

; Press keys in sequence, with delay added
pressStream(keys) {
    k := StrSplit(keys)
    for c in StrSplit(keys)
        press(k[c])
    return
}

debug:
Gui, Debug:New,, Variables snapshot
Gui, Font, s10, Courier
Gui, Add, Text,, toggle:%toggle%
Gui, Add, Text,, step:%step%
Gui, Add, Text,, color:%color%
Gui, Add, Text,, InputDelay:%InputDelay%
Gui, Add, Text,, TransitionDelay:%TransitionDelay%
Gui, Add, Text,, menuOpen:%menuOpen%
Gui, Debug:Show
return


; ------------------------- Menu
; Options and information window
menu:
menuOpen := true
; calculate needed information
Gosub scaling
toggleText := toggle ? "On" : "Off"
fullText := full ? "Yes" : "No"
XPCount := 57000*games
moneyCount := 66*games
if (toggle) {
    t := totalTime + (A_TickCount - timeStart) / 1000
} else {
    t := totalTime
}
tm := Floor(t / 60)
ts := Mod(t, 60)
timeText := tm . "min " . Round(ts, 1) . "s"
; create menu
Gui, BTDF:New,, %ThisTitle%
Gui, Font, s10, Courier
Gui, Add, Tab3,, Control|Tracking|Help|
Gui, Tab, 1 ; Control
Gui, Add, GroupBox, Section w200 h170, Options
Gui, Add, Text, xp+10 yp+18, Target Monkey:
Gui, Add, DropDownList, vTargetMonkey, Dart|Boomerang|Bomb|Tack|Ice|Glue|Sniper|Mortar|Dartling|Wizard|Super|Ninja|Alchemist|Druid|Mermonkey|Spike|Village|Engineer|Handler
GuiControl, ChooseString, TargetMonkey, %TargetMonkey%
Gui, Add, Text,, Strategy:
Gui, Add, DropDownList, vStrategy, Heli|Sniper|Monkey Sub + Wizard
GuiControl, ChooseString, Strategy, %Strategy%
Gui, Add, CheckBox, Checked%ExtraDelay% vExtraDelay, Extra Delay
Gui, Add, Button, gSaveButton xp ym+220 Default w80, &Save
Gui, Add, Button, gExitButton x+m yp w80, E&xit
Gui, Tab, 2 ; Tracking
Gui, Add, Text,, Window Size : %width%x%height%
Gui, Add, Text, y+m, Fullscreen : %fullText%
Gui, Add, Text,, Games Played : %games%
Gui, Add, Text, y+m, Runtime : %timeText%
Gui, Add, Text, y+m, XP Estimate : %XPCount%
Gui, Add, Text, y+m, Level Ups : %lvls%
Gui, Add, Text, y+m, Money Estimate : %moneyCount%
Gui, Tab, 3 ; Help
Gui, Add, Text,, Ctrl+M : This menu
Gui, Add, Text, y+m, Ctrl+S : Start (when menu closed)
Gui, Add, Text, y+m, Ctrl+X : Stop (when running) or `n`texit script
Gui, Add, Text,, 'Save' closes GUI and keeps `nchanges, 'X' closes without `nchanges, and 'Exit' ends script
Gui, Add, Text,, All Strategies require Infernal `nDeflation unlocked
Gui, Add, Link, cgray, Detailed instructions on <a href="https://github.com/gavboi/btd6-farming">github</a>
Gui, Show
return

; Update variables based on menu settings
SaveButton:
Gui, Submit
InputDelay := BaseInputDelay * (1+ExtraDelay)
TransitionDelay := BaseTransitionDelay * (1+ExtraDelay)
BTDFGuiClose:
Gui, BTDF:Destroy
menuOpen := false
Sleep 250
if (toggleText="On") {
    tt("Functions resumed.")
    Gosub start
}
return

; ------------------------- Exit
; Stop script, or close script if already stopped
^x::
ExitButton:
if toggle {
    Hotkey, ^m, On
    step := 1
    Gosub turnOff
} else {
    MsgBox, 17, %ThisTitle%, Exit %A_ScriptName%?,
    IfMsgBox, OK
        ExitApp
    MsgBox, , %ThisTitle%, Script continuing..., 1
}
return

; ------------------------- Disable on unactive
; Stop script to avoid click checks if game/menu isn't active
checkActive:
if (!WinActive(GameTitle)) { 
    Gosub turnOff
}
return

; ------------------------- Start farming
; Main loop
start:
Gosub scaling
toggle := true
timeStart := A_TickCount
while (toggle) {
    if (step=1) {                                ; STEP 1.1: MENU
        Hotkey, ^m, Off
        tt("Starting round...")
        clickHere(835, 935)                        ; click play
        Sleep TransitionDelay
        clickHere(1340, 975)                    ; click expert maps
        Sleep TransitionDelay
        clickHere(1460, 580)                    ; click infernal
        Sleep TransitionDelay
        clickHere(625, 400)                        ; click easy
        Sleep TransitionDelay
        clickHere(1290, 445)                    ; click deflation
        Sleep TransitionDelay
        clickHere(1100, 720)                    ; try and click overwrite
                                                ; STEP 1.2: WAIT FOR LOAD
        color := 0
        while (!nearColor(color, 0x00e15d) and toggle) { ; wait for start
            tt("Waiting for game...")
            color := colorHere(1020, 760)
            Sleep InputDelay
        }
                                                ; STEP 1.3: PLACING TOWERS
        clickHere(1020, 760)                    ; click start
        clickHere(10, 10)
        Sleep 2*TransitionDelay
        tt("Placing towers...")
        if (Strategy="Heli") {
            press("b")                            ; place heli
            clickHere(1560, 575)
            clickHere(1560, 575)
            pressStream(",,,..")
            clickHere(0, 0)
            press("z")                             ; place sniper
            clickHere(835, 330)
            clickHere(835, 330)
            pressStream(",,////")
            press("{Tab}")
            press("{Tab}")
            press("{Tab}")
            clickHere(0, 0)
            press("b")                            ; place heli
            clickHere(110, 575)
            clickHere(110, 575)
            pressStream(",,,..")
            clickHere(0, 0)
            press()                                ; place target monkey
            clickHere(835, 745)
            clickHere(835, 745)
        }
        if (Strategy="Sniper") {
            press("k")                          ; place village
            clickHere(1575, 500)
            clickHere(1575, 500)
            pressStream(",,//")
            clickHere(0, 0)
            press("z")                          ; place sniper
            clickHere(1550, 585)
            clickHere(1550, 585)
            pressStream("..////")
            clickHere(0, 0)
            press("f")                          ; place alchemist
            clickHere(1575, 650)
            clickHere(1575, 650)
            pressStream(",,,/")
            clickHere(0, 0)
            press()                                ; place target monkey
            clickHere(110, 560)
            clickHere(110, 560)
        }
        if (Strategy="Monkey Sub + Wizard") {
            press("a")                          ; place Wizard
            clickHere(833, 789)
            clickHere(833, 789)
            pressStream("...//")
            clickHere(0, 0)
            press("a")                          ; place Wizard
            clickHere(833, 292)
            clickHere(833, 292)
            pressStream("...//")
            clickHere(0, 0)
            press("x")                          ; place Sub
            clickHere(473, 830)
            clickHere(473, 830)
            pressStream(",,////")
            clickHere(0, 0)
            press("x")
            clickHere(1180,236)
            clickHere(1180,236)
            pressStream(",,///")
            clickHere(0,0)
            press()                                ; place target monkey
            clickHere(506, 236)
            clickHere(506, 236)
        }
        pressStream(",,,,,/////.....")
        clickHere(30, 0)
        press("{Space}")                        ; start
        press("{Space}")                        ; speed up
        if (toggle) {
            step := 2
        }
        Hotkey, ^m, On
    }
    if (step=2) {                                ; STEP 2: WAIT FOR STATE CHANGE
        color := 0
        checking := 1
        while (checking and toggle and !menuOpen) {    ; wait for things to happen
            tt("Waiting for end...")
            color := colorHere(1030, 900)         ; check for victory stats's next button
            if (nearColor(color, 0x00e76e)) {
                Hotkey, ^m, Off
                tt("victory!")
                clickHere(1030, 900)
                Sleep TransitionDelay
                clickHere(700, 800)             ; home button
                checking := 0
                games := games + 1
                step := 3
            }
            color := colorHere(925, 770)        ; check for defeat's restart button
            if (nearColor(color, 0x00ddff)) {
                tt("defeat")
                clickHere(700, 800)             ; home button
                checking := 0
                step := 3
            }
            color := colorHere(274, 987)        ; check for level up
            if (nearColor(color, 0x194e9e)) {
                Hotkey, ^m, Off
                tt("lvl up!")
                clickHere(30, 30)                 ; out of the way for level number
                Sleep TransitionDelay
                clickHere(30, 30)                 ; out of the way for knowledge
                lvls := lvls + 1
                Hotkey, ^m, On
            }
            Sleep InputDelay
        }
        if (step=3) {                           ; STEP 3: LOAD HOME SCREEN
            color := 0
            while (!nearColor(color, 0xffffff) and toggle and !menuOpen) {    ; wait for home screen
                tt("Waiting for menu...")
                color := colorHere(830, 930)
                Sleep InputDelay
            }
            step := 1
        }
    }
}
return
