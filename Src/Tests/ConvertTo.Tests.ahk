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
    Assert_AreEqual("1`n2", ConvertTo_String(Map("a", 1, "b", 2)))
  }
  ConvertTo_String_FuncInput()
  {
    Assert_AreEqual("result", ConvertTo_String(() => "result"))
  }
  ConvertTo_String_BoundFuncInput()
  {
    Assert_AreEqual("result result", ConvertTo_String(((x) => x " " x).Bind("result")))
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
  ConvertTo_AutoHotkey_SimpleString()
  {
    Assert_AreEqual("hello", ConvertTo_AutoHotkey("hello"))
  }
  ConvertTo_AutoHotkey_WithBacktick()
  {
    Assert_AreEqual("a````b", ConvertTo_AutoHotkey("a``b"))
  }
  ConvertTo_AutoHotkey_BacktickOnly()
  {
    Assert_AreEqual("````", ConvertTo_AutoHotkey("``"))
  }
  ConvertTo_AutoHotkey_WithComma()
  {
    Assert_AreEqual("a``,b", ConvertTo_AutoHotkey("a,b"))
  }
  ConvertTo_AutoHotkey_WithSemicolon()
  {
    Assert_AreEqual("a``;b", ConvertTo_AutoHotkey("a;b"))
  }
  ConvertTo_AutoHotkey_WithPercent()
  {
    Assert_AreEqual("a``%b", ConvertTo_AutoHotkey("a%b"))
  }
  ConvertTo_AutoHotkey_WithHash()
  {
    Assert_AreEqual("a``#b", ConvertTo_AutoHotkey("a#b"))
  }
  ConvertTo_AutoHotkey_WithColon()
  {
    Assert_AreEqual("a``:b", ConvertTo_AutoHotkey("a:b"))
  }
  ConvertTo_AutoHotkey_WithQuote()
  {
    Assert_AreEqual('a``"b', ConvertTo_AutoHotkey('a"b'))
  }
  ConvertTo_AutoHotkey_RoundTrip()
  {
    original := "hello`nworld`ttab`"quote`a`b`c`d`e`f`g`h`i`j`k"
    Assert_AreEqual(original, ConvertFrom_AutoHotkey(ConvertTo_AutoHotkey(original)))
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
  ConvertTo_Json_WithCr()
  {
    Assert_AreEqual('"a\rb"', ConvertTo_Json("a`rb"))
  }
  ConvertTo_Json_WithLf()
  {
    Assert_AreEqual('"a\nb"', ConvertTo_Json("a`nb"))
  }
  ConvertTo_Json_WithTabs()
  {
    Assert_AreEqual('"a\tb"', ConvertTo_Json("a`tb"))
  }
  ConvertTo_Json_RoundTrip()
  {
    original := "hello"
    Assert_AreEqual(original, ConvertFrom_Json(ConvertTo_Json(original)))
  }
  ConvertTo_SQL_SimpleString()
  {
    Assert_AreEqual("'hello'", ConvertTo_SQL("hello"))
  }
  ConvertTo_SQL_WithSingleQuotes()
  {
    Assert_AreEqual("'it''s'", ConvertTo_SQL("it's"))
  }
  ConvertTo_SQL_WithCr()
  {
    Assert_AreEqual("'a' || CHR(13) || 'b'", ConvertTo_SQL("a`rb"))
  }
  ConvertTo_SQL_WithCrOnly()
  {
    Assert_AreEqual("CHR(13)", ConvertTo_SQL("`r"))
  }
  ConvertTo_SQL_WithLf()
  {
    Assert_AreEqual("'a' || CHR(10) || 'b'", ConvertTo_SQL("a`nb"))
  }
  ConvertTo_SQL_WithLfOnly()
  {
    Assert_AreEqual("CHR(10)", ConvertTo_SQL("`n"))
  }
  ConvertTo_SQL_WithCrLf()
  {
    Assert_AreEqual("'a' || CHR(13) || CHR(10) || 'b'", ConvertTo_SQL("a`r`nb"))
  }
  ConvertTo_SQL_WithTabs()
  {
    Assert_AreEqual("'a' || CHR(9) || 'b'", ConvertTo_SQL("a`tb"))
  }
  ConvertTo_SQL_WithBackspace()
  {
    Assert_AreEqual("'a' || CHR(8) || 'b'", ConvertTo_SQL("a`bb"))
  }
  ConvertTo_SQL_WithFormFeed()
  {
    Assert_AreEqual("'a' || CHR(12) || 'b'", ConvertTo_SQL("a`fb"))
  }
  ConvertTo_SQL_WithVerticalTab()
  {
    Assert_AreEqual("'a' || CHR(11) || 'b'", ConvertTo_SQL("a`vb"))
  }
  ConvertTo_SQL_RoundTrip()
  {
    original := "hello`nworld`ttab'quoteback"
    Assert_AreEqual(original, ConvertFrom_SQL(ConvertTo_SQL(original)))
  }
  ConvertTo_PowerShell_SimpleString()
  {
    Assert_AreEqual('"hello"', ConvertTo_PowerShell("hello"))
  }
  ConvertTo_PowerShell_WithBackticks()
  {
    Assert_AreEqual('"a``b"', ConvertTo_PowerShell("a`b"))
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
  ConvertTo_PowerShell_WithCr()
  {
    Assert_AreEqual('"a``rb"', ConvertTo_PowerShell("a`rb"))
  }
  ConvertTo_PowerShell_WithLf()
  {
    Assert_AreEqual('"a``nb"', ConvertTo_PowerShell("a`nb"))
  }
  ConvertTo_PowerShell_WithTabs()
  {
    Assert_AreEqual('"a``tb"', ConvertTo_PowerShell("a`tb"))
  }
  ConvertTo_PowerShell_WithAlert()
  {
    Assert_AreEqual('"a``ab"', ConvertTo_PowerShell("a`ab"))
  }
  ConvertTo_PowerShell_WithBackspace()
  {
    Assert_AreEqual('"a``bb"', ConvertTo_PowerShell("a`bb"))
  }
  ConvertTo_PowerShell_WithEscape()
  {
    Assert_AreEqual('"a``eb"', ConvertTo_PowerShell("a" Chr(27) "b"))
  }
  ConvertTo_PowerShell_WithFormFeed()
  {
    Assert_AreEqual('"a``fb"', ConvertTo_PowerShell("a`fb"))
  }
  ConvertTo_PowerShell_WithVerticalTab()
  {
    Assert_AreEqual('"a``vb"', ConvertTo_PowerShell("a`vb"))
  }
  ConvertTo_PowerShell_RoundTrip()
  {
    original := "hello`nworld`ttab`$var`{path}`"quoteback"
    Assert_AreEqual(original, ConvertFrom_PowerShell(ConvertTo_PowerShell(original)))
  }
  ConvertTo_VisualBasic_SimpleString()
  {
    Assert_AreEqual('"hello"', ConvertTo_VisualBasic("hello"))
  }
  ConvertTo_VisualBasic_WithQuotes()
  {
    Assert_AreEqual('"a""b"', ConvertTo_VisualBasic('a"b'))
  }
  ConvertTo_VisualBasic_WithCr()
  {
    Assert_AreEqual('"a" & vbCr & "b"', ConvertTo_VisualBasic("a`rb"))
  }
  ConvertTo_VisualBasic_WithLf()
  {
    Assert_AreEqual('"a" & vbLf & "b"', ConvertTo_VisualBasic("a`nb"))
  }
  ConvertTo_VisualBasic_WithTabs()
  {
    Assert_AreEqual('"a" & vbTab & "b"', ConvertTo_VisualBasic("a`tb"))
  }
  ConvertTo_VisualBasic_WithBackspace()
  {
    Assert_AreEqual('"a" & vbBack & "b"', ConvertTo_VisualBasic("a`bb"))
  }
  ConvertTo_VisualBasic_WithFormFeed()
  {
    Assert_AreEqual('"a" & vbFormFeed & "b"', ConvertTo_VisualBasic("a`fb"))
  }
  ConvertTo_VisualBasic_WithVerticalTab()
  {
    Assert_AreEqual('"a" & vbVerticalTab & "b"', ConvertTo_VisualBasic("a`vb"))
  }
  ConvertTo_VisualBasic_RoundTrip()
  {
    original := "hello`nworld`ttab`"quote`rback"
    Assert_AreEqual(original, ConvertFrom_VisualBasic(ConvertTo_VisualBasic(original)))
  }
  ConvertTo_Excel_SimpleString()
  {
    Assert_AreEqual('"hello"', ConvertTo_Excel("hello"))
  }
  ConvertTo_Excel_WithCr()
  {
    Assert_AreEqual('"a" & CHAR(13) & "b"', ConvertTo_Excel("a`rb"))
  }
  ConvertTo_Excel_WithCrOnly()
  {
    Assert_AreEqual('CHAR(13)', ConvertTo_Excel("`r"))
  }
  ConvertTo_Excel_WithLf()
  {
    Assert_AreEqual('"a" & CHAR(10) & "b"', ConvertTo_Excel("a`nb"))
  }
  ConvertTo_Excel_WithLfOnly()
  {
    Assert_AreEqual('CHAR(10)', ConvertTo_Excel("`n"))
  }
  ConvertTo_Excel_WithCrLf()
  {
    Assert_AreEqual('"a" & CHAR(13) & CHAR(10) & "b"', ConvertTo_Excel("a`r`nb"))
  }
  ConvertTo_Excel_WithTabs()
  {
    Assert_AreEqual('"a" & CHAR(9) & "b"', ConvertTo_Excel("a`tb"))
  }
  ConvertTo_Excel_WithBackspace()
  {
    Assert_AreEqual('"a" & CHAR(8) & "b"', ConvertTo_Excel("a`bb"))
  }
  ConvertTo_Excel_WithFormFeed()
  {
    Assert_AreEqual('"a" & CHAR(12) & "b"', ConvertTo_Excel("a`fb"))
  }
  ConvertTo_Excel_WithVerticalTab()
  {
    Assert_AreEqual('"a" & CHAR(11) & "b"', ConvertTo_Excel("a`vb"))
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
  ConvertTo_ExcelFormula_EscapeBraces()
  {
    Assert_AreEqual('="{a}"', ConvertTo_ExcelFormula("{{}a{}}"))
  }
  ConvertTo_ExcelHyperlink()
  {
    Assert_AreEqual('=HYPERLINK("http://example.com")', ConvertTo_ExcelHyperlink("http://example.com"))
    Assert_AreEqual('=HYPERLINK("http://example.com", "Example Domain")', ConvertTo_ExcelHyperlink("http://example.com", "Example Domain"))
  }
  ConvertTo_MarkdownLink()
  {
    Assert_AreEqual('<http://example.com>', ConvertTo_MarkdownLink("http://example.com"))
    Assert_AreEqual('[Example Domain](http://example.com)', ConvertTo_MarkdownLink("http://example.com", "Example Domain"))
  }
}
ConvertTo_Tests()
