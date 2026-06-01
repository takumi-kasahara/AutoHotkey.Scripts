#Requires AutoHotkey v2.0

/**
 * @param {String} text
 */
Notification_Show(text)
{
  A_IconHidden := false
  try
    TrayTip(text, A_ScriptName)
  finally
    A_IconHidden := true
}
