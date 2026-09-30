#Requires AutoHotkey v2.0
#SingleInstance Force
#Warn
#WinActivateForce
#ClipboardTimeout -1
#NoTrayIcon

Build()

Build()
{
  if FileExist("Lib.ahk")
    FileDelete("Lib.ahk")
  loop files, "Lib\*.ahk", "R"
    FileAppend(Format('#Include "{}"`r`n', A_LoopFilePath), "Lib.ahk", "UTF-8")
  if FileExist("Modules.ahk")
    FileDelete("Modules.ahk")
  loop files, "Modules\*.ahk", "R"
    FileAppend(Format('#Include "{}"`r`n', A_LoopFilePath), "Modules.ahk", "UTF-8")
}
