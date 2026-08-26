#Requires AutoHotkey v2.0
#SingleInstance Off
#Warn
#WinActivateForce
#ClipboardTimeout -1
#NoTrayIcon
#Include "..\..\Lib.ahk"
SetWorkingDir(A_ScriptDir "\..\..")
OnError(HandleError)

Dialog_ConvertToExcelFormula()

Dialog_ConvertToExcelFormula()
{
  input := InputBox("Enter a format string.")
  if input.Result == "Cancel"
    return
  if String_IsNullOrWhitespace(input.Value)
  {
    MsgBox("Input is empty.", , 0x30)
    return
  }
  try
    result := ConvertTo_ExcelFormula(input.Value)
  catch as ex
  {
    MsgBox(ex.Message, , 0x30)
    return
  }
  View_Text(result, "txt")
}
