#Requires AutoHotkey v2.0

/**
 * @param {String} text
 * @param {Integer} [x]
 * @param {Integer} [y]
 */
Notify_ToolTip(text := "", x := unset, y := unset)
{
  if text == ""
    ToolTip()
  else if State_Debug()
    Log_Trace(text)
  else if State_ErrorStdOut()
    Log_Trace(text)
  else if IsSet(x) && IsSet(y)
    ToolTip(text, x, y)
  else
    ToolTip(text)
}
/**
 * @param {String} text
 */
Notify_TrayTip(text)
{
  A_IconHidden := false
  try
  {
    if text == ""
      return
    if State_Debug()
      Log_Trace(text)
    else if State_ErrorStdOut()
      Log_Trace(text)
    else
      TrayTip(text, A_ScriptName)
  }
  finally
    A_IconHidden := true
}
