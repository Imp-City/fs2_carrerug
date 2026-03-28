;#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force

boolean(x){
    if (x)
        return 1
    else
        return 0
}

sunicon(){
	PixelSearch, b,,  129, 716, 254, 734, 0x966400,0, Fast RGB ;yellow/sun icon
	return boolean(b)
}

waitfordawn(){
    while(sunicon()){
        sleep, 100
    } sleep, 1000
}
waitformorning(){
    while(!sunicon()){
        sleep, 50
    }
}
readyup(){
    ;GuiControl,, Waiting, Status: Readying up...
    loop{
        PixelSearch, x,, 1251, 692, 1253, 706, 0xEDEDED,3, Fast RGB ;rdy
        ;GuiControl,, Debug1, % "debug: readyup:" . boolean(x)
        if (x){
            loop{
                chick(1306, 699)
                PixelSearch, x,, 1251, 692, 1253, 706, 0xEDEDED,3, Fast RGB ;rdy
                if (not x){
                    ;GuiControl,, Waiting, Status: Running, Do not perform any actions.
                    return 0
                }
            }
        }
        if (faultcheck(0))
            return 1
    }
}

faultcheck(force){ ;insert for all endless loop
	/*
    PixelSearch, x,, 641, 465, 641, 465, 0x393B3D,0, Fast RGB ;disconnected
    PixelSearch, y,, 809, 454, 809, 454, 0xFFFFFF,0, Fast RGB ;disconnected
    PixelSearch, z,, 636, 285, 636, 285, 0xBDBEBE,0, Fast RGB ;disconnected
    PixelSearch, a,, 219, 297, 219, 297, 0xFF0000,0, Fast RGB ;shop die
    PixelSearch, b,, 1071, 320, 1071, 320, 0xFF0000,0, Fast RGB ;shop die
    PixelSearch, c,, A_ScreenWidth/2,A_ScreenHeight/2, A_ScreenWidth/2,A_ScreenHeight/2, 0x000000,0, Fast RGB ;shop die
    GuiControl,, Debug2, % "fault: f:" . boolean(force) . " dc:" . boolean(x) . boolean(y) . boolean(z) . " ded:" . boolean(a) . boolean(b) . boolean(c)
    if (force or (x and y and z) or (a and b and c) or (not WinExist("ahk_exe RobloxPlayerBeta.exe"))){
        GuiControl,, Waiting, Status: Attempting to launch Roblox from Web.
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
                sleep, 8000
                chick(975, 424) ;play button
                mouseclick, WheelUp
                sleep, 500
                mouseclick, WheelUp
                sleep, 500
                chick(975, 424)
                sleep, 2000
                l=0
                while (l<40){ ;20 sec
                    if WinExist("ahk_exe RobloxPlayerBeta.exe"){
                        sleep, 500
                        WinActivate
                        GuiControl,, Waiting, Status: Running, Do not perform any actions
                        return 1
                    }
                    sleep, 500
                    l++
                }
            }
        }
    } else
        return 0
	*/
	return 0
}

waitforplacement(){
    loop{
        PixelSearch, x,y, 128, 101, 1237, 694, 0xEEEE02, 1, Fast RGB 
        PixelSearch, x2,y2, 0, 115, 1366, 629, 0x0265AF, 1, Fast RGB
        if (x or x2)
            break 
        sleep, 50
    }   
}