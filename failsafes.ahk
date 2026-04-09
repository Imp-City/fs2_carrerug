isRobloxClosed() {
    return !WinExist("ahk_exe RobloxPlayerBeta.exe")
}

isShopDeath() {
    global width, height
    return findpx(width/2, height/2, width/2, height/2, 0x000000)
}

isDieScreen() {
    if isShopDeath()
        return (findpx(538, 363, 538, 363, 0xFF0000) && findpx(821, 364, 821, 364, 0xFF0000)) || (findpx(389, 249, 389, 249, 0xFF0000) && findpx(769, 248, 769, 248, 0xFF0000))
}

isDisconnectScreen() {
    ; short-circuit: only check next if previous matched
    if !findpx(684, 308, 686, 310, 0xBDBEBE)
        return 0
    if !findpx(620, 285, 746, 285, 0x393B3D)
        return 0
    if !findpx(620, 285, 746, 285, 0xFFFFFF)
        return 0
    return 1
}

isDeadPOV() {
    return findpx(538, 690, 538, 690, 0x1F1F1F)
        && findpx(529, 681, 530, 682, 0xFFFFFF)
}

isAtAmmoBox() {
    return findpx(699, 696, 700, 697, 0xC0C1C0)
}

isLoseLifeScreen() {
    return isShopDeath()
        && findpx(235, 351, 236, 351, 0xFF0000)
        && findpx(632, 447, 632, 447, 0xFFFFFF)
}

; =========================
; Main checks
; =========================
faultcheck() {
    shopDeath := isShopDeath()
    dieScreen := isDieScreen()
    disconnect := isDisconnectScreen()
    robloxClosed := isRobloxClosed()

    ; for debug display only
    ; dc = disconnect group
    ; gg = death group
    dc1 := disconnect ? 1 : 0
    dc2 := ""
    dc3 := ""
    gg1 := shopDeath ? 1 : 0
    gg2 := dieScreen ? 1 : 0
    gg3 := robloxClosed ? 1 : 0

    updateFaultDebug(dc1, dc2, dc3, gg1, gg2, gg3)

    return (shopDeath && dieScreen) || disconnect || robloxClosed
}

deadcheck(checkammo := 0, killwhended := 0, endofWave := 0) {
    global wave, curendwave

    if faultcheck()
        return -1

    deadPOV := isDeadPOV()
    loseLife := isLoseLifeScreen()
    atAmmo := isAtAmmoBox()

    ; debug flags
    shop := isShopDeath() ? 1 : 0
    lose1 := loseLife ? 1 : 0
    lose2 := ""
    ded1 := deadPOV ? 1 : 0
    ded2 := ""

    updateDeadDebug(shop, lose1, lose2, ded1, ded2, wave, curendwave)

    if (loseLife) {
        if (faultcheck() || killwhended)
            return -1
        if waitformorning(0, 1)
            return -1

        if (wave < 29) {
            prepRefill([[0],[0],[0],[0]], 0)
        } else {
            ulist := [[0],[0],[0],[0],[2],[2],[2],[2],[4],[4],[4],[4],[1,[4,4]],[2],[2,[1,1],[4,1],[5,1]],[4],[4,[1,1],[2,1],[3,1],[4,4]]]
            premRefill(ulist, 0)
        }
        return 0
    }

    if (deadPOV) {
        if (faultcheck() || killwhended)
            return -1
        Timer(0)
        while (true) {
            if sunicon() {
                Sleep, 10000
                break
            }
            if Timer(600)
                return 1
            if (faultcheck())
                return -1

            loseLifeLoop := isLoseLifeScreen()
            shopLoop := isShopDeath() ? 1 : 0
            loseLoop1 := loseLifeLoop ? 1 : 0

            updateDeadDebug(shopLoop, loseLoop1, "", 1, "", wave)

            if (loseLifeLoop) {
                if (faultcheck() || killwhended)
                    return -1
                if waitformorning(0, 1)
                    return -1

                if (wave < 29) {
                    prepRefill([[0],[0],[0],[0]], 0)
                } else {
                    ulist := [[0],[0],[0],[0],[2],[2],[2],[2],[4],[4],[4],[4],[1,[4,4]],[2],[2,[1,1],[4,1],[5,1]],[4],[4,[1,1],[2,1],[3,1],[4,4]]]
                    premRefill(ulist, 0)
                }
                return 0
            }
        }

        if (wave < curendwave) {
            if (wave < 28) {
                prepRefill([[0],[0],[0],[0]], 0)
            } else {
                ulist := [[0],[0],[0],[0],[2],[2],[2],[2],[4],[4],[4],[4]]
                premRefill(ulist, 0)
            }
        }
        return 1
    }

    if (checkammo && atAmmo) {
        if (wave < 29) {
            prepRefill([], 0)
        } else {
            ulist := [[0],[0],[0],[0],[1,[4,1]],[2],[2,[1,1],[4,1],[5,1]],[4],[4,[1,1],[2,1],[3,1],[4,4]]]
            premRefill(ulist)
        }
        return 0
    }

    return 2
}

; ===== RESTARTERS =====
restartroblox(){
    sleep, 2000
    GuiControl,, Debug1, At: restartroblox
    while WinExist("ahk_exe RobloxPlayerBeta.exe"){
        WinKill
        sleep, 500
    } 
    SetTitleMatchMode, 2
    if winExist("The Final Stand 2"){
        loop{
            WinActivate
            mouseclick, WheelUp
            mouseclick, WheelUp
            WinMove, ,, 0, 0, 1366, 768
            sleep, 2000
            chick(995, 441) ;play button
            wheelups(4)
            chick(995, 441)
            sleep, 2000
            l:=0
            while (l<40){ ;20 sec
                if WinExist("ahk_exe RobloxPlayerBeta.exe"){
                    sleep, 500
                    WinActivate
                    sleep, 500
                    GuiControl,, Waiting, Status: Running, Do not perform any actions
                    setfullscreen()
                    WinMove, ahk_exe RobloxPlayerBeta.exe,, 0, 0, 1366, 768
                    return 1
                }
                sleep, 500
                l++
            }
        }
    }
}

Timer(seconds) {
    static start := 0
    static triggered := false

    now := A_TickCount
    global errortimer := floor((now - start)/1000)
    global killtimer := seconds

    ; reset if seconds = 0
    if (seconds = 0) {
        start := now
        triggered := false
        return 0
    }

    ; first call
    if (start = 0) {
        start := now
        return 0
    }

    ; already triggered
    if (triggered)
        return 1

    ; check time
    if ((now - start) >= seconds * 1000) {
        triggered := true
        return 1
    }

    return 0
}