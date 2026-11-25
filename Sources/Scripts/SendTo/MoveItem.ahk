#Requires AutoHotkey v2.0
#SingleInstance Off
#Warn
#WinActivateForce
#ClipboardTimeout -1
#NoTrayIcon
#Include "..\..\Lib.ahk"
SetWorkingDir(A_ScriptDir "\..\..")
OnError(HandleError)

Dialog_MoveItem()

Dialog_MoveItem()
{
  paths := Stream(A_Args).Filter(FileExist).ToArray()
  if paths.Length == 0
    return

  destination := FileSelect("D", A_Desktop, "Move to")
  if destination == ""
    return
  if !FileExist(destination)
    return
  for path In paths
    FileMove(path, destination)
}
