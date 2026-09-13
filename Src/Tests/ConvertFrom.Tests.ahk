#Requires AutoHotkey v2.0
#SingleInstance Force
#Warn
#WinActivateForce
#ClipboardTimeout -1
#NoTrayIcon
#Include "..\Lib.ahk"
SetWorkingDir(A_ScriptDir "\..")
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
  ConvertFrom_Json_WithNewline()
  {
    Assert_AreEqual("a`nb", ConvertFrom_Json("a\nb"))
  }
  ConvertFrom_Json_WithTab()
  {
    Assert_AreEqual("a`tb", ConvertFrom_Json("a\tb"))
  }
  ConvertFrom_Json_WithQuote()
  {
    Assert_AreEqual('a"b', ConvertFrom_Json('a\"b'))
  }
  ConvertFrom_Json_RoundTrip()
  {
    original := "hello`nworld`ttab`"quote"
    Assert_AreEqual(original, ConvertFrom_Json(ConvertTo_Json(original)))
  }
  ConvertFrom_Json_WithEnclosure()
  {
    Assert_AreEqual("hello", ConvertFrom_Json('"hello"'))
  }
  ConvertFrom_Json_ComplexString()
  {
    Assert_AreEqual("line1`nline2`ttab`"quote", ConvertFrom_Json('line1\nline2\ttab\"quote'))
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
  ConvertFrom_SQL_WithNewline()
  {
    Assert_AreEqual("a`nb", ConvertFrom_SQL("'a' || CHR(10) || 'b'"))
  }
  ConvertFrom_SQL_WithTab()
  {
    Assert_AreEqual("a`tb", ConvertFrom_SQL("'a' || CHR(9) || 'b'"))
  }
  ConvertFrom_SQL_RoundTrip()
  {
    original := "hello`nworld`ttab'quote"
    Assert_AreEqual(original, ConvertFrom_SQL(ConvertTo_SQL(original)))
  }
  ConvertFrom_SQL_WithEnclosure()
  {
    Assert_AreEqual("hello", ConvertFrom_SQL("'hello'"))
  }
  ConvertFrom_SQL_ComplexString()
  {
    Assert_AreEqual("line1`nline2`ttab'quote", ConvertFrom_SQL("'line1' || CHR(10) || 'line2' || CHR(9) || 'tab''quote'"))
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
  ConvertFrom_PowerShell_WithDollar()
  {
    Assert_AreEqual("$var", ConvertFrom_PowerShell("``$var"))
  }
  ConvertFrom_PowerShell_WithBraces()
  {
    Assert_AreEqual("{path}", ConvertFrom_PowerShell("``{path``}"))
  }
  ConvertFrom_PowerShell_WithNewline()
  {
    Assert_AreEqual("a`nb", ConvertFrom_PowerShell("a``nb"))
  }
  ConvertFrom_PowerShell_WithTab()
  {
    Assert_AreEqual("a`tb", ConvertFrom_PowerShell("a``tb"))
  }
  ConvertFrom_PowerShell_RoundTrip()
  {
    original := "hello`nworld`ttab`$var`{path}`"quote"
    Assert_AreEqual(original, ConvertFrom_PowerShell(ConvertTo_PowerShell(original)))
  }
  ConvertFrom_PowerShell_WithEnclosure()
  {
    Assert_AreEqual("hello", ConvertFrom_PowerShell('"hello"'))
  }
  ConvertFrom_PowerShell_ComplexString()
  {
    Assert_AreEqual("line1`nline2`ttab`$var`{path}`"quote", ConvertFrom_PowerShell('"line1``nline2``ttab``$var``{path}``"quote"'))
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
  ConvertFrom_VisualBasic_WithNewline()
  {
    Assert_AreEqual("a`nb", ConvertFrom_VisualBasic('"a" & vbNewLine & "b"'))
  }
  ConvertFrom_VisualBasic_WithTab()
  {
    Assert_AreEqual("a`tb", ConvertFrom_VisualBasic('"a" & vbTab & "b"'))
  }
  ConvertFrom_VisualBasic_RoundTrip()
  {
    original := "hello`nworld`ttab`"quote"
    Assert_AreEqual(original, ConvertFrom_VisualBasic(ConvertTo_VisualBasic(original)))
  }
  ConvertFrom_VisualBasic_WithEnclosure()
  {
    Assert_AreEqual("hello", ConvertFrom_VisualBasic('"hello"'))
  }
  ConvertFrom_VisualBasic_ComplexString()
  {
    Assert_AreEqual("line1`nline2`ttab`"quote", ConvertFrom_VisualBasic('"line1" & vbNewLine & "line2" & vbTab & "tab""quote"'))
  }
  ConvertFrom_Excel_SimpleString()
  {
    Assert_AreEqual("hello", ConvertFrom_Excel("hello"))
  }
  ConvertFrom_Excel_WithQuotes()
  {
    Assert_AreEqual('a"b', ConvertFrom_Excel('a""b'))
  }
  ConvertFrom_Excel_WithNewline()
  {
    Assert_AreEqual("a`nb", ConvertFrom_Excel('"a" & CHAR(10) & "b"'))
  }
  ConvertFrom_Excel_WithTab()
  {
    Assert_AreEqual("a`tb", ConvertFrom_Excel('"a" & CHAR(9) & "b"'))
  }
  ConvertFrom_Excel_RoundTrip()
  {
    original := "hello`nworld`ttab`"quote"
    Assert_AreEqual(original, ConvertFrom_Excel(ConvertTo_Excel(original)))
  }
  ConvertFrom_Excel_WithEnclosure()
  {
    Assert_AreEqual("hello", ConvertFrom_Excel('"hello"'))
  }
  ConvertFrom_Excel_ComplexString()
  {
    Assert_AreEqual("line1`nline2`ttab`"quote", ConvertFrom_Excel('"line1" & CHAR(10) & "line2" & CHAR(9) & "tab""quote"'))
  }
}
