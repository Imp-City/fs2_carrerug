exitspawn(sprint, trials := 1){
    global t, width, height
if (faultcheck())
    return 1
MouseMove, MousePosX, MousePosY
Dllmove(0,1)
wheelups(20)
DllMove(0, 3000)
Sleep, 200
DllMove(0, -570)
Sleep, 200
l := 0
Loop { ;red finder
    PixelSearch, x,, (width/2)-6, 0, (width/2)+6, height, 0xBA200B, 15, Fast RGB
    PixelSearch, ,y, (width/2)-6, 0, (width/2)+6, height, 0xBA1D07, 15, Fast RGB
    if (x or y)
        break
    else {
        DllMove(100, 0)
        guicontrol,, Debug1, % "l= " . l
        if (l>40){
            return retrial(sprint,trials)
        }
        l++
    }
}
l=0
b=0
sleep, 200
;PixelSearch, x,, width/2-5, height*16/36, width/2+5, height*18/36, 0x52432C,10, Fast RGB
PixelSearch, b,,  width/2, height/4, width, height*3/4, 0xD5D2CE, 0, Fast RGB ;black board normal
PixelSearch, ,y,  width/2, height/4, width, height*3/4, 0xD5D2CD, 0, Fast RGB ;black board boss
if (b or y)
    dllmove(250,0)
else {
        Loop { ;black board
        PixelSearch, b,,  width/2-60, height/4, width/2+60, height*3/4, 0xD5D2CE, 0, Fast RGB ;normal
        PixelSearch, ,y,  width/2-60, height/4, width/2+60, height*3/4, 0xD5D2CD, 0, Fast RGB ;boss
        if (b or y)
            break
        else {
            DllMove(-50, 0)
        sleep, 10
            if (l>30){
                if (trials>3)
                    return 1
                else
                    return retrial(sprint,trials)
            }
        }
        l++
    }
    dllmove(100,0)
}
sleep, 200
l=0
Loop { ;grey finder
    PixelSearch, x,, width/2-15, height*23/48, width/2+15, height*25/48, 0x4C3416,10, Fast RGB ;normal
    PixelSearch, ,y, width/2-15, height*23/48, width/2+15, height*25/48, 0x563610,10, Fast RGB ;boss
    if (x or y)
        break
    else {
        DllMove(10, 0)
        if (l>60){
            if (trials>3)
                return 1
            else
                return retrial(sprint,trials)
        }
    }
    l++
}
if (sprint)
    w(1400)
else{
    SendInput, {w down}
    sleep, 2000*t
    SendInput, {w up}
}
l=0
if waitformorning()
    return 1
DllMove(-600, 3000)
Sleep, 200
DllMove(0, -560)
sleep, 100
Loop { ;red finder
    PixelSearch, x,, (width/2)-25, 0, (width/2)+25, height, 0xBA200B, 10, Fast RGB ;normal
    PixelSearch, ,y, (width/2)-25, 0, (width/2)+25, height, 0xBA1D07, 10, Fast RGB ;boss
    if (x or y)
        break   
    else {
        DllMove(-200, 0)
        if (l>20){
            return retrial(sprint,trials)
        }
    }
    l++
}
dllmove(350,0)
sleep, 50
Loop { ;red finder
    PixelSearch, x,, (width/2)-5, 0, (width/2)+5, height, 0xBA200B, 10, Fast RGB ;normal
    PixelSearch, ,y, (width/2)-5, 0, (width/2)+5, height, 0xBA1D07, 10, Fast RGB ;boss
    if (x or y)
        break
    else {
        DllMove(-30, 0)
        if (l>60){
            return retrial(sprint,trials)
        }
    }
    l++
}

dllmove(-500,0)
l=0
sleep, 200
loop { ;grey finder 2nd
    ;PixelSearch, x,, width/2, height*11/24, width/2, height*13/24, 0x4C3416,10, Fast RGB ;others
	PixelSearch, x,, width/2-5, height*22/48, width/2+30, height*26/48, 0x564A30,20, Fast RGB ;normal
    PixelSearch, ,y, width/2-5, height*22/48, width/2+30, height*26/48, 0x5D4C2F,30, Fast RGB ;boss
    if (x)
        break
    else {
		DllMove(7, 0)
        if (l>50){
            return retrial(sprint,trials)
        }
	}
    l++
}
loop { ;grey finder 2nd
    ;PixelSearch, x,, width/2, height*11/24, width/2, height*13/24, 0x4C3416,10, Fast RGB ;others
	PixelSearch, x,, width/2-2, height*22/48, width/2+2, height*26/48, 0x564A30,20, Fast RGB ;normal
    PixelSearch, ,y, width/2-2, height*22/48, width/2+2, height*26/48, 0x5D4C2F,30, Fast RGB ;boss
    if (x)
        break
    else {
		DllMove(1, 0)
        if (l>50){
            return retrial(sprint,trials)
        }
	}
    l++
}
send 1
DllMove(17, 0)
sendinput, {a down}{s down}
sleep, 200
sendinput, {a up}{s up}
i=0
MouseClick, R,,,,,D
while(i<3){
    l=0
    DllMove(-187,0)
    loop { ;grey finder 2nd
        sleep, 2
        ;PixelSearch, x,, width/2, height*11/24, width/2, height*11/24+6, 0x4C3416 ,15, Fast RGB ;others
        PixelSearch, x,, width/2, height*22/48, width/2, height*23/48, 0x5C4E35,30, Fast RGB ;normal
        PixelSearch, ,y, width/2, height*22/48, width/2, height*23/48, 0x5D4C2F,30, Fast RGB ;boss
		l++
        if (x or y)
            break
        else {
			DllMove(1 + 2*boolean(i<1), 0)
            if (l>201){
                return retrial(sprint,trials)
            }
		}
    }
    DllMove(179, 0)
    sendinput, {a down}{s down}
    sleep, 100
    sendinput, {a up}{s up}
    i++
}
sleep, 200

MouseClick, R,,,,,U
send 1
Sleep, 200

DllMove(1000, 1000)
a(1200)
wa(300)
send f
sleep, 100
return 0
}

retrial(sprint, trials){
    if (trials>3)
        return 1
    respawn()
    return exitspawn(sprint, trials+1)
}
