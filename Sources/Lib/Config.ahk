#Requires AutoHotkey v2.0

Config_Init()

Config_Init()
{
  CoordMode("Caret")
  CoordMode("Menu")
  CoordMode("Mouse")
  CoordMode("Pixel")
  CoordMode("ToolTip")

  for title in [
    "ahk_class ConsoleWindowClass",
    "ahk_exe mintty.exe",
    "ahk_exe WindowsTerminal.exe"]
    GroupAdd("grp_console", title)

  for title in [
    "ahk_class #32770",
    "ahk_class CabinetWClass",
    "ahk_class Progman",
    "ahk_exe 7zFM.exe",
    "ahk_exe Everything.exe",
    "ahk_exe Files.exe"]
    GroupAdd("grp_explorer", title)

  for title in [
    "ahk_exe Code.exe",
    "ahk_exe Code - Insiders.exe",
    "ahk_exe devenv.exe",
    "ahk_exe SSMS.exe",
    "ahk_exe Notepad.exe",
    "ahk_exe notepad++.exe",
    "ahk_exe WinMergeU.exe"]
    GroupAdd("grp_editor", title)
}
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
