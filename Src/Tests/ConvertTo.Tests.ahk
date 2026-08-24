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
  ConvertTo_String_StringInput()
  {
    Assert_AreEqual("hello", ConvertTo_String("hello"))
  }
  ConvertTo_String_ArrayInput()
  {
    Assert_AreEqual("a`nb`nc", ConvertTo_String(["a", "b", "c"]))
  }
  ConvertTo_String_ArrayInput_CustomSeparator()
  {
    Assert_AreEqual("a,b,c", ConvertTo_String(["a", "b", "c"], ","))
  }
  ConvertTo_String_MapInput()
  {
    m := Map("a", 1, "b", 2)
    Assert_AreEqual("1`n2", ConvertTo_String(m))
  }
  ConvertTo_String_FuncInput()
  {
    f := () => "result"
    Assert_AreEqual("result", ConvertTo_String(f))
  }
  ConvertTo_String_BoundFuncInput()
  {
    f := (x) => x " " x
    bf := f.Bind("result")
    Assert_AreEqual("result result", ConvertTo_String(bf))
  }
  ConvertTo_String_UnsupportedType()
  {
    Assert_Throws(() => ConvertTo_String(123), TypeError)
  }
  ConvertTo_Csv_SingleColumn()
  {
    Assert_AreEqual('"a"', ConvertTo_Csv("a"))
  }
  ConvertTo_Csv_MultipleColumns()
  {
    Assert_AreEqual('"a","b","c"', ConvertTo_Csv("a", "b", "c"))
  }
  ConvertTo_Csv_WithQuotes()
  {
    Assert_AreEqual('"a""b"', ConvertTo_Csv('a"b'))
  }
  ConvertTo_Csv_EmptyString()
  {
    Assert_AreEqual('""', ConvertTo_Csv(""))
  }
  ConvertTo_Json_SimpleString()
  {
    Assert_AreEqual('"hello"', ConvertTo_Json("hello"))
  }
  ConvertTo_Json_WithBackslash()
  {
    Assert_AreEqual('"a\\\\b"', ConvertTo_Json("a\\b"))
  }
  ConvertTo_Json_WithQuotes()
  {
    Assert_AreEqual('"a\"b"', ConvertTo_Json('a"b'))
  }
  ConvertTo_Json_WithNewlines()
  {
    Assert_AreEqual('"a\nb"', ConvertTo_Json("a`nb"))
  }
  ConvertTo_Json_WithTabs()
  {
    Assert_AreEqual('"a\tb"', ConvertTo_Json("a`tb"))
  }
  ConvertTo_Json_WithCarriageReturn()
  {
    Assert_AreEqual('"ab"', ConvertTo_Json("a`rb"))
  }
  ConvertTo_SQL_SimpleString()
  {
    Assert_AreEqual("'hello'", ConvertTo_SQL("hello"))
  }
  ConvertTo_SQL_WithSingleQuotes()
  {
    Assert_AreEqual("'it''s'", ConvertTo_SQL("it's"))
  }
  ConvertTo_SQL_WithNewlines()
  {
    Assert_AreEqual("'a' || CHR(10) || 'b'", ConvertTo_SQL("a`nb"))
  }
  ConvertTo_SQL_WithTabs()
  {
    Assert_AreEqual("'a' || CHR(9) || 'b'", ConvertTo_SQL("a`tb"))
  }
  ConvertTo_SQL_WithCarriageReturn()
  {
    Assert_AreEqual("'ab'", ConvertTo_SQL("a`rb"))
  }
  ConvertTo_PowerShell_SimpleString()
  {
    Assert_AreEqual('"hello"', ConvertTo_PowerShell("hello"))
  }
  ConvertTo_PowerShell_WithBackticks()
  {
    Assert_AreEqual('"a`b"', ConvertTo_PowerShell("a`b"))
  }
  ConvertTo_PowerShell_WithQuotes()
  {
    Assert_AreEqual('"a``"b"', ConvertTo_PowerShell('a"b'))
  }
  ConvertTo_PowerShell_WithDollar()
  {
    Assert_AreEqual('"a``$b"', ConvertTo_PowerShell("a$b"))
  }
  ConvertTo_PowerShell_WithBraces()
  {
    Assert_AreEqual('"a``{b``}"', ConvertTo_PowerShell("a{b}"))
  }
  ConvertTo_PowerShell_WithNewlines()
  {
    Assert_AreEqual('"a``nb"', ConvertTo_PowerShell("a`nb"))
  }
  ConvertTo_PowerShell_WithTabs()
  {
    Assert_AreEqual('"a``tb"', ConvertTo_PowerShell("a`tb"))
  }
  ConvertTo_PowerShell_WithCarriageReturn()
  {
    Assert_AreEqual('"ab"', ConvertTo_PowerShell("a`rb"))
  }
  ConvertTo_VisualBasic_SimpleString()
  {
    Assert_AreEqual('"hello"', ConvertTo_VisualBasic("hello"))
  }
  ConvertTo_VisualBasic_WithQuotes()
  {
    Assert_AreEqual('"a""b"', ConvertTo_VisualBasic('a"b'))
  }
  ConvertTo_VisualBasic_WithNewlines()
  {
    Assert_AreEqual('"a" & vbNewLine & "b"', ConvertTo_VisualBasic("a`nb"))
  }
  ConvertTo_VisualBasic_WithTabs()
  {
    Assert_AreEqual('"a" & vbTab & "b"', ConvertTo_VisualBasic("a`tb"))
  }
  ConvertTo_VisualBasic_WithCarriageReturn()
  {
    Assert_AreEqual('"ab"', ConvertTo_VisualBasic("a`rb"))
  }
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
    Assert_AreEqual('="mv "&A1&" "&B1', ConvertTo_ExcelFormula("mv {1} {2}"))
    Assert_AreEqual('="mv "&B1&" "&A1', ConvertTo_ExcelFormula("mv {2} {1}"))
  }
}
ConvertTo_Tests()
