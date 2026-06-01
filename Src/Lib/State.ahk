#Requires AutoHotkey v2.0

/**
 * @see {@link https://www.autohotkey.com/docs/v2/lib/_HotIf.htm#ExVolume}
 * @param {String} winTitle
 */
State_IsMouseOver(winTitle)
{
  MouseGetPos(, , &window)
  return WinExist(winTitle " ahk_id " window)
}
/**
 * @returns {Integer}
 */
State_IsRemote() => SysGet(4096) ; SM_REMOTESESSION
/**
 * @returns {Integer}
 */
State_IsCaretActive() => CaretGetPos(&x, &y) && !(x == "" && y == "")
/**
 * @returns {Integer}
 */
State_Debug()
{
  static result := Trim(StrReplace(GetCommandLine(), String_Enclose(A_AhkPath))) ~= "i)/Debug"
  return result
}
/**
 * @returns {Integer}
 */
State_ErrorStdOut()
{
  static result := Trim(StrReplace(GetCommandLine(), String_Enclose(A_AhkPath))) ~= "i)/ErrorStdOut"
  return result
}
/**
 * @returns {Integer}
 */
State_AvailableGit()
{
  static result := RunWait("where.exe git.exe /Q") == 0
  return result
}
/**
 * @returns {Integer}
 */
State_AvailableSvn()
{
  static result := RunWait("where.exe svn.exe /Q") == 0
  return result
}
