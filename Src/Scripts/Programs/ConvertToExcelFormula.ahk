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
  prompt := "Enter a format string."
  loop
  {
    input := InputBox(prompt)
    if input.Result == "Cancel"
      return
    if String_IsNullOrWhitespace(input.Value)
    {
      prompt := "Input is empty."
      continue
    }
    try
    {
      result := ConvertTo_ExcelFormula(input.Value)
      View_Text(result, "txt")
      return
    }
    catch as ex
    {
      prompt := ex.Message
      continue
    }
  }
}
