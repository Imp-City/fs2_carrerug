sendstatboardattempt(initialmsg){
    global width, height
    Loop , 10{
        chick(834, 682) ; Next pov
        sleep, 200
        if findpx(584, 676, 585, 688, 0xFFFFFF){
            SendWebhookSnip("",initialmsg . " Stat board:", 283, 289, 1082, 479)
            return
        }
    } SendWebhookSnip("",initialmsg . " Failed to find stat board. Current POV:", 0, 0, width, height)
}

webhookheartbeattoggler:
    MsgBox, toggler fired
    global WebhookHeartBeatInterval, heartbeatenabled

    heartbeatenabled := !heartbeatenabled
    if (heartbeatenabled){
        SendWebhookSnipSingleton("", "Status: Started Successfully", 0, 0, 1366, 768, 1)
        SetTimer, webhookheartbeat, % WebhookHeartBeatInterval/10
    }else{
        SendWebhookSnipSingleton("", "Status: Heartbeat Stopped", -1, -1, -1, -1 , 1)
        SetTimer, webhookheartbeat, Off
    }
return

webhookheartbeat:
global WebhookLastCallTick, WebhookHeartBeatInterval

if (!WebhookLastCallTick)
    return

if (A_TickCount - WebhookLastCallTick >= WebhookHeartBeatInterval)
{
    WebhookLastCallTick := A_TickCount
    SendWebhookSnipSingleton("", "Status: Running", 0, 0, 1366, 768, 1, 1)
}
return

SendWebhookSnipSingleton(msg, title, x1 := -1, y1 := -1, x2 := -1, y2 := -1, force := 0, fromHeartbeat := 0)
{
    global webhook
    static lastMsgID := ""
    static lastSendTick := 0
    global WebhookLastCallTick
    WebhookLastCallTick := A_TickCount

    if (webhook = "")
        return 0

    baseWebhook := RegExReplace(webhook, "\?wait=true$")
    sendWebhook := baseWebhook . "?wait=true"

    ; 2 minute rate limit unless forced
    if (!force && lastSendTick && (A_TickCount - lastSendTick < 120000))
        return 0

    ; heartbeat calls do not affect the internal cooldown
    if (!fromHeartbeat)
        lastSendTick := A_TickCount

    file := A_Temp "\screen.png"
    logFile := A_Temp "\discord_log.txt"
    delLogFile := A_Temp "\discord_delete_log.txt"

    FileDelete, %file%
    FileDelete, %logFile%
    FileDelete, %delLogFile%

    ; delete previous message if known
    if (lastMsgID != "")
    {
        delURL := baseWebhook . "/messages/" . lastMsgID
        delCmd := "curl.exe -s -o """ delLogFile """ -X DELETE """ delURL """"
        RunWait, % ComSpec " /c " delCmd,, Hide
        lastMsgID := ""
    }

    if (y2 >= 0)
    {
        if (x2 < x1)
            tmp := x1, x1 := x2, x2 := tmp
        if (y2 < y1)
            tmp := y1, y1 := y2, y2 := tmp

        w := x2 - x1
        h := y2 - y1

        ps := "Add-Type -AssemblyName System.Windows.Forms; Add-Type -AssemblyName System.Drawing; $bmp = New-Object Drawing.Bitmap(" w ", " h "); $g = [Drawing.Graphics]::FromImage($bmp); $g.CopyFromScreen(" x1 "," y1 ",0,0,$bmp.Size); $bmp.Save('" file "', [Drawing.Imaging.ImageFormat]::Png)"
        RunWait, % ComSpec " /c powershell -NoProfile -ExecutionPolicy Bypass -Command """ ps """",, Hide

        if !FileExist(file)
            return 0

        json := "{""content"":""" msg """,""embeds"":[{""title"":""" title """,""color"":5814783,""image"":{""url"":""attachment://screen.png""}}]}"
        jsonEsc := StrReplace(json, """", "\""")
        cmd := "curl.exe -s -o """ logFile """ --form-string ""payload_json=" jsonEsc """ -F ""file1=@" file ";filename=screen.png"" """ sendWebhook """"
    }
    else
    {
        json := "{""content"":""" msg """,""embeds"":[{""title"":""" title """,""color"":5814783}]}"
        jsonEsc := StrReplace(json, """", "\""")
        cmd := "curl.exe -s -o """ logFile """ --form-string ""payload_json=" jsonEsc """ """ sendWebhook """"
    }

    RunWait, % ComSpec " /c " cmd,, Hide

    FileRead, resp, %logFile%
    if !ErrorLevel
    {
        RegExMatch(resp, """id"":""(\d+)""", m)
        if (m1 != "")
        {
            lastMsgID := m1
            return lastMsgID
        }
    }

    return 0
}

SendWebhookSnip(msg, title, x1 := -1, y1 := -1, x2 := -1, y2 := -1)
{
    ;msgbox, snipping
    global webhook
    if (webhook = "")
        return 0
    file := A_Temp "\screen.png"
    logFile := A_Temp "\discord_log.txt"

    FileDelete, %file%
    FileDelete, %logFile%

    if (y2 >= 0)
    {
        if (x2 < x1)
            tmp := x1, x1 := x2, x2 := tmp
        if (y2 < y1)
            tmp := y1, y1 := y2, y2 := tmp

        w := x2 - x1
        h := y2 - y1

        ps := "Add-Type -AssemblyName System.Windows.Forms; Add-Type -AssemblyName System.Drawing; $bmp = New-Object Drawing.Bitmap(" w ", " h "); $g = [Drawing.Graphics]::FromImage($bmp); $g.CopyFromScreen(" x1 "," y1 ",0,0,$bmp.Size); $bmp.Save('" file "', [Drawing.Imaging.ImageFormat]::Png)"
        RunWait, % ComSpec " /c powershell -NoProfile -ExecutionPolicy Bypass -Command """ ps """",, Hide

        if !FileExist(file)
        {
            ;MsgBox, 16, Error, Screenshot file was not created.
            return
        }

        json := "{""content"":""" msg """,""embeds"":[{""title"":""" title """,""color"":5814783,""image"":{""url"":""attachment://screen.png""}}]}"
        jsonEsc := StrReplace(json, """", "\""")
        cmd := "curl.exe -i --form-string ""payload_json=" jsonEsc """ -F ""file1=@" file ";filename=screen.png"" """ webhook """ > """ logFile """ 2>&1"
    }
    else
    {
        json := "{""content"":""" msg """,""embeds"":[{""title"":""" title """,""color"":5814783}]}"
        jsonEsc := StrReplace(json, """", "\""")
        cmd := "curl.exe -i --form-string ""payload_json=" jsonEsc """ """ webhook """ > """ logFile """ 2>&1"
    }

    RunWait, % ComSpec " /c " cmd,, Hide
    ;Run, %logFile%
}