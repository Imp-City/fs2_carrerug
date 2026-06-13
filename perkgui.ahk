EquipAll:
	if equipallfunction()
		goto, startmacro
return

	
equipallfunction(){
	GuiControl,, Debug1, At: equipall
	global setupfile
	global searchX, searchY, perkX, perkY, difX, difY, slotX, slotY, slotSpace
	global width, height
	chick()
	GuiControl,, Debug2, % "EquipAll:" . boolean(a)
	if openunlocks()
		return 1
	; 113, 578 ; 75x75
	; 0 indexing: 113 + 75*(slot%6), 578 + 75*(slot%6)
	; 562, 120, 50x50 (+ 9): r b g y p
	; 938, 660
	; prevSlot:= -1

	Loop, Read, %setupfile%
	{
		line := A_LoopReadLine

		if (Trim(line) = "")
			continue

		parts := StrSplit(line, "|")
		perkName := parts[1]
		column := parts[2]
		color := parts[3]
		slot := parts[4]

		;if (prevslot>=0){
		;	checkEquip(prevslot)
		;} 
		; perk equip
		chick(searchX, searchY)
		SelectPerk(PerkName)
		chicks(perkX + difX*column, perkY + DifY*color, 2)
		sleep, 100
		if (maxlvperk())
			return 1
		chicks(slotX + slotSpace*Mod(slot,6), slotY + slotSpace*Floor((slot)/6), 2)
		prevslot:= slot
	} return 0
}

testpos:
chick()
sleep, 100
setfullscreen()
Gui, Submit, NoHide
v := Inputcheck()
GuiControl, text, testpos, % v
if (v="Success!"){
	chick(searchX, searchY)
	SelectPerk(PerkName)
	sleep, 50
	chick(perkX + difX*(column), perkY + DifY*color)
	sleep, 500
	chick(slotX + slotSpace*Mod(slot,6), slotY + slotSpace*Floor((slot)/6))
	GuiControl, text, testpos, Add if correct!
}
slot++
sleep, 500
GuiControl, text, testpos, Test Position
return

Queue:
slot:=1
hideeverything()
guicontrol,, headline, AutoPres: Input Column, Row, and Color of the perk: r,b,g,y,p

gui, add, text, x15 y13 h13 w110, Perk Name:
gui, add, text, x185 y13 h14 w40, Column:
gui, add, text, x235 y13 h14 w40, Color:

gui, add, Edit, x10 y26 h17 w175 vperkName,
gui, add, Edit, x185 y26 h17 w50 vcolumn, 1
gui, add, Edit, x235 y26 h17 w50 vcolor, r

gui, add, button, x10 y43 h17 w90 gadd vadd, Add Perk
gui, add, button, x100 y43 h17 w95 gtestpos vtestpos, Test Position
gui, add, button, x195 y43 h17 w90 gviewqueue vviewqueue, View Queue
return

perksetup:
hideeverything()
guicontrol,, headline, Perk Setup: Order row from top to bottom.

gui, add, text, x15 y13 h13 w140, Perk Name:
gui, add, text, x160 y13 h13 w40, Column:
gui, add, text, x210 y13 h13 w35, Color:
gui, add, text, x250 y13 h13 w35, Slot:

gui, add, Edit, x10 y25 h17 w150 vperkName,
gui, add, Edit, x160 y25 h17 w50 vcolumn, 1
gui, add, Edit, x210 y25 h17 w40 vcolor, r
gui, add, Edit, x250 y25 h17 w40 vslot, 1

gui, add, button, x10 y43 h17 w70 gadd2 vadd2, Add Perk
gui, add, button, x80 y43 h17 w70 gtestpos vtestpos, Test Position
Gui, add, button, x150 y43 h17 w70 gequipall vequipall, Equip All
gui, add, button, x220 y43 h17 w70 gviewsetup vviewsetup, View Setup
return

add:
Gui, Submit, NoHide
if not FileExist(listfile)
	FileAppend,, %listfile%

v := Inputcheck()
GuiControl, text, add, % v
if (v = "Success!")
	FileAppend, % perkName "|" column "|" color "`n", %listfile%
sleep, 500
GuiControl, text, add, Add Perk
if WinExist("Prestige Queue Viewer"){
	ShowFileViewer(viewerFile, viewerTitle, viewerMode)
} slot := 1
return

add2:
Gui, Submit, NoHide
if not FileExist(setupfile)
	FileAppend,, %setupfile%
v := Inputcheck()
GuiControl, text, add2, % v
if (v = "Success!")
	FileAppend, % perkName "|" column "|" color "|" slot "`n", %setupfile%
sleep, 500
GuiControl, text, add2, Add Perk
if WinExist("Perk Setup Viewer"){
	ShowFileViewer(viewerFile, viewerTitle, viewerMode)
}
return

viewqueue:
ShowFileViewer(listfile, "Prestige Queue Viewer", "queue")
return

viewsetup:
ShowFileViewer(setupfile, "Perk Setup Viewer", "setup")
return

Configure:
hideeverything()
WinSetTitle,, , % "Perk Macro Configuration"
GuiControl, Hide, headline
sleep, 50
fileread, snowball, %snowballfile%
fileread, techlv, %techlvfile%
fileread, webhook, %webhookURLfile%
fileread, keystrokedelay, %keystrokedelayfile%
Gui, Add, Text, x10 y5 w45 h18 , Snowball
Gui, Add, Edit, x55 y1 w20 h18 vsnowball, % snowball
Gui, Add, Text, x77 y5 w50 h18 center, Tech lv4
Gui, Add, Edit, x128 y1 w20 h18 vtechlv, % techlv
Gui, Add, Text, x30 y23 w90 h18 center, Keystroke Delay
Gui, Add, Edit, x128 y19 w20 h18 vkeystrokedelay, % (keystrokedelay = "" ? 1 : keystrokedelay)
gui, add, text, x150 y0 h13 w140 center, Webhook URL
Gui, Add, Edit, x150 y13 w140 h48 vwebhook, % webhook
Gui, Add, Button, x10 y38 w140 h22 gsendconfig vsendconfig, Submit
return

sendconfig:
Gui, Submit, NoHide
GuiControl, text, sendconfig, Submitting
FileDelete, %snowballfile%
FileAppend, %snowball% , %snowballfile%
FileDelete, %techlvfile%
FileAppend, %techlv% , %techlvfile%
FileDelete, %webhookURLfile%
FileAppend, %webhook% , %webhookURLfile%
FileDelete, %keystrokedelayfile%
FileAppend, %keystrokedelay% , %keystrokedelayfile%
GuiControl, text, sendconfig, Submitted!
sleep, 500
GuiControl, text, sendconfig, Submit
Return

hideeverything(){
	; GuiControl,, Debug1, At: hideeverything
	GuiControl, Hide, settingadjust
    GuiControl, Hide, initializemacro
    GuiControl, Hide, Configure
    GuiControl, Hide, Perksetup
    GuiControl, Hide, Queue
    GuiControl, Hide, snowtext
	guicontrol, Hide, waiting
    GuiControl, Hide, Debug1
    GuiControl, Hide, Debug2
    GuiControl, Hide, Debug3
}

inputcheck(){
	;GuiControl,, Debug1, At: inputcheck
	global perkName
	global column
	global color
	global slot
	if (color = "r") {
		color := 0
	} else if (color = "b") {
		color := 1
	} else if (color = "g") {
		color := 2
	} else if (color = "y") {
		color := 3
	} else if (color = "p") {
		color := 4
	} else {
		return "Invalid Color!"
	}
	if (column<1 or column>14){
		return "Invalid Column!"
	}
	if (slot<1 or slot>12){
		return "Invalid Perk Slot!"
	}
	column--
	slot--
	return "Success!"
}

PopFirstLine(file) {
	;GuiControl,, Debug1, At: PopFirstLine
	FileRead, content, %file%
	first := RegExMatch(content, "^[^\r\n]*", line)
	content := RegExReplace(content, "^[^\r\n]*\r?\n")
	FileDelete, %file%
	FileAppend, %content%, %file%
	return line
}

throttledDebugUpdate(force:=0) {
    global lastDebugUpdate, pendingFaultDebug, pendingDeadDebug, errortimer, killtimer
    if (A_TickCount - lastDebugUpdate >= 1000 or force) {
        GuiControl,, Debug2, % pendingFaultDebug . pendingDeadDebug
		GuiControl,, Debug3, % "ErrorTimer:" . errortimer . "->" . killtimer
        lastDebugUpdate := A_TickCount
    }
}

updateFaultDebug(dc1, dc2, dc3, gg1, gg2, gg3) {
    global pendingFaultDebug
    pendingFaultDebug := "dc:" . dc1 . dc2 . dc3 . ", gg:" . gg1 . gg2 . gg3
    throttledDebugUpdate()
}

updateDeadDebug(shop, lose1, lose2, ded1, ded2, wave, curendwave := "") {
    global pendingDeadDebug
    if (curendwave != "")
        pendingDeadDebug := ", shop: " . shop . lose1 . lose2 . ", ded: " . ded1 . ded2 . ", wave: " . wave . "->" . curendwave
    else
        pendingDeadDebug := ", shop: " . shop . lose1 . lose2 . ", ded: " . ded1 . ded2 . ", wave: " . wave
    throttledDebugUpdate()
}

SelectPerk(PerkName){
	global keystrokedelay
	SetKeyDelay, %keystrokedelay%
	SendEvent, %PerkName%
	SetKeyDelay, 0
	sleep, 10
}