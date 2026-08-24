#Requires AutoHotkey v2.0
#SingleInstance Force
#Warn
#WinActivateForce
#ClipboardTimeout -1
#NoTrayIcon
#Include "..\Lib.ahk"
OnError(HandleError)
OnExit(HandleExit)

class ConvertTo_Tests extends Test
{
  ConvertTo_ExcelFormula_Empty()
  {
    Assert_AreEqual('=""', ConvertTo_ExcelFormula(""))
  }
  ConvertTo_ExcelFormula_NoPlaceholder()
  {
    Assert_AreEqual('="mv"', ConvertTo_ExcelFormula("mv"))
  }
  ConvertTo_ExcelFormula_ImplicitIndex()
  {
    Assert_AreEqual('="mv "&A1', ConvertTo_ExcelFormula("mv {}"))
  }
  ConvertTo_ExcelFormula_ImplicitIndexes()
  {
    Assert_AreEqual('="mv "&A1&" "&B1', ConvertTo_ExcelFormula("mv {} {}"))
  }
  ConvertTo_ExcelFormula_ExplicitIndex()
  {
    Assert_AreEqual('="mv "&A1', ConvertTo_ExcelFormula("mv {1}"))
  }
  ConvertTo_ExcelFormula_ExplicitIndexes()
  {
    Assert_AreEqual('="echo "&A1&" "&B1', ConvertTo_ExcelFormula("echo {1} {2}"))
    Assert_AreEqual('="echo "&B1&" "&A1', ConvertTo_ExcelFormula("echo {2} {1}"))
  }
}
ConvertTo_Tests()
