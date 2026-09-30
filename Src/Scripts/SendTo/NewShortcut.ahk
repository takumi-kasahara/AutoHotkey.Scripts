#Requires AutoHotkey v2.0
#SingleInstance Off
#Warn
#WinActivateForce
#ClipboardTimeout -1
#NoTrayIcon
#Include "..\..\Lib.ahk"
SetWorkingDir(A_ScriptDir "\..\..")
OnError(HandleError)

Dialog_NewShortcut()

Dialog_NewShortcut()
{
  paths := Stream(A_Args).Filter(FileExist).ToArray()
  if paths.Length == 0
    paths := Clipboard_ExtractPath()

  for path In paths
  {
    lnk := FileSelect("S" (0x10 ^ 0x20), Path_Combine(Path_GetParent(path), Path_GetBaseName(path) ".lnk"), "Create Shortcut", "Shortcut (*.lnk)")
    if lnk == ""
      continue
    if !(Path_GetExtensionName(lnk) ~= "^(?i:lnk)$")
      lnk .= ".lnk"
    FileCreateShortcut(path, lnk)
  }
}
