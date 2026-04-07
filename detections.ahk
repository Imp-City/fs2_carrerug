;#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force

boolean(x){
    ;GuiControl,, Debug1, At: boolean
    if (x)
        return 1
    else
        return 0
}

sunicon(){
	;GuiControl,, Debug1, At: sunicon
	PixelSearch, b,,  129, 716, 254, 734, 0x966400,0, Fast RGB ;yellow/sun icon
	return boolean(b)
}

waitfordawn(waitperiod:=1){
    GuiControl,, Debug1, At: waitfordawn
    while(sunicon()){
        if (handledeadcheck(0,1)<0)
            return 1
        sleep, 100
    } sleep, waitperiod*1000
    return 0
}
waitformorning(killwhended := 1, fromdeadcheck := 0){
    sleep, 1000
    GuiControl,, Debug1, At: waitformorning
    while(!sunicon()){
        GuiControl,, Debug1, At: waitformorning
        sleep, 2000
        if (fromdeadcheck){
            if faultcheck()
                return 1
        }else{
            if (handledeadcheck(0,killwhended)<0)
                return 1
        }
        sleep, 50
    } return 0
}
privategame(){
    GuiControl,, Debug1, At: privategame
    loop{
        PixelSearch, x,, 63, 575, 297, 594, 0xFFFFFF,0, Fast RGB 
        if (x)
            break
        sleep, 500
        if faultcheck()
            return 1
    }
    loop{
        chick(155, 585) ;PRIVATE GAME
        sleep, 1000
        PixelSearch, x,, 1018, 621, 1019, 682, 0xCD0C0B,3, Fast RGB 
        if (x)
            Return 0
        if faultcheck()
            return 1
    }
}
readyup(forceready := 0){
    GuiControl,, Debug1, At: readyup
    ;GuiControl,, Waiting, Status: Readying up...
    loop{
        PixelSearch, x,, 1251, 692, 1253, 706, 0xEDEDED,3, Fast RGB ;rdy
        if (!forceready and !sunicon()) 
            return 0
        ;GuiControl,, Debug1, % "debug: readyup:" . boolean(x)
        if (x){
            loop{
                if (handledeadcheck(0,1) < 0)
                    return 1
                chick(1306, 699)
                PixelSearch, x,, 1251, 692, 1253, 706, 0xEDEDED,3, Fast RGB ;rdy
                if (not x){
                    ;GuiControl,, Waiting, Status: Running, Do not perform any actions.
                    return 0
                }
            }
        }
        if (handledeadcheck(0,1) < 0)
            return 1
    }
}

faultcheck(){ ;insert for all endless loop
    global debug2faultcheck, debug2deadcheck
    global width, height
    PixelSearch, c,, width/2,height/2, width/2,height/2, 0x000000,0, Fast RGB ;shop die

    PixelSearch, d1,, 538, 363, 538, 363, 0xFF0000,0, Fast RGB ;die 1
    PixelSearch, d2,, 821, 364, 821, 364, 0xFF0000,0, Fast RGB ;die 2

    PixelSearch, e1,, 684, 308, 686, 310, 0xBDBEBE,0, Fast RGB ;disconnect 1
    PixelSearch, e2,, 620, 285, 746, 285, 0x393B3D,0, Fast RGB ;disconnect 2
    PixelSearch, e3,, 620, 285, 746, 285, 0xFFFFFF,0, Fast RGB ;disconnect 3
    debug2faultcheck :=  "dc:" . boolean(e1) . boolean(e2) . boolean(e3) . ", gg:" . boolean(c) . boolean(d1) . boolean(d2) 
    GuiControl,, Debug2, % debug2faultcheck . debug2deadcheck
    if ((c and d1 and d2) or (e1 and e2 and e3) or (not WinExist("ahk_exe RobloxPlayerBeta.exe"))){
        return 1
    } else
        return 0
}
restartroblox(){
    sleep, 2000
    GuiControl,, Debug1, At: restartroblox
    if WinExist("ahk_exe RobloxPlayerBeta.exe"){
        WinKill
        sleep, 50
        WinKill
    } 

    sleep, 500
    SetTitleMatchMode, 2
    if winExist("The Final Stand 2"){
        loop{
            WinActivate
            mouseclick, WheelUp
            mouseclick, WheelUp
            WinMove, ,, 0, 0, 1366, 768
            sleep, 2000
            chick(995, 441) ;play button
            wheelups(4)
            chick(995, 441)
            sleep, 2000
            l:=0
            while (l<40){ ;20 sec
                if WinExist("ahk_exe RobloxPlayerBeta.exe"){
                    sleep, 500
                    WinActivate
                    sleep, 500
                    GuiControl,, Waiting, Status: Running, Do not perform any actions
                    setfullscreen()
                    WinMove, ahk_exe RobloxPlayerBeta.exe,, 0, 0, 1366, 768
                    return 1
                }
                sleep, 500
                l++
            }
        }
    }
}
setfullscreen(){
    WinGetPos, X, Y, W, H, A
    if (W != A_ScreenWidth || H != A_ScreenHeight){
        Send, {F11}
    } sleep, 500
}
runPrepRefillFromDeadcheck(){
    GuiControl,, Debug1, At: preprefill fromdeadcheck
    sleep, 2000
    global wave
    if (wave < 29){
        return prepRefill([[0],[0],[0],[0]], 0)
    }
    ulist := [[0],[0],[0],[0],[2],[2],[2],[2],[4],[4],[4],[4],[1,[4,4]],[2],[2,[1,1],[4,1],[5,1]],[4],[4,[1,1],[2,1],[3,1],[4,4]]]
    return premRefill(ulist, 0)
}
runPostDeathRefill(){
    GuiControl,, Debug1, At: postdeathrefill fromdeadcheck
    sleep, 2000
    global wave, curendwave
    if (wave >= curendwave)
        return 0
    if (wave < 28){
        return prepRefill([[0],[0],[0],[0]], 0)
    }
    ulist := [[0],[0],[0],[0],[2],[2],[2],[2],[4],[4],[4],[4]]
    return premRefill(ulist, 0)
}
runAmmoRefillFromDeadcheck(){
    GuiControl,, Debug1, At: premrefill fromdeadcheck
    sleep, 2000
    global wave
    if (wave < 29){
        return prepRefill([], 0)
    }
    ulist := [[0],[0],[0],[0],[1,[4,1]],[2],[2,[1,1],[4,1],[5,1]],[4],[4,[1,1],[2,1],[3,1],[4,4]]]
    return premRefill(ulist, 0)
}
handledeadcheck(checkammo:= 0, killwhended := 0){
    status := deadcheck(checkammo, killwhended)
    if (status < 0)
        return -1
    if (killwhended and (status = 0 or status = 1))
        return -1
    if (status = 0){
    	GuiControl,, Debug1, handledeadcheck1 running waitformorning
		    sleep, 2000
        if waitformorning(0, 1)
            return -1
        if runPrepRefillFromDeadcheck()
            return -1
        return 0
    }
    if (status = 1){
        while (true){
            GuiControl,, Debug1, At: handledeadcheck death-loop
            if sunicon() {
                sleep, 10000
                break
            }
            if faultcheck()
                return -1
            status := deadcheck(0, 0)
            if (status < 0)
                return -1
            if (killwhended and (status = 0 or status = 1))
                return -1
            if (status = 0){
                GuiControl,, Debug1, handledeadcheck2 running waitformorning
		            sleep, 2000
                if waitformorning(0, 1)
                    return -1
                if runPrepRefillFromDeadcheck()
                    return -1
                return 0
            }
            sleep, 50
        }
        if runPostDeathRefill()
            return -1
        return 1
    }
    if (status = 2){
        if runAmmoRefillFromDeadcheck()
            return -1
        return 0
    }
    return 3
}
deadcheck(checkammo:= 0, killwhended := 0){
    global debug2faultcheck, debug2deadcheck
    global width, height
    global wave, curendwave
    PixelSearch, c,, width/2,height/2, width/2,height/2, 0x000000,0, Fast RGB ;shop die
    if faultcheck()
        return -1
    PixelSearch, d1,, 538, 690, 538, 690, 0x1F1F1F,0, Fast RGB ;ded pov
    PixelSearch, d2,, 529, 681, 530, 682, 0xFFFFFF,0, Fast RGB ;ded pov

    PixelSearch, a1,, 699, 696, 700, 697, 0xC0C1C0,0, Fast RGB ;not at ammo box

    PixelSearch, s1,, 235, 351, 236, 351, 0xFF0000,0, Fast RGB ;lose life 1
    PixelSearch, s2,, 632, 447, 632, 447, 0xFFFFFF,0, Fast RGB ;lose life 2
    debug2deadcheck := ", shop: " . boolean(c) . boolean(s1) . boolean(s2) . ", ded: " . boolean(d1) . boolean(d2) . ", wave: " . wave . "->" . curendwave
    if (c and s1 and s2) {
        return 0
    }
    if (d1 and d2){
        return 1
    }
    if (checkammo and a1){
        return 2
    }
    return 3
}
waitforplaybutton(appear){
    GuiControl,, Debug1, At: waitforplaybutton
    ; 1: wait play to appear
    ; 0: wait play to disappear
    loop{
        if faultcheck()
            return 1
        PixelSearch, x,, 648, 719, 715, 723, 0xFFFFFF, 30, Fast RGB 
        if (boolean(x) == boolean(appear))
            break 
        sleep, 100
    } return 0
}

ForcePlace(x, y, toolnumber, axis := 0, offset := 0) {
    GuiControl,, Debug1, At: ForcePlace
    send, 1
    sleep, 50
    Send, %toolnumber%
    sleep, 50

    Loop, 3 {
        pos := -offset
        while (pos <= offset) {
            curX := x
            curY := y

            if (axis = 0)
                curX := x + pos
            else if (axis = 1)
                curY := y + pos

            chick(curX, curY)

            Loop, 5 {
                PixelSearch, x1, y1, 128, 101, 1237, 694, 0xEEEE02, 1, Fast RGB
                PixelSearch, x2, y2, 0, 115, 1366, 629, 0x0265AF, 1, Fast RGB
                if (handledeadcheck(0,1) < 0)
                    return 1
                if (x1 || x2) {
                    Send, %toolnumber%
                    return 0
                }
                Sleep, 100
            }
            pos += 10
        }
    }
    return 1
}

closechat(){
    ;GuiControl,, Debug1, At: closechat
    PixelSearch, x, y, 134, 27, 142, 28, 0xF7F7F8, 1, Fast RGB
    if (x)
        chick(x,y)
}
