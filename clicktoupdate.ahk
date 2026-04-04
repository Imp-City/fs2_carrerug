files := []

files.Push({url: "https://raw.githubusercontent.com/Imp-City/fs2_carrerug/main/PerkSetup.txt", path: "PerkSetup.txt"})
files.Push({url: "https://raw.githubusercontent.com/Imp-City/fs2_carrerug/main/PrestigeQueueList.txt", path: "PrestigeQueueList.txt"})
files.Push({url: "https://raw.githubusercontent.com/Imp-City/fs2_carrerug/main/carrerUg.ahk", path: "carrerForest.ahk"})
files.Push({url: "https://raw.githubusercontent.com/Imp-City/fs2_carrerug/main/controls.ahk", path: "controls.ahk"})
files.Push({url: "https://raw.githubusercontent.com/Imp-City/fs2_carrerug/main/detections.ahk", path: "detections.ahk"})
files.Push({url: "https://raw.githubusercontent.com/Imp-City/fs2_carrerug/main/exitspawn.ahk", path: "exitspawn.ahk"})
files.Push({url: "https://raw.githubusercontent.com/Imp-City/fs2_carrerug/main/movesets.ahk", path: "movesets.ahk"})
files.Push({url: "https://raw.githubusercontent.com/Imp-City/fs2_carrerug/main/perkgui.ahk", path: "perkgui.ahk"})
files.Push({url: "https://raw.githubusercontent.com/Imp-City/fs2_carrerug/main/perkviewer.ahk", path: "perkviewer.ahk"})
files.Push({url: "https://raw.githubusercontent.com/Imp-City/fs2_carrerug/main/snowball.txt", path: "snowball.txt"})
files.Push({url: "https://raw.githubusercontent.com/Imp-City/fs2_carrerug/main/ugcarrermovesets.ahk", path: "ugcarrermovesets.ahk"})

for _, file in files
{
    url := file.url "?nocache=" A_TickCount
    path := A_ScriptDir "\" file.path

    URLDownloadToFile, %url%, %path%
}

MsgBox, Update complete!
return