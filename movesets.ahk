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
	global width
	global height
	w(3500) ;12s baseline maxw
	rotate(4,8) ;flip floodlight backwards
	sleep, 100
	place(width/2, 120,8)
	s(4000)
}
knifeonly(){
	i:=1
	SendInput, {v down}
	while (!sunicon()){
		i:=Mod(i+1,4)
		ox:=[-40,0,40,0][i+1], oy:=[0,-40,0,40][i+1]
		chick(ox + A_ScreenWidth/2,oy + A_ScreenHeight/2)
		sleep, 10
	}
	SendInput, {v up}
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
	send, %toolnumber%
	l:=0
	while (l<6){
		chick(width/4, height/2)
		while !waitforplacement(){
			send, %toolnumber%
			sleep, 100
			send, %toolnumber%
			sleep, 100
			chick(width/4, height/2)
		}
		nw(180)
		l++
	} sleep, 50
	send, %toolnumber%
}
leftlandmine(toolnumber){
	global width
	global height
	send, %toolnumber%
	l:=0
	while (l<4){
		chick(742 + 5*l, 422)
		while !waitforplacement(){
			send, %toolnumber%
			sleep, 100
			send, %toolnumber%
			sleep, 100
			chick(750 + 5*l, 422)
		}
		nw(170)
		l++
	} sleep, 50
	send, %toolnumber%
}
setupleftmines(){
	global width
	global height
	na(1200)
	place(width/2, height*3/4,5)
	sleep, 100
	send, 5
	while !waitforplacement(){
		send, 5
		sleep, 100
		send, 5
		sleep, 100
		chick(width/2, height*3/4)
	}
	send, 5
	wheelups(5)
	nw(1100)
	lefttripmine(6)
	nw(600)
	leftlandmine(5)
	wheeldowns(5)
}

setuprightminesandfl(){
	nd(1500)
	wheelups(5)
	nw(1100)
	righttripmine(6)
	nw(300)
	rightlandmine(5)
	wheeldowns(5)
	nw(2000)
	na(800)
	place(A_ScreenWidth/2,A_ScreenHeight*2/5,8) ;floodlight
	send, 8
	while !waitforplacement(){
		send, 8
		sleep, 100
		send, 8
		sleep, 100
		place(A_ScreenWidth/2,A_ScreenHeight*2/5,8) ;floodlight
	} send, 8
	nw(3000)
	place(A_ScreenWidth/2,A_ScreenHeight*2/5,8) ;floodlight
}

righttripmine(toolnumber){
	global width
	global height
	send, %toolnumber%
	chick(width*3/4, height/2)
	while !waitforplacement(){
		send, %toolnumber%
		sleep, 100
		send, %toolnumber%
		sleep, 100
		chick(width*3/4, height/2)
	}
	l:=0
	nw(180)
	while (l<5){
		chick(width-1, height/2)
		if !waitforplacement(){
			send, %toolnumber%
			sleep, 100
			send, %toolnumber%
			continue
		}
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
		chick(565- 10*l, 431)
		if !waitforplacement(){
			send, %toolnumber%
			sleep, 100
			send, %toolnumber%
			continue
		}
		nw(180)
		l++
	} nw(40)
	chick(539, 430)
	while !waitforplacement(){
		send, %toolnumber%
		sleep, 100
		send, %toolnumber%
		sleep, 100
		chick(539, 430)
	}
	send, %toolnumber%
}

refillandcliff(){
	stairtoshop()
	a(800)
	send, 3 ;m32
	sleep, 100
	send, f
	sleep, 250
	send, 3 ;m32
	wd(1100)
	SendInput, {Space down}
	w(1000)
	SendInput, {Space up}
	w(6500)
	SendInput, {Space down}
	w(1000)
	SendInput, {Space up}
	nw(500)
	wheeldowns(10)
	dllmove(0,-450)
}

firetillmorning(firedelay) {
    Loop {
        chickstill()  ; fire once

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
                return
            }
        }
    }
}

runWaveBlock(startWave, endWave, fireDelay) {
    wave := startWave
    while (wave <= endWave) {
        readywithweapon()
        firetillmorning(fireDelay)
        wave++
    }
}

prepRefill() {
    respawn()
	exitspawn(0)
    doortostair()
    readyup()
    refillandcliff()
}