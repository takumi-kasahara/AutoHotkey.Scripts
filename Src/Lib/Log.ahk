#Requires AutoHotkey v2.0

/**
 * @param {String} name
 * @param value
 */
Log_State(name, value?)
{
  static state := Map(
    "Buffer", [],
    "Log", Path_Combine(A_Temp, A_ScriptName "." A_Now ".out.log")
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
  FileAppend(Enumerable_Join(buf), Log_State("Log"))
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
  text := String_Join("`t", messages*)
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
  static log := Path_Combine(A_Temp, A_ScriptName "." A_Now ".err.log")
  text := thrown.Message "`n" thrown.Stack
  if State_Debug()
    OutputDebug(text)
  else if State_ErrorStdOut()
    FileAppend(text "`n", "**")
  else
  {
    FileAppend(ConvertTo_Csv(A_Now, thrown.What, thrown.Message, thrown.Extra, IsSet(mode) ? mode : ""), log)
    Notify_TrayTip(thrown.What "`n" thrown.Message)
  }
}
