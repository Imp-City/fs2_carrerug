;#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force

#Include exitspawn.ahk
#Include detections.ahk
#Include controls.ahk
#Include movesets.ahk
#Include ugcarrermovesets.ahk
; ==================================
perkX := 587
perkY := 145
DifY := 59
DifX := 53
slotX := 76 + 37
slotY := 541 + 37
slotSpace := 75

searchX := 938
searchY := 660

width := A_ScreenWidth
height := A_ScreenHeight

listfile := A_ScriptDir "\PrestigeQueueList.txt"
setupfile := A_ScriptDir "\PerkSetup.txt"
snowballfile := A_ScriptDir "\snowball.txt"
fileread, snowball, %snowballfile%
viewerFile := ""
viewerMode := ""
viewerTitle := ""
perkName = ""
Column := 1
color := 0

Gui, Color, 0x52fadb,  0x20a0e6
Gui, Add, Text, x5 y0 w290 h14 vheadline, Made by Fervent. Close this window to end macro (or f11)
Gui, Show, x1030 y0 w300 h60, Career Macro
Gui, Add, Button, x10 y15 w72 h22 gstartmacro vstartmacro, Start Macro
Gui, Add, Button, x82 y15 w72 h22 gperksetup vperksetup, Perk setup
Gui, Add, Text, x156 y20 w100 h22 vsnowtext, Snowball(0/1)
Gui, Add, Edit, x225 y15 w20 h22 vsnowball, % snowball
Gui, Add, Text, x246 y20 w25 h22 vtimetext center, Time
Gui, Add, Edit, x270 y15 w20 h22 vsearchtimer, 1

Gui, Add, Text, x5 y14 w290 h14 vWaiting,
Gui, Add, Button, x10 y37 w120 h22 gsettingadjust vsettingadjust, Set To Macro Settings
Gui, Add, Button, x130 y37 w100 h22 gQueue vQueue, Queue Lv4 Perks
Gui, Add, Button, x230 y37 w60 h22 gMode vMode, --WIP--
Gui, Add, Text, x5 y28 w290 h13 vDebug1,
Gui, Add, Text, x41 y41 w290 h13 vDebug2,

if WinExist("Career Macro") {
    WinActivate
    WinSet, AlwaysOnTop, On, Career Macro
	CoordMode, Mouse, Screen
	CoordMode, Pixel, Screen
}


t:=1.33
return

#Include perkviewer.ahk
#Include perkgui.ahk

Mode:
return

startmacro:
FileDelete, %snowballfile%
FileAppend, %snowball% , %snowballfile%
Gui, Submit, NoHide
hideeverything()
restartroblox()
chick(width/2,height/2)
if (privategame())
    goto, startmacro
chick(843, 346)
chick(329, 523) ;ug (to enable scrolling)
wheeldowns(20)
chick(329, 523) ;ug
chick(457, 654) ;Create Private
closechat()
if (waitforplaybutton(1))
    goto, startmacro
prestige()
gosub, equipall
chick(686, 734) ;PLAY
if (waitforplaybutton(0))
    goto, startmacro
wave := 1
t:=1.33
if (readyup(1))
    goto, startmacro
if (exitspawn(1))
    goto, startmacro
wheeldowns(11)
doortostair()
sleep, 5000
stairtoshop()
send, f ;exit shop
place(width/2,height/2,4) ;sentry
walktoladder()
if (waitfordawn())
    goto, startmacro

wave := 2
if (readyup(1))
    goto, startmacro
sleep, 10000
if (ForcePlace(385, 147,4))
    goto, startmacro
send, f ;ladder
sleep, 500
leftsentryw1()
wheeldowns(8)
if (waitfordawn())
    goto, startmacro

wave := 3
if (readyup(1))
    goto, startmacro
centerspawn()
placespawnfl()
wheelups(8)
rightsentry()
place(width/2,height/2,4) ;sentry
sleep, 100
walkrightsentrytoshop()

wave := 4
if (readyup(1))
    goto, startmacro
shoptostair() ;realign
stairtoshop()
shoptomines()
wheelups(50)
sleep, 100
wheeldowns(6)
setupleftmines()
ns(10000) ;walk back to shoptomines()
nd(600) ;recenter
nw(50) ;adjust
shoptomines()
setuprightminesandfl()

wave := 5
if (readyup(1))
    goto, startmacro
ns(30000) 

wave := 6
if (readyup(1))
    goto, startmacro
shoptostair()
stairtoupgs()
send, f
nextsection(3)
buy()
if (waitfordawn())
    goto, startmacro
upgrade(4,1)
nextsection(-2)
upgrade(2,1)
upgrade(3,1)
upgrade(4,1)
wave := 7
while (wave<10){ ;skip to wave 10
	if (readyup(1))
        goto, startmacro
	if (waitfordawn())
        goto, startmacro
	upgrade(2,1)
	upgrade(3,1)
	upgrade(4,1)
	if (waitformorning())
        goto, startmacro
	wave++
}	


	nextsection(-1)
	upgrade(3,3)
	upgrade(4,3)
	sleep, 100
	send, f
	sleep, 100
	upgstostair()
	stairtoshop()
	a(800)
	refill(3)
	if (readyup())
        goto, startmacro
	ammotocliff()
	if (waitfordawn())
        goto, startmacro
	sleep, 2000
	if (firetillmorning(2500)<0)
        goto, startmacro
	ulist := []
    if (runWaveBlock(11, 17, 2500))
        goto, startmacro

    if (prepRefill(ulist))
        goto, startmacro
    if (runWaveBlock(18, 20, 2500))
        goto, startmacro
	if (runWaveBlock(21, 22, 1500))
        goto, startmacro

	ulist := [[0,[1,1],[3,4],[4,4]],[3,[1,4],[2,4],[3,4],[6,4],[8,1]]]
    if (prepRefill(ulist))
        goto, startmacro
    if (runWaveBlock(23, 24, 1500))
        goto, startmacro
    if (runWaveBlock(25, 25, 0))
        goto, startmacro
	ulist := []
    if (prepRefill(ulist))
        goto, startmacro
    if (runWaveBlock(26, 27, 0))
        goto, startmacro

    if (prepRefill(ulist))
        goto, startmacro
    if (runWaveBlock(28, 29, 0))
        goto, startmacro

	ulist := [[0],[0],[0],[0],[1,[1,5],[4,4]],[2],[2,[1,1],[4,1],[5,1]],[4],[4,[1,1],[2,1],[3,1],[4,4]]]
	if (premRefill(ulist))
        goto, startmacro
    if (runWaveBlock(30, 30, 0))
        goto, startmacro

return

F1::
waitforplaybutton(0)
MsgBox, ye
return
F2::
	ulist := [[0,[1,1],[3,4],[4,4]],[3,[1,4],[2,4],[3,4],[6,4],[8,1]]]
    prepRefill(ulist)
return
F3:: 
nextsection(3)

return
F11::
ExitApp
return
GuiClose: ;fafa00
ExitApp
return

settingadjust:
chick(A_ScreenWidth/2,A_ScreenHeight/2)
chick(1137, 750) ;settings
sleep, 100
chick(487, 184) ;options
chick(A_ScreenWidth/2,A_ScreenHeight/2)
wheelups(15)
sleep 300

chick(653, 533) ;fov 100
chick(716, 531) ;ADS 10%

wheeldowns(5)
sleep, 250
chick(887, 241) ;recoil recovery on
chick(467, 306) ;exit ADS off
chick(467, 379) ;toggle ADS off
chick(467, 447) ;toggle sprint off

chick(687, 183) ;keyboard
chick(644, 220) ;ads default
chick(643, 269) ;interact default
chick(641, 316) ;sprint default
chick(933, 269) ;melee default
chick(933, 319) ;menu default


sleep, 100
send, {Esc}
sleep, 500
chick(518, 107) ;settings
sleep, 200
chick(478, 407) ;allow scrolling
l:=0
while (l<20) {
	wheeldowns(3)
	sleep, 250
	PixelSearch, x,y, 1056, 124, 1056, 575, 0x333333, 0, Fast RGB
	if (x){
		chick(x,y+13)
		sleep, 50
		send 0.36 
		sleep, 50
		send {Enter}
		GuiControl, text, settingadjust, Success! Don't forget to turn off shiftlock!
		break
	}
	l++
	if (l==20)
		GuiControl, text, settingadjust, manually change sensitivity to 0.36!
}
return

maxlvperk(){
	l:=0
	PixelGetColor, c, 149, 226, Alt RGB
	while not (c = 0xD3302B or c = 0xFF302B or c = 0x122D64 or c = 0x122D78 or c = 0x337D35 or c = 0x339635 or c = 0xE1D635 or c = 0xFFF235 or c = 0x963C96 or c = 0xBE4BBE or l>100){
		if faultcheck()
			return 1
		chick(149, 488) ;upgrade/prestige
		PixelGetColor, c, 149, 226, Alt RGB
		sleep, 20
		l++
		PixelSearch, a,, 272, 489, 279, 490, 0xFFFF00,0, Fast RGB ;prestige/perks open
		if (not a)
			return 1
	} return 0
}
checkEquip(Lslot){
	global slotSpace
	global slotX
	global slotY
	l:=0
	PixelGetColor, c, slotX + slotSpace*Mod(Lslot,6), slotY + slotSpace*Floor(Lslot/6), Alt RGB
	while (l<160){ ;perk is equipped?
		PixelGetColor, c, slotX + slotSpace*Mod(Lslot,6), slotY + slotSpace*Floor(Lslot/6), Alt RGB
		chick(149, 488) ;upgrade/prestige
		if (c == 0x101010 or c == 0x100810 or c == 0x100000 or c == 0x000010 or c == 0x001000 or c == 0x101000){
			l++
			sleep, 20
		} else
			break
	}
}

prestige(){
	global listfile
	global searchX, searchY, perkX, perkY, difX, difY
send, m
l=0
waitforplaybutton(1)
sleep, 100
PixelSearch, a,, 272, 489, 279, 490, 0xFFFF00,0, Fast RGB ;prestige/perks open
if (!a)
	chick(439, 737)
chick(1115, 108) ;prestige section
sleep, 100
PixelSearch, a,, 272, 489, 279, 490, 0xFFFF00,0, Fast RGB ;prestige/perks open
if (a){
	filereadline, line, %listfile%, 1

	parts := StrSplit(line, "|")
    perkName := parts[1]
	column := parts[2]
    color := parts[3]

	chick(searchX, searchY)
	send, %perkName%
	chick(perkX + difX*column, perkY + difY*color)
	sleep, 100
	l:=0
	PixelGetColor, c, 149, 226, Alt RGB
	while not (c = 0xFF302B or c = 0x122D78 or c = 0x339635 or c = 0xFFF235 or c = 0xBE4BBE or l > 100){
		PixelGetColor, c, 149, 226, Alt RGB
		chick(149, 488) ;upgrade/prestige
		sleep, 100
		l++
	}
	PopFirstLine(listfile)
	;guicontrol,, settingadjust, % d
}chick(173, 104)
sleep, 100
return 1
}



