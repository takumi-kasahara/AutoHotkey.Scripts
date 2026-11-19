#Requires AutoHotkey v2.0
#SingleInstance Off
#Warn
#WinActivateForce
#ClipboardTimeout -1
#NoTrayIcon
#Include "..\..\Lib.ahk"
SetWorkingDir(A_ScriptDir "\..\..")
OnError(HandleError)

Dialog_CopyItem()

Dialog_CopyItem()
{
  paths := Stream(A_Args).Filter(FileExist).ToArray()
  if paths.Length == 0
    return

  destination := FileSelect("D", A_Desktop, "Copy to")
  if destination == ""
    return
  if !FileExist(destination)
    return
  for path In paths
    if Path_IsDirectory(path)
      DirCopy(path, destination)
    else
      FileCopy(path, destination)
}
