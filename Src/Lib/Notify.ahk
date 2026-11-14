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
