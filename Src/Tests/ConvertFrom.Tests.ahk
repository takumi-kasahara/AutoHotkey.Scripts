#Requires AutoHotkey v2.0
#SingleInstance Force
#Warn
#WinActivateForce
#ClipboardTimeout -1
#NoTrayIcon
#Include "..\Lib.ahk"
OnError(HandleError)
OnExit(HandleExit)

class ConvertFrom_Tests extends Test
{
  ConvertFrom_Json_SimpleString()
  {
    Assert_AreEqual("hello", ConvertFrom_Json("hello"))
  }
  ConvertFrom_Json_WithBackslash()
  {
    Assert_AreEqual("a\b", ConvertFrom_Json("a\\b"))
  }
  ConvertFrom_Json_WithMultipleBackslashes()
  {
    Assert_AreEqual("a\\b", ConvertFrom_Json("a\\\\b"))
  }
  ConvertFrom_Json_EmptyString()
  {
    Assert_AreEqual("", ConvertFrom_Json(""))
  }
  ConvertFrom_SQL_SimpleString()
  {
    Assert_AreEqual("hello", ConvertFrom_SQL("hello"))
  }
  ConvertFrom_SQL_WithSingleQuotes()
  {
    Assert_AreEqual("it's", ConvertFrom_SQL("it''s"))
  }
  ConvertFrom_SQL_WithMultipleSingleQuotes()
  {
    Assert_AreEqual("''hello''", ConvertFrom_SQL("''''hello''''"))
  }
  ConvertFrom_SQL_EmptyString()
  {
    Assert_AreEqual("", ConvertFrom_SQL(""))
  }
  ConvertFrom_PowerShell_SimpleString()
  {
    Assert_AreEqual("hello", ConvertFrom_PowerShell("hello"))
  }
  ConvertFrom_PowerShell_WithBackticks()
  {
    Assert_AreEqual("a`b", ConvertFrom_PowerShell("a``b"))
  }
  ConvertFrom_PowerShell_WithQuotes()
  {
    Assert_AreEqual('a"b', ConvertFrom_PowerShell('a`"b'))
  }
  ConvertFrom_PowerShell_EmptyString()
  {
    Assert_AreEqual("", ConvertFrom_PowerShell(""))
  }
  ConvertFrom_VisualBasic_SimpleString()
  {
    Assert_AreEqual("hello", ConvertFrom_VisualBasic("hello"))
  }
  ConvertFrom_VisualBasic_WithQuotes()
  {
    Assert_AreEqual('a"b', ConvertFrom_VisualBasic('a""b'))
  }
  ConvertFrom_VisualBasic_WithMultipleQuotes()
  {
    Assert_AreEqual('"hello"', ConvertFrom_VisualBasic('""hello""'))
  }
  ConvertFrom_VisualBasic_EmptyString()
  {
    Assert_AreEqual("", ConvertFrom_VisualBasic(""))
  }
}
