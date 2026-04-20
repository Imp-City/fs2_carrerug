sendstatboardattempt(initialmsg){
    global width, height, statClient
    Loop , 10{
        wheeldowns(1)
        chick(834, 682) ; Next pov
        sleep, 200
        if findpx(584, 676, 585, 688, 0xFFFFFF){
            statClient.Send("",initialmsg . " Stat board:", 283, 289, 1082, 479)
            return
        }
    } statClient.Send("",initialmsg . " Failed to find stat board. Current POV:", 0, 0, width, height)
}

class WebhookSnipClient
{
    cooldownMs := 120000

    __New(webhookUrl, cooldownSeconds:= 120)
    {
        this.webhook := webhookUrl
        this.lastMsgID := ""
        this.lastSendTick := 0
        this.lastCallTick := 0
        this.cooldownMs := cooldownSeconds*1000
    }

    Send(msg, title, x1 := -1, y1 := -1, x2 := -1, y2 := -1, force := 0)
    {
        if (this.webhook = "")
            return 0

        this.lastCallTick := A_TickCount

        baseWebhook := RegExReplace(this.webhook, "\?wait=true$")
        sendWebhook := baseWebhook . "?wait=true"

        ; cooldown unless forced
        if (!force && this.lastSendTick && (A_TickCount - this.lastSendTick < this.cooldownMs))
            return 0

        this.lastSendTick := A_TickCount

        file := A_Temp "\screen_" . A_TickCount . ".png"
        logFile := A_Temp "\discord_log_" . A_TickCount . ".txt"
        delLogFile := A_Temp "\discord_delete_log_" . A_TickCount . ".txt"

        FileDelete, %file%
        FileDelete, %logFile%
        FileDelete, %delLogFile%

        ; delete previous message for this object only
        if (this.lastMsgID != "")
        {
            delURL := baseWebhook . "/messages/" . this.lastMsgID
            delCmd := "curl.exe -s -o """ delLogFile """ -X DELETE """ delURL """"
            RunWait, % ComSpec " /c " delCmd,, Hide
            this.lastMsgID := ""
        }

        if (y2 >= 0)
        {
            if (x2 < x1)
                tmp := x1, x1 := x2, x2 := tmp
            if (y2 < y1)
                tmp := y1, y1 := y2, y2 := tmp

            w := x2 - x1
            h := y2 - y1

            ps := "Add-Type -AssemblyName System.Windows.Forms; "
                . "Add-Type -AssemblyName System.Drawing; "
                . "$bmp = New-Object Drawing.Bitmap(" w ", " h "); "
                . "$g = [Drawing.Graphics]::FromImage($bmp); "
                . "$g.CopyFromScreen(" x1 "," y1 ",0,0,$bmp.Size); "
                . "$bmp.Save('" file "', [Drawing.Imaging.ImageFormat]::Png)"

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
                this.lastMsgID := m1
                return m1
            }
        }

        return 0
    }
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