doortostair(){
	d(500)
    sd(500)
    d(700)
    sd(150)
    a(200)
}
barricadetosentry(){
	w(3800)
}
stairtoshop(){
	w(2700)
	nw(100)
}
shoptostair(){
	ns(300)
	a(400)
	s(2700)
	d(200)
	sd(150)
	a(200)
}
stairtoupgs(){
	nd(400)
	SendInput, {d down}
	ns(1600)
	SendInput, {d up}
}
upgstostair(){
	SendInput, {a down}
	nw(2400)
	SendInput, {a up}
	ns(1000)
	nd(500)
	SendInput, {a down}
	ns(250)
	SendInput, {a up}
	na(300)
}
shoptomines(){
	nw(4625)
}
sentrytoladder(){
	wa(500)
	w(2200)
}
laddertospawn(){
	w(4200)
	wd(800)
}
placespawnfl(){
	global snowball
	global width
	global height
	w(3000) ;12s baseline maxw
	if (snowball)
		rotate(4,8) ;flip floodlight backwards
	Else
		rotate(4,2)
	sleep, 100
	if (snowball)
		place(width/2, 120,8)
	Else
		place(width/2, 120,2)
	s(3500)
}
place(x,y,toolnumber){
	send, %toolnumber%
	sleep, 50
	chick(x,y)
	sleep, 50
	send, %toolnumber%
}
rotate(count, toolnumber){
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

lefttripmine(toolnumber){
	global width
	global height
	l:=0
	while (l<6){
		ForcePlace(width/4, height/2, toolnumber)
		nw(180)
		l++
	} sleep, 50
}
leftlandmine(toolnumber){
	global width
	global height
	l:=0
	while (l<4){
		ForcePlace(742 + 5*l, 422, toolnumber)
		nw(170)
		l++
	} sleep, 50
}
setupleftmines(){
	global width
	global height
	na(1200)
	ForcePlace(width/2, height*3/4, 5)
	wheelups(5)
	nw(1100)
	lefttripmine(6)
	nw(600)
	leftlandmine(5)
	wheeldowns(5)
}

setuprightminesandfl(){
	global width
	global height
	nd(1500)
	wheelups(5)
	nw(1100)
	righttripmine(6)
	nw(300)
	rightlandmine(5)
	wheeldowns(5)
	nw(2000)
	na(800)
	if (snowball)
		ForcePlace(width/2,height*2/5,8) ;floodlight
	Else
		ForcePlace(width/2,height*2/5,2) ;floodlight
	
	nw(3000)
	if (snowball)
		place(A_ScreenWidth/2,A_ScreenHeight*2/5,8) ;floodlight
	Else
		place(A_ScreenWidth/2,A_ScreenHeight*2/5,2) ;floodlight
}

righttripmine(toolnumber){
	global width
	global height
	ForcePlace(width*3/4, height/2, toolnumber)
	l:=0
	nw(180)
	while (l<5){
		ForcePlace(width-1, height/2, toolnumber)
		nw(180)
		l++
	} sleep, 50
	send, %toolnumber%
}
rightlandmine(toolnumber){
	global width
	global height
	send, %toolnumber%
	l:=0
	
	while (l<3){
		ForcePlace(565- 10*l, 431, toolnumber)	
		nw(180)
		l++
	} nw(40)
	ForcePlace(539, 430, toolnumber)
}

ammotocliff(){
	wd(1100)
	SendInput, {Space down}
	w(1000)
	SendInput, {Space up}
	w(6500)
	SendInput, {Space down}
	w(1000)
	SendInput, {Space up}
	nw(500)
	wheelups(20)
	dllmove(0,-450)
}

firetillmorning(firedelay) {
	send, 3
	sleep, 100
	send, e
	sleep, 500
    Loop {
        chickstill()  ; fire once

		failsafe1:=deadcheck(0)
		if (failsafe1<2)
			return failsafe1

        start := A_TickCount
        while (A_TickCount - start < firedelay) {
            reload()
            if (sunicon()) {
                graceStart := A_TickCount
                while (A_TickCount - graceStart < 1000) {
                    chickstill()
					start := A_TickCount
					while (A_TickCount - start < firedelay)
                    	reload()
                }

                ; one final shot before exiting
                chickstill()
                sleep, 100
				send, 3
				return 1
            }
        }
        if (sunicon()) {
           graceStart := A_TickCount
            while (A_TickCount - graceStart < 1000) {
                chickstill()
				start := A_TickCount
				while (A_TickCount - start < firedelay)
                	reload()
            }
            ; one final shot before exiting
            chickstill()
            sleep, 100
			send, 3
			return 1
        }
    }
	return 0
}

runWaveBlock(startWave, endWave, fireDelay) {
    wave := startWave
    while (wave <= endWave) {
		readywithweapon()
		if (waitfordawn(0))
			return 1
		send, 7 ;oc remote
		sleep, 100
		chickstill()
		sleep, 900
		send, 7 ;oc remote
		failsafe2:=firetillmorning(fireDelay)
		if (failsafe2<0)
			return 1
        wave+=failsafe2
    } return 0
}

prepRefill(ulist) {
	delay := A_TickCount
	if prestige()
		if equipallfunction()
			return 1
	while (A_TickCount - delay < 4000){
		faultcheck()
		sleep, 200
	}
    respawn()
	if (exitspawn(1))
		return 1
	wheeldowns(6)
    doortostair()
	stairtoupgs()
	send, f

	for i, item in ulist {
		section := item[1]
		nextsection(section)

		if (item.Length() = 1) {
			buy()
		} else {
			Loop, % item.Length() - 1 {
				selection := item[A_Index + 1][1]
				count := item[A_Index + 1][2]
				upgrade(selection, count)
				Sleep, 100
			}
		}

		nextsection(-section)
	}
	nextsection(1)
	loop, 4
		buy()
	nextsection(-1)

	sleep, 100
	send, f
	sleep, 100
	upgstostair()
	stairtoshop()
	a(800)
	refill(3) ;m32
	if (deadcheck(1)<0)
		return 1
    if (readyup())
		return 1
    ammotocliff()
	if (waitfordawn(0))
		return 1
	return 0
}
refill(toolnumber){
	send, %toolnumber% ;m32
	sleep, 100
	send, f
	sleep, 300
	send, %toolnumber% ;m32
}

premRefill(ulist) {
	delay := A_TickCount
	if prestige()
		if equipallfunction()
			return 1
	while (A_TickCount - delay < 4000){
		faultcheck()
		sleep, 200
	}
    respawn()
	if (exitspawn(1))
		return 1
	wheeldowns(6)
    doortostair()
	stairtoupgs()
	send, f

	for i, item in ulist {
		section := item[1]
		nextsection(section)

		if (item.Length() = 1) {
			buy()
		} else {
			Loop, % item.Length() - 1 {
				selection := item[A_Index + 1][1]
				count := item[A_Index + 1][2]
				upgrade(selection, count)
				Sleep, 100
			}
		}

		nextsection(-section)
	}
	nextsection(1)
	loop, 4
		buy()
	nextsection(-1)

	sleep, 100
	send, f
	sleep, 100
	upgstostair()
	stairtoshop()
	d(500)
	sd(300)
	d(500)
	w(100)
	d(100)
	wheelups(20)
	send {Space down}
	ns(1000)
	send {Space up}
	wheeldowns(6)
	nw(500)
	sa(600)
	refill(3)
	send {Space down}
	nw(1300)
	send {Space up}
	if (deadcheck(1)<0)
		return 1
	if (readyup())
		return 1
	wa(1100)
	SendInput, {Space down}
	w(1000)
	SendInput, {Space up}
	w(6500)
	SendInput, {Space down}
	w(1000)
	SendInput, {Space up}
	nw(500)
	wheelups(20)
	dllmove(0,-450)
	if (waitfordawn(0))
		return 1
	sleep, 1000
	return 0
}
