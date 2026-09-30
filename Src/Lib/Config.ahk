#Requires AutoHotkey v2.0

/**
 * @param {String} section
 * @param {String} key
 * @param {String} [default]
 */
Config_Get(section, key, default?)
{
  static config := Path_Combine(A_WorkingDir, "Config.ini")
  if IsSet(default)
    return IniRead(config, section, key, default)
  return IniRead(config, section, key)
}

CoordMode("Caret")
CoordMode("Menu")
CoordMode("Mouse")
CoordMode("Pixel")
CoordMode("ToolTip")

GroupAdd("grpConsole", "ahk_exe bash.exe")
GroupAdd("grpConsole", "ahk_exe mintty.exe")
GroupAdd("grpConsole", "ahk_exe powershell.exe")
GroupAdd("grpConsole", "ahk_exe pwsh.exe")
GroupAdd("grpConsole", "ahk_exe wt.exe")

GroupAdd("grpExplorer", "ahk_class #32770") ; OpenFileDialog
GroupAdd("grpExplorer", "ahk_class CabinetWClass") ; Explorer
GroupAdd("grpExplorer", "ahk_class Progman") ; Desktop
GroupAdd("grpExplorer", "ahk_exe 7zFM.exe")
GroupAdd("grpExplorer", "ahk_exe Everything.exe")
GroupAdd("grpExplorer", "ahk_exe Files.exe")

GroupAdd("grpEditor", "ahk_exe Code.exe")
GroupAdd("grpEditor", "ahk_exe Code - Insiders.exe")
GroupAdd("grpEditor", "ahk_exe devenv.exe")
GroupAdd("grpEditor", "ahk_exe SSMS.exe")
GroupAdd("grpEditor", "ahk_exe Notepad.exe")
GroupAdd("grpEditor", "ahk_exe notepad++.exe")
GroupAdd("grpEditor", "ahk_exe WinMergeU.exe")

GroupAdd("grpF1Disabled", "ahk_class CabinetWClass") ; Explorer
GroupAdd("grpF1Disabled", "ahk_class Progman") ; Desktop
GroupAdd("grpF1Disabled", "ahk_exe AstroGrep.exe")
GroupAdd("grpF1Disabled", "ahk_exe Everything.exe")
GroupAdd("grpF1Disabled", "ahk_exe EXCEL.EXE")
GroupAdd("grpF1Disabled", "ahk_exe Files.exe")
GroupAdd("grpF1Disabled", "ahk_exe ms-teams.exe")
GroupAdd("grpF1Disabled", "ahk_exe MSACCESS.EXE")
GroupAdd("grpF1Disabled", "ahk_exe msedge.exe")
GroupAdd("grpF1Disabled", "ahk_exe MSPUB.EXE")
GroupAdd("grpF1Disabled", "ahk_exe Notepad.exe")
GroupAdd("grpF1Disabled", "ahk_exe ONENOTE.EXE")
GroupAdd("grpF1Disabled", "ahk_exe OUTLOOK.EXE")
GroupAdd("grpF1Disabled", "ahk_exe POWERPNT.EXE")
GroupAdd("grpF1Disabled", "ahk_exe WinMergeU.exe")
GroupAdd("grpF1Disabled", "ahk_exe WINWORD.EXE")
