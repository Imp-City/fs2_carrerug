2GuiClose:
Gui, 2:Destroy
return

ShowFileViewer(filePath, title, mode){
	global viewerFile
	global viewerMode
	global viewerTitle

	viewerFile := filePath
	viewerMode := mode
	viewerTitle := title

	Gui, 2:Destroy
	Gui, 2:Default
	Gui, 2:Color, 0x52fadb
	Gui, 2:+AlwaysOnTop
	if (mode = "queue")
		Gui, Add, ListView, hwndFileViewerLV x0 y0 w300 h200 Grid -Multi, #|Perk Name|Col|Color
	else
		Gui, Add, ListView, hwndFileViewerLV x0 y0 w300 h200 Grid -Multi, #|Perk Name|Col|Color|Slot

	rowCount := 0
	if FileExist(filePath){
		Loop, Read, %filePath%
		{
			line := Trim(A_LoopReadLine, "`r`n ")
			if (line = "")
				continue

			parts := StrSplit(line, "|")
			perkName := parts[1]
			columnDisplay := parts[2] + 1
			colorDisplay := ColorName(parts[3])

			if (mode = "queue"){
				LV_Add("", rowCount + 1, perkName, columnDisplay, colorDisplay)
			} else {
				slotDisplay := parts[4] + 1
				LV_Add("", rowCount + 1, perkName, columnDisplay, colorDisplay, slotDisplay)
			}
			rowCount++
		}
	}

	LV_ModifyCol(1, 20)
	LV_ModifyCol(2, 120)
	LV_ModifyCol(3, 40)
	LV_ModifyCol(4, 40)
	if (mode != "queue")
		LV_ModifyCol(5, 40)

	; Set ListView colors: white text on dark gray background.
	SendMessage, 0x1024, 0, 0xFFFFFF,, ahk_id %FileViewerLV%
	SendMessage, 0x1026, 0, 0x303030,, ahk_id %FileViewerLV%
	SendMessage, 0x1001, 0, 0x303030,, ahk_id %FileViewerLV%

	status := rowCount ? "Rows: " rowCount : "File Empty"
	Gui, Add, Text, x10 y210 w100, %status%
	Gui, Add, Button, x110 y203 w70 gviewrefresh, Refresh
	Gui, Add, Button, x190 y203 w100 gclearviewfile, Clear All
	Gui, Add, Button, x10 y227 w70 gmoveviewerup, Move Up
	Gui, Add, Button, x85 y227 w80 gmoveviewerdown, Move Down
	Gui, Add, Button, x170 y227 w120 gdeleteviewerrow, Delete Selected
	Gui, Show, x1030 y86 w300 h250, %title%
}

viewrefresh:
ShowFileViewer(viewerFile, viewerTitle, viewerMode)
return

moveviewerup:
MoveViewerRow(viewerFile, viewerTitle, viewerMode, -1)
return

moveviewerdown:
MoveViewerRow(viewerFile, viewerTitle, viewerMode, 1)
return

deleteviewerrow:
DeleteViewerRow(viewerFile, viewerTitle, viewerMode)
return

clearviewfile:
ClearViewerFile(viewerFile, viewerTitle, viewerMode)
return

ColorName(colorIndex){
	if (colorIndex = 0)
		return "Red"
	if (colorIndex = 1)
		return "Blue"
	if (colorIndex = 2)
		return "Green"
	if (colorIndex = 3)
		return "Yellow"
	if (colorIndex = 4)
		return "Purple"
	return colorIndex
}

DeleteViewerRow(filePath, title, mode){
	Gui, 2:Default
	selectedRow := LV_GetNext()
	if (!selectedRow){
		MsgBox, 48, Viewer, Select a row to delete first.
		return
	}

	if !FileExist(filePath){
		MsgBox, 48, Viewer, The source file does not exist.
		return
	}

	newContent := ""
	visibleRow := 0
	Loop, Read, %filePath%
	{
		line := Trim(A_LoopReadLine, "`r`n ")
		if (line = "")
			continue

		visibleRow++
		if (visibleRow = selectedRow)
			continue
		
		newContent .= A_LoopReadLine
		if (newContent != "")
			newContent .= "`n"
	}
	FileDelete, %filePath%
	FileAppend, %newContent%, %filePath%
	ShowFileViewer(filePath, title, mode)
}

ClearViewerFile(filePath, title, mode){
	MsgBox, 4, Confirm Clear, Clear all rows from this file?
	IfMsgBox, No
		return

	FileDelete, %filePath%
	FileAppend,, %filePath%
	ShowFileViewer(filePath, title, mode)
}

MoveViewerRow(filePath, title, mode, direction){
	Gui, 2:Default
	selectedRow := LV_GetNext()
	if (!selectedRow){
		MsgBox, 48, Viewer, Select a row to move first.
		return
	}

	if !FileExist(filePath){
		MsgBox, 48, Viewer, The source file does not exist.
		return
	}

	lines := []
	Loop, Read, %filePath%
	{
		line := Trim(A_LoopReadLine, "`r`n ")
		if (line = "")
			continue
		lines.Push(A_LoopReadLine)
	}

	rowCount := lines.Length()
	targetRow := selectedRow + direction
	if (targetRow < 1 or targetRow > rowCount){
		MsgBox, 48, Viewer, Out of Range.
		return
	}
		

	selectedLine := lines[selectedRow]
	lines.RemoveAt(selectedRow)
	lines.InsertAt(targetRow, selectedLine)

	newContent := ""
	for index, line in lines
	{
		newContent .= line
		if (newContent != "")
			newContent .= "`n"
	}

	FileDelete, %filePath%
	FileAppend, %newContent%, %filePath%
	ShowFileViewer(filePath, title, mode)
	LV_Modify(targetRow, "Select Focus Vis")
}
