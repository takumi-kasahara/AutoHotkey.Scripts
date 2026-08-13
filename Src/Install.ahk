#Requires AutoHotkey v2.0
#SingleInstance Force
#Warn
#WinActivateForce
#ClipboardTimeout -1
#NoTrayIcon
#Include "Lib.ahk"
SetWorkingDir(A_ScriptDir)

Install()

/**
 * Installs AutoHotkey scripts and settings based on the configuration.
 */
Install()
{
  switch Config_Get("Install", "Startup")
  {
    case "Folder":
      lnk := Path_Combine(A_Startup, "AutoHotkey.lnk")
      args := String_Enclose(Path_Combine(A_ScriptDir, "Run.ahk"))
      if FileExist(lnk)
        FileDelete(lnk)
      FileCreateShortcut(A_AhkPath, lnk, , args)
    case "Registry":
      key := "HKCU\Software\Microsoft\Windows\CurrentVersion\Run"
      value := "AutoHotkey"
      script := Path_Combine(A_ScriptDir, "Run.ahk")
      command := Format('"{}" "{}"', A_AhkPath, script)
      RegWrite(command, "REG_SZ", key, value)
  }

  RegWrite(Config_Get("Install", "EnableHexNumpad"), "REG_SZ", "HKCU\Control Panel\Input Method", "EnableHexNumpad")
  RegWrite(Config_Get("Install", "DisabledHotkeys"), "REG_SZ", "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "DisabledHotkeys")
  ; https://learn.microsoft.com/en-us/windows/win32/inputdev/wm-appcommand
  app1 := Config_Get("Install", "Launch_App1")
  app1Key := "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AppKey\17"
  if RegRead(app1Key, "ShellExecute", "")
    RegCreateKey(app1Key)
  if app1 != ""
    RegWrite(app1, "REG_SZ", app1Key, "ShellExecute")
  else
    RegDelete(app1Key, "ShellExecute")
  app2 := Config_Get("Install", "Launch_App2")
  app2Key := "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AppKey\18"
  if RegRead(app2Key, "ShellExecute", "")
    RegCreateKey(app2Key)
  if app2 != ""
    RegWrite(app2, "REG_SZ", app2Key, "ShellExecute")
  else if app2 == ""
    RegDelete(app2Key, "ShellExecute")

  sendTo := Reg_FolderDescriptions("SendTo")
  loop files, "Scripts\SendTo\*.ahk", "F"
  {
    lnk := Path_Combine(sendTo, Path_GetName(A_LoopFileFullPath) ".lnk")
    args := String_Enclose(A_LoopFileFullPath)
    if FileExist(lnk)
      FileDelete(lnk)
    FileCreateShortcut(A_AhkPath, lnk, , args)
  }

  startMenu := Path_Combine(Reg_FolderDescriptions("Programs"), ".Local\AutoHotkey")
  if !DirExist(startMenu)
    DirCreate(startMenu)
  else
    loop files, Path_Combine(startMenu, "*.lnk"), "F"
      FileDelete(A_LoopFileFullPath)
  loop files, "Scripts\Programs\*.ahk", "F"
  {
    lnk := Path_Combine(startMenu, Path_GetName(A_LoopFileFullPath) ".lnk")
    args := String_Enclose(A_LoopFileFullPath)
    if FileExist(lnk)
      FileDelete(lnk)
    FileCreateShortcut(A_AhkPath, lnk, , args)
  }
}
