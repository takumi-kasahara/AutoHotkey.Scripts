#Requires AutoHotkey v2.0

/**
 * @param {String} name
 * @param value
 */
Log_State(name, value?)
{
  static state := Map(
    "Buffer", [],
    "StdOut", Path_Combine(A_Temp, Path_GetBaseName(A_AhkPath) "." Path_GetBaseName(A_ScriptFullPath) "." A_Now ".out.log"),
    "StdErr", Path_Combine(A_Temp, Path_GetBaseName(A_AhkPath) "." Path_GetBaseName(A_ScriptFullPath) "." A_Now ".err.log"),
  )
  if IsSet(value)
    state.Set(name, value)
  return state.Get(name)
}
Log_Flush()
{
  buf := Log_State("Buffer")
  if buf.Length == 0
    return
  static stdout := Log_State("StdOut")
  text := Enumerable_Join(buf)
  FileAppend(text "`n", stdout, "`n")
  Log_State("Buffer", [])
}
/**
 * @param {String*} messages
 */
Log_Trace(messages*)
{
  static MAX_BUFFER_COUNT := Config_Get("Log", "MAX_BUFFER_COUNT")
  if messages.Length == 0
    return
  text := String_Join(" ", messages*)
  if State_Debug()
    OutputDebug(text)
  else if State_ErrorStdOut()
    FileAppend(text "`n", "*")
  else
  {
    buf := Log_State("Buffer")
    buf.Push(ConvertTo_Csv(A_Now, messages*))
    if buf.Length >= MAX_BUFFER_COUNT
      Log_Flush()
  }
}
/**
 * @param {Error} thrown
 * @param {String} mode
 */
Log_Error(thrown, mode?)
{
  Log_Flush()
  text := thrown.Message "`n" thrown.Stack
  if State_Debug()
    OutputDebug(text)
  else if State_ErrorStdOut()
    FileAppend(text "`n", "**")
  else
  {
    static stdout := Log_State("StdOut")
    static stderr := Log_State("StdErr")
    text := ConvertTo_Csv(A_Now, thrown.What, thrown.Message, thrown.Extra, IsSet(mode) ? mode : "")
    FileAppend(text "`n", stderr, "`n")
    static EDITOR := Config_Get("Path", "EDITOR", "{}")
    if FileExist(stdout)
      Open(EDITOR, stdout)
    if FileExist(stderr)
      Open(EDITOR, stderr)
  }
}
