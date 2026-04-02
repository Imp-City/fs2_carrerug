leftsentryw1(){
	wheelups(30)
	wheeldowns(6)
	nw(3500)
}
centerspawn(){
	w(500)
	wd(900)
}
walktoladder(){
	nw(18000)
	na(1500)
}
rightsentry(){
	nd(1500)
	ns(1900)
	na(1200)
	wheelups(30)
	wheeldowns(12)
	sleep, 500
	ForcePlace(176, 284, 4) ;sentry
	wheelups(20)
	wheeldowns(6)
}
walkrightsentrytoshop(){
	nd(3500)
	ns(18100)
	SendInput, {a down}
	ns(4800)
	SendInput, {a up}
}