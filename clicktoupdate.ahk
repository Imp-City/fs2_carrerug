#NoEnv
#SingleInstance Force
SetWorkingDir %A_ScriptDir%

; =========================
; CONFIG
; =========================
repoOwner := "Imp-City"
repoName  := "fs2_carrerug"
branch    := "main"
mainFile  := "carrerUg.ahk"   ; file to run after updating
selfName  := "clicktoupdate.ahk"

; =========================
; ENTRY
; =========================
continueMode := false
if (A_Args.Length() >= 1 && A_Args[1] = "/continue")
    continueMode := true

if (!continueMode)
{
    if (SelfUpdate(repoOwner, repoName, branch, selfName))
    {
        Run, "%A_ScriptFullPath%" /continue
        ExitApp
    }
}

updatedCount := UpdateAllAhkFiles(repoOwner, repoName, branch, selfName)

mainPath := A_ScriptDir "\" mainFile
if FileExist(mainPath)
{
    Run, "%mainPath%"
    ExitApp
}
else
{
    MsgBox, 48, clicktoupdate, Update finished, but could not find "%mainFile%".
    ExitApp
}

; =========================
; FUNCTIONS
; =========================

SelfUpdate(repoOwner, repoName, branch, selfName)
{
    selfPath := A_ScriptDir "\" selfName
    tempPath := A_Temp "\" selfName ".new"

    rawUrl := "https://raw.githubusercontent.com/" repoOwner "/" repoName "/" branch "/" selfName
    rawUrl := rawUrl "?nocache=" A_TickCount

    if FileExist(tempPath)
        FileDelete, %tempPath%

    URLDownloadToFile, %rawUrl%, %tempPath%
    if ErrorLevel
        return false

    if !FileExist(tempPath)
        return false

    localText := ""
    remoteText := ""

    if FileExist(selfPath)
        FileRead, localText, %selfPath%
    FileRead, remoteText, %tempPath%

    if (remoteText = "")
    {
        FileDelete, %tempPath%
        return false
    }

    if (localText = remoteText)
    {
        FileDelete, %tempPath%
        return false
    }

    backupPath := selfPath ".bak"

    if FileExist(backupPath)
        FileDelete, %backupPath%

    FileMove, %selfPath%, %backupPath%, 1
    FileMove, %tempPath%, %selfPath%, 1

    if ErrorLevel
    {
        ; try to restore old file if replacement failed
        if FileExist(backupPath)
            FileMove, %backupPath%, %selfPath%, 1
        return false
    }

    if FileExist(backupPath)
        FileDelete, %backupPath%

    return true
}

UpdateAllAhkFiles(repoOwner, repoName, branch, selfName)
{
    apiUrl   := "https://api.github.com/repos/" repoOwner "/" repoName "/contents/?ref=" branch
    jsonPath := A_Temp "\repo_contents_" A_TickCount ".json"
    updated  := 0

    if FileExist(jsonPath)
        FileDelete, %jsonPath%

    URLDownloadToFile, %apiUrl%, %jsonPath%
    if ErrorLevel
    {
        MsgBox, 16, clicktoupdate, Failed to fetch repo file list from GitHub.
        return 0
    }

    if !FileExist(jsonPath)
    {
        MsgBox, 16, clicktoupdate, Repo file list was not downloaded.
        return 0
    }

    FileRead, json, %jsonPath%
    FileDelete, %jsonPath%

    ; Parse each object in the root contents list
    pos := 1
    while pos := RegExMatch(json, "\{.*?\}", obj, pos)
    {
        block := obj
        pos += StrLen(obj)

        ; must be a file
        if !RegExMatch(block, """type"":\s*""file""")
            continue

        if !RegExMatch(block, """name"":\s*""([^""]+)""", mName)
            continue
        fileName := mName1

        ; only .ahk files
        if !RegExMatch(fileName, "\.ahk$")
            continue

        ; self already handled above
        if (fileName = selfName)
            continue

        if !RegExMatch(block, """download_url"":\s*""([^""]+)""", mUrl)
            continue
        downloadUrl := mUrl1

        savePath := A_ScriptDir "\" fileName
        finalUrl := downloadUrl "?nocache=" A_TickCount

        URLDownloadToFile, %finalUrl%, %savePath%
        if !ErrorLevel
            updated++
    }

    return updated
}