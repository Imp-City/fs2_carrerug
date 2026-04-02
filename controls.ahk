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
    DllCall("mouse_event", "UInt", 0x01, "UInt", x, "UInt", y)
}

chick(x,y){
    mousemove, x, y-1
    sleep, 25
		Dllmove(0,1)
		sleep, 25
		click, Down
    sleep, 25
    click, Up
}

chicks(x,y, c){
    mousemove, x, y-1
	l := 0
	while (l<c){
		sleep, 25
		Dllmove(0,1)
		sleep, 25
		click, Down
		sleep, 25
		click, Up
		l++
	}
}
chickstill() {
    Click down
    Sleep, 50
    Click up
    Sleep, 50
}

reload() {
    Send, {r down}
    Sleep, 50
    Send, {r up}
    Sleep, 50
}

respawn(){
    i=0
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
    lowerselection(2)
    selection--
    chicks(432 + 243*mod(selection, 3), 407 + 109*Floor(selection/3), count)
}
buy(){
    chick(964,378) 
}
lowerselection(n){
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
    while (n<0){
        lowerselection(0)
        n++
    }
    while (n>0){
        lowerselection(4)
        n--
    }
}
readywithweapon(){
    send, 1
    sleep, 100
    send, 1
    wheeldowns(1)
    readyup()
    wheelups(10)
}