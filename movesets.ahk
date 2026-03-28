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
	w(2750)
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
	w(4000) ;12s baseline maxw
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
		chick(width/3, height/2)
		waitforplacement()
		nw(150)
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
		waitforplacement()
		nw(150)
		l++
	} sleep, 50
	send, %toolnumber%
}
setupleftmines(){
	na(1500)
	place(width/2, height*3/4,5)
	sleep, 100
	send, 5
	waitforplacement()
	send, 5
	wheelups(5)
	nw(1200)
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
	nw(600)
	rightlandmine(5)
	wheeldowns(5)
	nw(2000)
	na(800)
	place(A_ScreenWidth/2,A_ScreenHeight*3/5,8) ;floodlight
	nw(3000)
	place(A_ScreenWidth/2,A_ScreenHeight*3/5,8) ;floodlight
}

righttripmine(toolnumber){
	global width
	global height
	send, %toolnumber%
	chick(width*3/4, height/2)
	waitforplacement()
	l:=0
	nw(150)
	while (l<5){
		chick(width-1, height/2)
		waitforplacement()
		nw(150)
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
		chick(575- 9*l, 431)
		waitforplacement()
		nw(150)
		l++
	} nw(50)
	chick(539, 430)
	waitforplacement()
	send, %toolnumber%
}