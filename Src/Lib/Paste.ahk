#Requires AutoHotkey v2.0

/**
 * @param {String | Array | Func | BoundFunc} input
 */
Paste(input)
{
  static delay := Integer(Config_Get("Delay", "CLIP"))
  value := ConvertTo_String(input)
  if String_IsNullOrWhitespace(value)
    return
  if StrSplit(value, "`n").Length == 1
    value := RegExReplace(value, "(*UCP)^\s+|\s+$")
  backup := ClipboardAll()
  try
  {
    A_Clipboard := value
    Send("+{Insert}")
    Sleep(delay)
  }
  finally
    A_Clipboard := backup
}
