;#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force

#Include exitspawn.ahk
#Include detections.ahk
#Include controls.ahk
#Include movesets.ahk
#Include ugcarrermovesets.ahk
#Include failsafes.ahk
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

width := 1366
height := 768


listfile := A_ScriptDir "\PrestigeQueueList.txt"
setupfile := A_ScriptDir "\PerkSetup.txt"
snowballfile := A_ScriptDir "\snowball.txt"
techlvfile := A_ScriptDir "\techlv.txt"
webhookURLfile := A_ScriptDir "\webhookURL.txt"

viewerFile := ""
viewerMode := ""
viewerTitle := ""
perkName := ""
debug2faultcheck := ""
debug2deadcheck := ""
pendingFaultDebug := ""
pendingDeadDebug := ""



errortimer := 0
killtimer := 0
lastDebugUpdate := 0
recoverycycle := 0
curendwave := 0
Column := 1
color := 0

;webhooks
webhook := ""
statusClient := ""

;validity
wave := 0
runs := 0

Gui, Color, 0x52fadb,  0x20a0e6
Gui, Add, Text, x5 y0 w290 h14 vheadline, Made by Fervent. Close this window to end macro (or F9)
Gui, Show, x1030 y0 w300 h60, Career Macro
Gui, Add, Button, x10 y15 w85 h22 ginitializemacro vinitializemacro, Start Macro
Gui, Add, Button, x95 y15 w85 h22 gperksetup vperksetup, Perk setup
Gui, Add, Button, x180 y15 w110 h22 gConfigure vConfigure, Configuration
Gui, Add, Text, x5 y14 w290 h14 vWaiting,
Gui, Add, Button, x10 y37 w120 h22 gQueue vQueue, Queue Lv4 Perks
Gui, Add, Button, x130 y37 w160 h22 gsettingadjust vsettingadjust, Test adjust to Macro Settings
Gui, Add, Text, x5 y28 w140 h13 vDebug1,
Gui, Add, Text, x145 y28 w140 h13 vDebug3,
Gui, Add, Text, x41 y41 w290 h13 vDebug2,

if WinExist("Career Macro") {
    WinActivate
    WinSet, AlwaysOnTop, On, Career Macro
}
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
t:=1.33
return

#Include perkviewer.ahk
#Include perkgui.ahk
#Include webhooker.ahk
/*
F1::

fileread, webhook, %webhookURLfile%
if prestige()
	if equipallfunction()
		return

return

sendstatboardattempt("test stat board.")

SendWebhookSnip("","Test stat board", 283, 289, 1082, 479)
sleep, 1000
SendWebhookSnip("","Test msg")

SendWebhookSnip("","Prestiged - " . varname, 52, 129, 550, 230)

statusClient.Send("","Status: Running")
sleep, 500
statusClient.Send("","Status: Stopped 1", 0, 0, 1366, 768)
sleep, 500
statusClient.Send("","Status: Stopped 2", 0, 0, 1366, 768, 1)

return

F2::
setfullscreen()
return
F3::
newfs2tab()
return
*/
initializemacro:
Gui, Submit, NoHide
fileread, snowball, %snowballfile%
if ErrorLevel {
    MsgBox, 48, "Error", You haven't set configuration. Please set configuration before starting macro.
	return
}
fileread, techlv, %techlvfile%
if ErrorLevel {
    MsgBox, 48, "Error", You haven't set configuration. Please set configuration before starting macro.
	return
}
fileread, webhook, %webhookURLfile%
hideeverything()
GuiControl, Show, waiting	
GuiControl, Show, debug1
GuiControl, Show, debug2
GuiControl, Show, debug3
statusClient := new WebhookSnipClient(webhook)
statusClient.send("","Status: Started Successfully.")
goto, startmacro
return

startmacro:
runs++
statusClient.send("","Status: Restarting. Run Time: " . FormatTimeFromMs(A_TickCount - statusClient.TimeInitialized), 0, 0 , width, height)
statClient := new WebhookSnipClient(webhook)
restartroblox()
chick()
if (privategame())
    goto, startmacro
chicks(843, 346, 3) ;carrer mode
chick(329, 523) ;ug (to enable scrolling)
wheeldowns(20)
chicks(329, 523, 3) ;ug
chicks(457, 654, 3) ;Create Private
closechat()
if (waitforplaybutton(1))
    goto, startmacro
;if (wave)
	;if !findpx(671, 717, 675, 717, 0xFFFFFF, 0)
		;MsgBox, 48, Macro, GUI scale must be set to Large. Otherwise, the macro may not work properly. Pressing OK will continue the macro.
prestige()
sleep, 300
gosub, equipall
sleep, 100
if (waitforplaybutton(0))
    goto, startmacro
wave := 1
t:=1.33
if (exitspawn(1,3)){
	wheelups(1)
	gosub, settingadjust
	waitforplaybutton(0)
	if (exitspawn(1,4))
    	goto, startmacro
}
wheeldowns(11)
if (readyup(1))
    goto, startmacro
if (waitfordawn())
	goto, startmacro
doortostair()
stairtoshop()
if !atinteractable(){
	gosub, settingadjust
	goto, startmacro
}
send, f ;exit shop
togglemode(2,4) ;sentry set to weak
place(width/2,height/2,4) ;sentry
if walktoladder(){
	gosub, settingadjust
    goto, startmacro
}
if (waitfordawn())
    goto, startmacro

wave := 2
if (readyup(1))
    goto, startmacro
sleep, 10000
if (ForcePlace(385, 147, 4 , 1 , 50)){ ;sentry
	gosub, settingadjust
    goto, startmacro
}
rightsentry()
if (waitfordawn())
    goto, startmacro

wave := 3
if (readyup(1))
    goto, startmacro
sleep, 10000
if rightsentrythenladder()
	goto, startmacro
send, f
prepflw3()

wave := 4
if (readyup(1))
    goto, startmacro
centerspawn()
placespawnfl()
walkspawntoshop()
ns(100)

wave := 5
if (readyup(1))
    goto, startmacro
shoptomines()
wheelups(40)
sleep, 100
wheeldowns(6)
if (setupleftmines())
    goto, startmacro
ns(10000) ;walk back to shoptomines()
nd(600) ;recenter
nw(50) ;adjust
shoptomines()
if (setuprightminesandfl())
    goto, startmacro
ns(20000)

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
	upgstoshop()
	a(400)
	sa(300)
	a(300)
	refill(3)
	if (readyup())
        goto, startmacro
	ammotocliff()
	if (waitfordawn())
        goto, startmacro
	timer(0)
	steps := [] ;start: if start <= 0 - only prep, end, delay, prep: "" - no prep, only shoot | [] - refill only, otherwise ulist

	steps.Push([10, 17, 2400, ""])
	steps.Push([0, 0, 0, []]) ; refill only

	steps.Push([18, 19, 2400, ""])
	steps.Push([20, 22, 1500, ""])

	steps.Push([23, 24, 1500, [[0,[1,1],[3,4],[4,4]],[3,[1,4],[2,4],[3,4],[6,4],[8,1]]]])
	steps.Push([25, 25, 0, ""])

	steps.Push([26, 27, 0, []])
	steps.Push([28, 29, 0, []])

	steps.Push([30, 30, 0, [[0],[0],[0],[0],[1,[4,4]],[2],[2,[1,1],[4,1],[5,1]],[4],[4,[1,1],[2,1],[3,1],[4,4]]]])
	while !timer(1){
		sleep, 500
	} 
	if (Launchering(steps))
		goto, startmacro
	wheeldowns(1)
	readyup(1)
	respawn()
	timer(0)
	loop{
		if isDeadPOV() or timer(20)
			break
	}
	sendstatboardattempt("Run Successful.") ;stat
	goto, startmacro
return

F9::
goto, GuiClose
return
GuiClose: ;fafa00
Gui, Show,, Macro is closing...
if (statusClient != "")
	statusClient.Send("","Status: Stopped. Final Run Time: " . FormatTimeFromMs(A_TickCount - statusClient.TimeInitialized),-1,-1,-1,-1,1)
ExitApp
return

settingadjust:
WinActivate, ahk_exe RobloxPlayerBeta.exe
if !findpx(648, 719, 715, 723, 0xFFFFFF, 30){ ;play button visible
	chick(65, 698) ;menu without keybind
	waitforplaybutton(1)
}
chick(1137, 750) ;settings
sleep, 100
chick(487, 184) ;options
chick()
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

slist := [1,2,3,4,5,6,7,10,11,12]
setdefaults(slist)

send, {Esc}
sleep, 500
chick(518, 107) ;settings
sleep, 200
chick(1078,170) ;allow scrolling
wheelups(20)
sensitivitySet := 1
GraphicsSet := 1
Loop, 8 {
	
	PixelSearch, x,y, 1056, 124, 1056, 575, 0x333333, 0, Fast RGB
	if (sensitivitySet and x){
		chick(x,y+13)
		sleep, 50
		send 0.36
		sleep, 50
		send {Enter}
		sensitivitySet := 0
	} else {
		PixelSearch, x, y, 810, 260, 810, 560, 0x393B3D, 0, Fast RGB
		if (GraphicsSet and x) {
			PixelSearch, x, y, 805, y-47, 815, y-27, 0xFFFFFF, 8, Fast RGB
			if (x){
				chick(x,y)
				GraphicsSet := 0
			}
		}

		PixelSearch, x, y, 633 , 260, 634, 560, 0x9E9D9D, 6, Fast RGB
		if (x and !findpx(1056, y, 1056, y, 0x333333) and findpx(x+28, y, x+28, y, 0xD9D9D9)){
			chicks(x-10,y, 10)
		}
	}
	wheeldowns(2)
	sleep, 250
}
send, {Esc}
return

maxlvperk(){
	GuiControl,, Debug1, At: maxlvperk
	l:=0
	PixelGetColor, c, 149, 225, Alt RGB
	while not (c = 0xD3302B or c = 0xFF302B or c = 0x122D64 or c = 0x122D78 or c = 0x337D35 or c = 0x339635 or c = 0xE1D635 or c = 0xFFF235 or c = 0x963C96 or c = 0xBE4BBE or l>100){
		if faultcheck()
			return 1
		chick(149, 488) ;upgrade/prestige
		PixelGetColor, c, 149, 225, Alt RGB
		sleep, 20
		l++
		a := findpx(272, 489, 279, 490, 0xFFFF00) ;prestige/perks open
		if (!a)
			return 1
	} return 0
}
checkEquip(Lslot){
	GuiControl,, Debug1, At: checkEquip
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
	GuiControl,, Debug1, At: prestige
	global listfile
	global searchX, searchY, perkX, perkY, difX, difY, width, height
send, m
l:=0
waitforplaybutton(1)
if openunlocks()
	return 1
chick(1115, 108) ;prestige section
sleep, 200
a := findpx(272, 489, 279, 490, 0xFFFF00) ;prestige/perks open
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
	while not (c = 0xFF302B or c = 0x122D78 or c = 0x339635 or c = 0xFFF235 or c = 0xBE4BBE){
		chick(1115, 108) ;prestige section
		PixelGetColor, c, 149, 226, Alt RGB
		chick(149, 488) ;upgrade/prestige
		sleep, 200
		chick(149, 488)
		sleep, 200
		l++
		sleep, 300
		a := findpx(272, 489, 279, 490, 0xFFFF00) ;prestige/perks open
		if (!a)
			break
		if (l==10) {
			SendWebhookSnip("","Couldnt prestige " . perkName, 0,0,width,height)
			chick(173, 104)
			sleep, 200
			return 0
		}
	} 
	PopFirstLine(listfile)
} else {
	chick(173, 104)
	sleep, 200
	
	return 0
}
chick(173, 104)
sleep, 200
SendWebhookSnip("","Prestiged - " . perkName, 52, 129, 550, 230)
sleep, 500
return 1
}


