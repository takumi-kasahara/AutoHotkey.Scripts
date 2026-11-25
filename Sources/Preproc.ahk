#Requires AutoHotkey v2.0
#SingleInstance Force
#Warn
#WinActivateForce
#ClipboardTimeout -1
#NoTrayIcon

Preproc()

Preproc()
{
  if FileExist("Lib.ahk")
    FileDelete("Lib.ahk")
  loop files, "Lib\*.ahk", "R"
    FileAppend(Format('#Include "{}"`n', A_LoopFilePath), "Lib.ahk", "`n")
  if FileExist("Modules.ahk")
    FileDelete("Modules.ahk")
  loop files, "Modules\*.ahk", "R"
    FileAppend(Format('#Include "{}"`n', A_LoopFilePath), "Modules.ahk", "`n")
}
