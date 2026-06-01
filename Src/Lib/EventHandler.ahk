#Requires AutoHotkey v2.0

/**
 * @param {Integer} dataType
 */
HandleClipboardChange(dataType)
{
  static delay := Integer(Config_Get("Delay", "CLIP"))
  Sleep(delay)
  suffix := ""
  switch dataType
  {
    case 0:
      return
    default:
      try
        suffix := StrLower(RegExReplace(WinGetProcessName("A"), "\s+"))
      catch as ex
        Log_Error(ex)
      name := Path_Combine(A_Temp, A_Now (suffix == "" ? "" : "." suffix) ".clip")
      FileAppend(ClipboardAll(), name)
      Log_Trace("Saved", name, FileGetSize(name))
  }
  static MAX_FILE_AGE := Integer(Config_Get("Clipboard", "MAX_FILE_AGE"))
  loop files, Path_Combine(A_Temp, "*.clip"), 'F'
    if A_Now - FileGetTime(A_LoopFileFullPath, "C") > MAX_FILE_AGE
      FileRecycle(A_LoopFileFullPath)
}
/**
 * @param {Error} thrown
 * @param {String} mode
 * @returns {Integer}
 */
HandleError(thrown, mode?)
{
  Log_Error(thrown, mode)
  return !State_Debug()
}
/**
 * @param {String} reason
 * @param {Integer} code
 */
HandleExit(reason, code)
{
  Log_Trace(reason, code)
  Log_Flush()
}
