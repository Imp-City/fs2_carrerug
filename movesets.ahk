doortostair(){
	GuiControl,, Debug1, At: doortostair
	d(500)
    sd(500)
    d(700)
    sd(150)
    a(200)
}
barricadetosentry(){
	GuiControl,, Debug1, At: barricadetosentry
	w(3800)
}
stairtoshop(){
	GuiControl,, Debug1, At: stairtoshop
	w(2700)
	nw(100)
}
shoptostair(){
	GuiControl,, Debug1, At: shoptostair
	ns(300)
	a(400)
	s(2700)
	d(200)
	sd(150)
	a(200)
}
stairtoupgs(){
	GuiControl,, Debug1, At: stairtoupgs
	nd(400)
	SendInput, {d down}
	ns(1600)
	SendInput, {d up}
}
upgstostair(){
	GuiControl,, Debug1, At: upgstostair
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
	GuiControl,, Debug1, At: shoptomines
	nw(4625)
}
sentrytoladder(){
	GuiControl,, Debug1, At: sentrytoladder
	wa(500)
	w(2200)
}
laddertospawn(){
	GuiControl,, Debug1, At: laddertospawn
	w(4200)
	wd(800)
}
placespawnfl(){
	GuiControl,, Debug1, At: placespawnfl
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

lefttripmine(toolnumber){
	GuiControl,, Debug1, At: lefttripmine
	global width
	global height
	l:=0
	while (l<6){
		if (ForcePlace(width/4, height/2, toolnumber))
			return 1
		nw(180)
		l++
	}
	sleep, 50
	return 0
}
leftlandmine(toolnumber){
	GuiControl,, Debug1, At: leftlandmine
	global width
	global height
	l:=0
	while (l<4){
		if (ForcePlace(742 + 5*l, 422, toolnumber))
			return 1
		nw(200)
		l++
	}
	sleep, 50
	return 0
}
setupleftmines(){
	GuiControl,, Debug1, At: setupleftmines
	global width
	global height
	na(1200)
	if (techlv = 1)
		if (ForcePlace(width/2, height*3/4, 5))
			return 1
	wheelups(5)
	nw(1150)
	if (lefttripmine(6))
		return 1
	nw(500)
	if (leftlandmine(5))
		return 1
	wheeldowns(5)
	return 0
}

setuprightminesandfl(){
	GuiControl,, Debug1, At: setuprightminesandfl
	global width
	global height
	global snowball
	nd(1800)
	wheelups(5)
	nw(1100)
	if (righttripmine(6))
		return 1
	nw(300)
	if (rightlandmine(5))
		return 1
	wheeldowns(5)
	nw(1700)
	na(800)
	if (snowball){
		if (ForcePlace(width/2,height*2/5,8)) ;floodlight
			return 1
	}Else
		if (ForcePlace(width/2,height*2/5,2)) ;floodlight
			return 1
	
	nw(3000)
	if (snowball)
		place(width/2,height*2/5,8) ;floodlight
	Else
		place(width/2,height*2/5,2) ;floodlight
	return 0
}

righttripmine(toolnumber){
	GuiControl,, Debug1, At: righttripmine
	global width
	global height
	if (techlv = 1)
		if (ForcePlace(width*3/4, height/2, toolnumber))
			return 1
	l:=0
	nw(180)
	while (l<5){
		if (ForcePlace(width-1, height/2, toolnumber))
			return 1
		nw(180)
		l++
	}
	sleep, 50
	send, %toolnumber%
	return 0
}
rightlandmine(toolnumber){
	GuiControl,, Debug1, At: rightlandmine
	global width
	global height
	send, %toolnumber%
	l:=0
	
	while (l<3){
		if (ForcePlace(565- 10*l, 431, toolnumber))
			return 1
		nw(200)
		l++
	}
	nw(40)
	if (ForcePlace(539, 430, toolnumber))
		return 1
	return 0
}

ammotocliff(){
	GuiControl,, Debug1, At: ammotocliff
	wd(1100)
	SendInput, {Space down}
	w(1000)
	SendInput, {Space up}
	w(7000)
	SendInput, {Space down}
	w(1000)
	SendInput, {Space up}
	nw(500)
	wheelups(20)
	dllmove(0,-450)
}

firetillmorning(firedelay) {
	GuiControl,, Debug1, At: firetillmorning
	send, 3
	sleep, 100
	send, e
	sleep, 500
	Timer(0)
	if (firedelay = 0)
		Loop {
			if Timer(600)
				return -1
			start := A_TickCount
			while (A_TickCount - start < 1000) {
				click, down
				if MorningFire(firedelay)
					return 1
				click, up
			} 
			failsafe1:=deadcheck(0)
			if (failsafe1<2)
				return failsafe1 
			dllmove(0,5)
		}
	else
		Loop {
			if Timer(600)
				return -1
			fireWithRecovery()  ; fire once
			failsafe1:=deadcheck(0)
			if (failsafe1<2)
				return failsafe1
			start := A_TickCount
			while (A_TickCount - start < firedelay) {
				reload()
				failsafe1:=deadcheck(0)
				if (failsafe1<2)
					return failsafe1
				if MorningFire(firedelay)
					return 1
			}
		}
	return 0
}
MorningFire(firedelay){
    if (sunicon()) {
		graceStart := A_TickCount
		GuiControl,, Debug1, At: MorningFire
        while (A_TickCount - graceStart < 1000) {
			fireWithRecovery()
			start := A_TickCount
			while (A_TickCount - start < firedelay)
            	reload()
        }
        ; one final shot before exiting
		fireWithRecovery()
        sleep, 100
		send, 3
	return 1
    } return 0
}
fireWithRecovery(){
	dllmove(0,DllmoveOffset())
	chickstill()
}
DllmoveOffset() {
    ;GuiControl,, Debug1, At: DllmoveOffset
    global recoverycycle

    recoverycycle++
    if (recoverycycle >= 5) {
        recoverycycle := 0
        return 4
    }
    return 5
}
runWaveBlock(startWave, endWave, fireDelay) {
	global wave, curendwave
	curendwave := endWave
    GuiControl,, Debug1, At: runWaveBlock
    wave := startWave
    while (wave <= endWave) {
		if (wave > startWave){
			if prestige()
				if equipallfunction()
					return 1
			waitforplaybutton(0)
		}
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

prepRefill(ulist, perks := 1) {
	GuiControl,, Debug1, At: prepRefill

	delay := A_TickCount
	if (perks){
		if prestige()
			if equipallfunction()
				return 1
		
		while (A_TickCount - delay < 4500){
			sleep, 1000
			if (deadcheck(0,1) < 0)
				return prepRefill(ulist, 0)
		}
		if (deadcheck(0,1) < 0)
			return prepRefill(ulist, 0)
		
		respawn()
	} else {
		waitformorning(0,1)
	}
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
	;GuiControl,, Debug1, At: refill
	send, %toolnumber% ;m32
	loop, 10{
		sleep, 50
		send, f
		sleep, 10
		if (findpx(683, 682, 683, 682, 0xFF0000) || findpx(683, 682, 683, 682, 0x000000))
			break
	}
	sleep, 300
	send, %toolnumber% ;m32
}

premRefill(ulist, perks := 1) {
	GuiControl,, Debug1, At: premRefill
	delay := A_TickCount
	if (perks){
		if prestige()
			if equipallfunction()
				return 1
		
		while (A_TickCount - delay < 4500){
			sleep, 1000
			if (deadcheck(0,1) < 0)
				return prepRefill(ulist, 0)
		}
		if (deadcheck(0,1) < 0)
			return prepRefill(ulist, 0)
		
		respawn()
	} else {
		waitformorning(0,1)
	}
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
	w(7000)
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
