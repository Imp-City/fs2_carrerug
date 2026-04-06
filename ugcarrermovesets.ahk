prepflw3(){
	GuiControl,, Debug1, At: prepflw3
	wheelups(20)
	wheeldowns(20)
	nw(3500)
}
centerspawn(){
	GuiControl,, Debug1, At: centerspawn
	w(500)
	wd(900)
}
walktoladder(){
	GuiControl,, Debug1, At: walktoladder
	nw(18000)
	na(1500)
	sleep, 500
	PixelSearch, x, y, 633, 682, 732, 683, 0xFFFFFF, 0, Fast RGB
	return !boolean(x)
}
rightsentry(){
	GuiControl,, Debug1, At: rightsentry
	send, {w down}
	nd(2600)
	send, {w up}
	nw(3100)
	ns(1600)
	nd(400)
	wheelups(20)
	wheeldowns(9)
}

rightsentrythenladder(){
	GuiControl,, Debug1, At: rightsentrythenladder
	ForcePlace(858, 316, 4, 0, 50) ;sentry
	wheelups(20)
	wheeldowns(6)
	send, {s down} {a down}
	start := A_TickCount
	Loop {
		PixelSearch, x, y, 633, 682, 732, 683, 0xFFFFFF, 0, Fast RGB
		if (ErrorLevel = 0){ ; found
			send, {s up} {a up}
			return 0
		}  
			
		if (A_TickCount - start >= 10000){ ;10 seconds
			send, {s up} {a up}
			return 1
		}  
	}
}
walkspawntoshop(){
	GuiControl,, Debug1, At: walkspawntoshop
	nd(750)
	send, {s down}
	nd(3800)
	sleep, 22700
	send, {s up}
	SendInput, {a down}
	ns(4800)
	SendInput, {a up}
}
