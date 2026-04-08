;#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force

findpx(x1, y1, x2, y2, color, tolerance := 0) {
    PixelSearch, foundX, foundY, %x1%, %y1%, %x2%, %y2%, %color%, %tolerance%, Fast RGB
    return !ErrorLevel
}

boolean(x){
    ;GuiControl,, Debug1, At: boolean
    if (x)
        return 1
    else
        return 0
}

sunicon(){
	;GuiControl,, Debug1, At: sunicon
	return findpx(129, 716, 254, 734, 0x966400) ;yellow/sun icon
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
waitformorning(killwhended := 1, fromdeadcheck := 0){
    GuiControl,, Debug1, At: waitformorning
    while(!sunicon()){
        if (fromdeadcheck){
            if faultcheck()
                return 1
        } else {
            if (deadcheck(0,killwhended)<0)
                return 1
        }
        sleep, 50
    } return 0
}
privategame(){
    GuiControl,, Debug1, At: privategame
    loop{
        if findpx(63, 575, 297, 594, 0xFFFFFF)
            break
        sleep, 500
        if faultcheck()
            return 1
    }
    loop{
        chick(155, 585) ;PRIVATE GAME
        sleep, 1000
        if findpx(1018, 621, 1019, 682, 0xCD0C0B, 3)
            Return 0
        if faultcheck()
            return 1
    }
}
readyup(forceready := 0){
    GuiControl,, Debug1, At: readyup
    ;GuiControl,, Waiting, Status: Readying up...
    loop{
        x := findpx(1251, 692, 1253, 706, 0xEDEDED, 3) ;rdy
        if (!forceready and !sunicon()) 
            return 0
        ;GuiControl,, Debug1, % "debug: readyup:" . boolean(x)
        if (x){
            loop{
                if (deadcheck(0,1) < 0)
                    return 1
                chick(1306, 699)
                x := findpx(1251, 692, 1253, 706, 0xEDEDED, 3) ;rdy
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


waitforplaybutton(appear){
    GuiControl,, Debug1, At: waitforplaybutton
    ; 1: wait play to appear
    ; 0: wait play to disappear
    loop{
        if faultcheck()
            return 1
        x := findpx(648, 719, 715, 723, 0xFFFFFF, 30)
        if (boolean(x) == boolean(appear))
            break 
        sleep, 100
        if (appear)
            send, m
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
                if (deadcheck(0,1) < 0)
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

atinteractable(){
    return findpx(633, 682, 732, 683, 0xFFFFFF)
}