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
        if (deadcheck(0,1)<0)
            return 1
        sleep, 100
    } sleep, waitperiod*1000
    return 0
}
waitformorning(killwhended := 1){
    GuiControl,, Debug1, At: waitformorning
    while(!sunicon()){
        if (deadcheck(0,killwhended)<0)
            return 1
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
                if (deadcheck(0,1) < 0)
                    return 1
                chick(1306, 699)
                PixelSearch, x,, 1251, 692, 1253, 706, 0xEDEDED,3, Fast RGB ;rdy
                if (not x){
                    ;GuiControl,, Waiting, Status: Running, Do not perform any actions.
                    return 0
                }
            }
        }
        if (deadcheck(0,1) < 0)
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
    debug2faultcheck = % "dc:" . boolean(e1) . boolean(e2) . boolean(e3) . ", ded:" . boolean(c) . boolean(d1) . boolean(d2)
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
            l=0
            while (l<40){ ;20 sec
                if WinExist("ahk_exe RobloxPlayerBeta.exe"){
                    sleep, 500
                    WinActivate
                    GuiControl,, Waiting, Status: Running, Do not perform any actions
                    WinMove, ahk_exe RobloxPlayerBeta.exe,, 0, 0, 1366, 768
                    return 1
                }
                sleep, 500
                l++
            }
        }
    }
}

deadcheck(checkammo:= 0, killwhended := 0){
    global debug2faultcheck, debug2deadcheck
    global width, height
    global wave
    PixelSearch, c,, width/2,height/2, width/2,height/2, 0x000000,0, Fast RGB ;shop die
    faultcheck()
    PixelSearch, d1,, 538, 690, 538, 690, 0x1F1F1F,0, Fast RGB ;ded pov
    PixelSearch, d2,, 529, 681, 530, 682, 0xFFFFFF,0, Fast RGB ;ded pov

    PixelSearch, a1,, 699, 696, 700, 697, 0xC0C1C0,0, Fast RGB ;not at ammo box

    PixelSearch, s1,, 235, 351, 235, 351, 0xFF0000,0, Fast RGB ;lose life 1
    PixelSearch, s2,, 807, 422, 807, 422, 0xFF0000,0, Fast RGB ;lose life 2
    debug2deadcheck = % ", shop: " . boolean(c) . boolean(s1) . boolean(s2) . ", die: " . boolean(d1) . boolean (d2)
    if (c and s1 and s2) {
        if (faultcheck() or killwhended)
            return -1
        waitformorning()
        if (wave<29){
            prepRefill([[0],[0],[0],[0]], 0)
        } else {
            ulist := [[0],[0],[0],[0],[2],[2],[2],[2],[4],[4],[4],[4],[1,[1,5],[4,4]],[2],[2,[1,1],[4,1],[5,1]],[4],[4,[1,1],[2,1],[3,1],[4,4]]]
            premRefill(ulist, 0)
        } 
        return 1
    }

    if (d1 and d2){
        if (faultcheck() or killwhended)
            return -1
        while (true){
            if sunicon() {
                sleep, 10000
                break
            }
            if (c and s1 and s2)
                return deadcheck()
        }
        if (wave<29){
            prepRefill([[0],[0],[0],[0]], 0)
        } else {
            ulist := [[0],[0],[0],[0],[2],[2],[2],[2],[4],[4],[4],[4],[1,[1,5],[4,4]],[2],[2,[1,1],[4,1],[5,1]],[4],[4,[1,1],[2,1],[3,1],[4,4]]]
            premRefill(ulist, 0)
        }
        return 0
    }


    if (checkammo and a1){
        if (wave<29){
            prepRefill([])
        } else {
            ulist := [[0],[0],[0],[0],[1,[1,5],[4,4]],[2],[2,[1,1],[4,1],[5,1]],[4],[4,[1,1],[2,1],[3,1],[4,4]]]
            premRefill(ulist)
        }
        return 0
    }
    return 2
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
    loop {
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
                    if (deadcheck(0,1) < 0)
                        return 1
                    if (x1 || x2) {
                        Send, %toolnumber%
                        return
                    }
                    Sleep, 100
                }

                pos += 10
            }
        }
        if (deadcheck(0,1) < 0)
            return 1
    }
    return 0
}

closechat(){
    ;GuiControl,, Debug1, At: closechat
    PixelSearch, x, y, 134, 27, 142, 28, 0xF7F7F8, 1, Fast RGB
    if (x)
        chick(x,y)
}
