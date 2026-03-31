leftsentryw1(){
	w(400)
	wa(900)
	SendInput, {Space down}
	wa(400)
	SendInput, {Space up}
	sleep, 500
}
walktocenter(){
	nw(2000)
	nd(3500)
}
walktoladder(){
	nw(18000)
	na(1500)
}
rightsentry(){
	nd(2200)
	ns(800)
}
walkrightsentrytoshop(){
	nd(1500)
	ns(19200)
	SendInput, {a down}
	ns(4800)
	SendInput, {a up}
}