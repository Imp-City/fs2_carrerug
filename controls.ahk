a(x){
    global t
    SendInput, {a down}{Shift down}
    Sleep x*t
    SendInput, {a up}{Shift up}
}
d(x){
    global t
    SendInput, {d down}{Shift down}
    Sleep x*t
    SendInput, {d up}{Shift up}
}
s(x){
    global t
    SendInput, {s down}{Shift down}
    Sleep x*t
    SendInput, {s up}{Shift up}
}
w(x){
    global t
    SendInput, {w down}{Shift down}
    Sleep x*t
    SendInput, {w up}{Shift up}
}
wa(x){
    global t
    SendInput, {w down}{a down}{Shift down}
    Sleep x*t
    SendInput, {w up}{a up}{Shift up}
}
wd(x){
    global t
    SendInput, {w down}{d down}{Shift down}
    Sleep x*t
    SendInput, {w up}{d up}{Shift up}
}
sa(x){
    global t
    SendInput, {s down}{a down}{Shift down}
    Sleep x*t
    SendInput, {s up}{a up}{Shift up}
}
sd(x){
    global t
    SendInput, {s down}{d down}{Shift down}
    Sleep x*t
    SendInput, {s up}{d up}{Shift up}
}
nw(x){
    global t
    SendInput, {w down}
    Sleep x*t
    SendInput, {w up}
}
na(x){
    global t
    SendInput, {a down}
    Sleep x*t
    SendInput, {a up}
}
ns(x){
    global t
    SendInput, {s down}
    Sleep x*t
    SendInput, {s up}
}
nd(x){
    global t
    SendInput, {d down}
    Sleep x*t
    SendInput, {d up}
}
DllMove(x, y) {
    ;GuiControl,, Debug1, At: DllMove
    DllCall("mouse_event", "UInt", 0x01, "UInt", x, "UInt", y)
}

chick(x,y){
    ;GuiControl,, Debug1, At: chick
    mousemove, x, y-1
    sleep, 35
		Dllmove(0,1)
		sleep, 35
		click, Down
    sleep, 35
    click, Up
}

chicks(x,y, c){
    ;GuiControl,, Debug1, At: chicks
    mousemove, x, y-1
	l := 0
	while (l<c){
		sleep, 35
		Dllmove(0,1)
		sleep, 35
		click, Down
		sleep, 35
		click, Up
		l++
	}
}
chickstill() {
    ;GuiControl,, Debug1, At: chickstill
    Click down
    Sleep, 50
    Click up
    Sleep, 50
}

reload() {
    ;GuiControl,, Debug1, At: reload
    Send, {r down}
    Sleep, 50
    Send, {r up}
    Sleep, 50
}

respawn(){
    GuiControl,, Debug1, At: respawn
    i:=0
    while (i<11){
        send, {esc}
        sleep, 100
        send, R
        sleep, 100
        send, {Enter}
        sleep, 200
        i++
    }
    sleep, 1000
}

wheeldowns(times){
    l:=0
    while (l<times){
        MouseClick, WheelDown
        sleep, 50
        l++
    }
}
wheelups(times){
    l:=0
    while (l<times){
        MouseClick, WheelUp
        sleep, 50
        l++
    }
}
upgrade(selection, count){
    GuiControl,, Debug1, At: upgrade
    lowerselection(2)
    selection--
    chicks(432 + 243*mod(selection, 3), 407 + 109*Floor(selection/3), count)
}

setdefaults(slist){
    chick(687, 183) ;keyboard
    GuiControl,, Debug1, At: setdefaults    
    sleep, 50
    for _, selection in slist {
        selection--
        chicks(642 + 290*mod(selection, 2), 218 + 48*Floor(selection/2), 2)
        ;MsgBox,, % selection
    }
}

buy(times := 1){
    GuiControl,, Debug1, At: buy
    Loop, %times% {
        chick(964,378)
        sleep, 50
    }
}
lowerselection(n){
    ;GuiControl,, Debug1, At: lowerselection
    chick(434 + 125*n, 667)
    /*
    0: <<BACK<<
    1: STATS
    2: UPGRADES
    3: SKINS
    4: >>NEXT>>
    */
}
nextsection(n){
    GuiControl,, Debug1, At: nextsection
    while (n<0){
        lowerselection(0)
        n++
    }
    while (n>0){
        lowerselection(4)
        n--
    }
}

setfullscreen(){
    SetTitleMatchMode, 2
    WinGetPos, X, Y, W, H, ahk_exe RobloxPlayerBeta.exe
    while (X > 0 || Y > 0 || W != A_ScreenWidth || H != A_ScreenHeight){
        Send, {F11}
        sleep, 1000
        WinGetPos, X, Y, W, H, ahk_exe RobloxPlayerBeta.exe
    }
    WinMove, ahk_exe RobloxPlayerBeta.exe,, 0, 0, 1366, 768
}

readywithweapon(){
    GuiControl,, Debug1, At: readywithweapon
    send, 1
    sleep, 100
    send, 1
    wheeldowns(1)
    readyup()
    wheelups(10)
}

place(x,y,toolnumber){
	;GuiControl,, Debug1, At: place
	send, %toolnumber%
	sleep, 50
	chick(x,y)
	sleep, 50
	send, %toolnumber%
}
rotate(count, toolnumber){
	;GuiControl,, Debug1, At: rotate
	send, %toolnumber%
	l:=0
	while (l<count){
		l++
		sleep, 100
		send, r
	}
	sleep, 100
	send, %toolnumber%
}
togglemode(count,toolnumber){
    l:=0
	send, %toolnumber%
	l:=0
	while (l<count){
		l++
		sleep, 100
		send, b
	}
	sleep, 100
	send, %toolnumber%
}

openunlocks(){
    timer(0)
	while true{
		if timer(10)
			return 1
		a := findpx(272, 489, 279, 490, 0xFFFF00) ;prestige/perks open
		if (a)
			return 0
		chick(439, 737)
		sleep, 100
	}
}