exitspawn(sprint, trials := 1){
    global t, width, height
GuiControl,, Debug1, At: exitspawn
if (faultcheck())
    return 1
chick(width/2, height/2)
Dllmove(0,1)
wheelups(20)
DllMove(0, 3000)
Sleep, 200
DllMove(0, -570)
Sleep, 200
l := 0
Loop { ;red finder
    x := findpx((width/2)-20, 0, (width/2)+20, height, 0xBA200B, 15)
    y := findpx((width/2)-20, 0, (width/2)+20, height, 0xBA1D07, 15)
    if (x or y)
        break
    else {
        DllMove(90, 0)
        guicontrol,, Debug1, % "l= " . l
        if (l>50){
            return retrial(sprint,trials)
        }
        l++
    }
}
l:=0
b:=0
sleep, 200
;PixelSearch, x,, width/2-5, height*16/36, width/2+5, height*18/36, 0x52432C,10, Fast RGB
b := findpx(width/2, height/4, width, height*3/4, 0xD5D2CE) ;black board normal
y := findpx(width/2, height/4, width, height*3/4, 0xD5D2CD) ;black board boss
if (b or y)
    dllmove(250,0)
else {
        Loop { ;black board
        b := findpx(width/2-60, height/4, width/2+60, height*3/4, 0xD5D2CE) ;normal
        y := findpx(width/2-60, height/4, width/2+60, height*3/4, 0xD5D2CD) ;boss
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
l:=0
Loop { ;grey finder
    x := findpx(width/2-15, height*23/48, width/2+15, height*25/48, 0x4C3416, 10) ;normal
    y := findpx(width/2-15, height*23/48, width/2+15, height*25/48, 0x563610, 10) ;boss
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
l:=0
sleep, 200
Loop { ;red finder
    x := findpx((width/2)-25, 0, (width/2)+25, height, 0xBA200B, 10) ;normal
    y := findpx((width/2)-25, 0, (width/2)+25, height, 0xBA1D07, 10) ;boss
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
    x := findpx((width/2)-5, 0, (width/2)+5, height, 0xBA200B, 10) ;normal
    y := findpx((width/2)-5, 0, (width/2)+5, height, 0xBA1D07, 10) ;boss
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
l:=0
sleep, 200
loop { ;grey finder 2nd
    ;PixelSearch, x,, width/2-5, height*22/48, width/2+30, height*26/48, 0x4C3416,10, Fast RGB ;normal
    ;PixelSearch, ,y, width/2-5, height*22/48, width/2+30, height*26/48, 0x563610,10, Fast RGB ;boss
	x := findpx(width/2-5, height*22/48, width/2+30, height*26/48, 0x564A30, 20) ;normal/carrer
    y := findpx(width/2-5, height*22/48, width/2+30, height*26/48, 0x5D4C2F, 30) ;boss/carrer
    if (x or y)
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
    ;PixelSearch, x,, width/2-2, height*22/48, width/2+2, height*26/48, 0x4C3416,10, Fast RGB ;normal
    ;PixelSearch, ,y, width/2-2, height*22/48, width/2+2, height*26/48, 0x563610,10, Fast RGB ;boss
	x := findpx(width/2-2, height*22/48, width/2+2, height*26/48, 0x564A30, 20) ;normal/carrer
    y := findpx(width/2-2, height*22/48, width/2+2, height*26/48, 0x5D4C2F, 30) ;boss/carrer
    if (x or y)
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
i:=0
MouseClick, R,,,,,D
while(i<3){
    l:=0
    DllMove(-187,0)
    loop { ;grey finder 2nd
        sleep, 2
        ;PixelSearch, x,, width/2, height*22/48, width/2, height*23/48, 0x4C3416,10, Fast RGB ;normal
        ;PixelSearch, ,y, width/2, height*22/48, width/2, height*23/48, 0x563610,10, Fast RGB ;boss
        x := findpx(width/2, height*22/48, width/2, height*23/48, 0x5C4E35, 30) ;normal/carrer
        y := findpx(width/2, height*22/48, width/2, height*23/48, 0x5D4C2F, 30) ;boss/carrer
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
if !atinteractable()
    return retrial(sprint,trials)
send f
sleep, 100
return 0
}

retrial(sprint, trials){
    GuiControl,, Debug1, At: retrial
    if (trials>3)
        return 1
    respawn()
    return exitspawn(sprint, trials+1)
}
