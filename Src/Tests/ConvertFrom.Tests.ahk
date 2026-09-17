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
  ConvertFrom_AutoHotkey_SimpleString()
  {
    Assert_AreEqual("hello", ConvertFrom_AutoHotkey("hello"))
  }
  ConvertFrom_AutoHotkey_WithBacktick()
  {
    Assert_AreEqual("a``b", ConvertFrom_AutoHotkey("a````b"))
  }
  ConvertFrom_AutoHotkey_WithComma()
  {
    Assert_AreEqual("a,b", ConvertFrom_AutoHotkey("a`,b"))
  }
  ConvertFrom_AutoHotkey_WithSemicolon()
  {
    Assert_AreEqual("a;b", ConvertFrom_AutoHotkey("a`;b"))
  }
  ConvertFrom_AutoHotkey_WithPercent()
  {
    Assert_AreEqual("a%b", ConvertFrom_AutoHotkey("a`%b"))
  }
  ConvertFrom_AutoHotkey_WithHash()
  {
    Assert_AreEqual("a#b", ConvertFrom_AutoHotkey("a`#b"))
  }
  ConvertFrom_AutoHotkey_WithColon()
  {
    Assert_AreEqual("a:b", ConvertFrom_AutoHotkey("a`:b"))
  }
  ConvertFrom_AutoHotkey_WithQuote()
  {
    Assert_AreEqual('a"b', ConvertFrom_AutoHotkey('a`"b'))
  }
  ConvertFrom_AutoHotkey_RoundTrip()
  {
    original := "hello`nworld`ttab`"quote`a,b;c%d#e:f`g`0h"
    Assert_AreEqual(original, ConvertFrom_AutoHotkey(ConvertTo_AutoHotkey(original)))
  }
  ConvertFrom_Json_SimpleString()
  {
    Assert_AreEqual("hello", ConvertFrom_Json("hello"))
  }
  ConvertFrom_Json_BackslashOnly()
  {
    Assert_AreEqual("\", ConvertFrom_Json("\\"))
  }
  ConvertFrom_Json_BackslashThenLf()
  {
    Assert_AreEqual("\`n", ConvertFrom_Json("\\\n"))
  }
  ConvertFrom_Json_EmptyString()
  {
    Assert_AreEqual("", ConvertFrom_Json(""))
  }
  ConvertFrom_Json_WithCr()
  {
    Assert_AreEqual("a`rb", ConvertFrom_Json("a\rb"))
  }
  ConvertFrom_Json_WithLf()
  {
    Assert_AreEqual("a`nb", ConvertFrom_Json("a\nb"))
  }
  ConvertFrom_Json_WithCrLf()
  {
    Assert_AreEqual("a`r`nb", ConvertFrom_Json("a\r\nb"))
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
  ConvertFrom_Json_WithBackspace()
  {
    Assert_AreEqual("a`bb", ConvertFrom_Json("a\bb"))
  }
  ConvertFrom_Json_WithFormFeed()
  {
    Assert_AreEqual("a`fb", ConvertFrom_Json("a\fb"))
  }
  ConvertFrom_Json_WithVerticalTab()
  {
    Assert_AreEqual("a`vb", ConvertFrom_Json("a\vb"))
  }
  ConvertFrom_Json_WithNull()
  {
    Assert_AreEqual("a" Chr(0) "b", ConvertFrom_Json("a\0b"))
  }
  ConvertFrom_Json_WithHexadecimalEscape()
  {
    Assert_AreEqual(Chr(0xA9), ConvertFrom_Json("\xA9"))
  }
  ConvertFrom_Json_WithUnicodeEscape()
  {
    Assert_AreEqual(Chr(0x00A9), ConvertFrom_Json("\u00A9"))
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
    Assert_AreEqual("'hello'", ConvertFrom_SQL("''hello''"))
    Assert_AreEqual("'hello'", ConvertFrom_SQL("'''hello'''"))
  }
  ConvertFrom_SQL_EmptyString()
  {
    Assert_AreEqual("", ConvertFrom_SQL(""))
  }
  ConvertFrom_SQL_Concatenation()
  {
    Assert_AreEqual("ab", ConvertFrom_SQL("'a' || 'b'"))
    Assert_AreEqual("abc", ConvertFrom_SQL("'a' || 'b' || 'c'"))
  }
  ConvertFrom_SQL_WithCr()
  {
    Assert_AreEqual("a`rb", ConvertFrom_SQL("'a' || CHR(13) || 'b'"))
  }
  ConvertFrom_SQL_WithLf()
  {
    Assert_AreEqual("a`nb", ConvertFrom_SQL("'a' || CHR(10) || 'b'"))
  }
  ConvertFrom_SQL_WithCrLf()
  {
    Assert_AreEqual("a`r`nb", ConvertFrom_SQL("'a' || CHR(13) || CHR(10) || 'b'"))
  }
  ConvertFrom_SQL_WithTab()
  {
    Assert_AreEqual("a`tb", ConvertFrom_SQL("'a' || CHR(9) || 'b'"))
  }
  ConvertFrom_SQL_WithBackspace()
  {
    Assert_AreEqual("a`bb", ConvertFrom_SQL("'a' || CHR(8) || 'b'"))
  }
  ConvertFrom_SQL_WithFormFeed()
  {
    Assert_AreEqual("a`fb", ConvertFrom_SQL("'a' || CHR(12) || 'b'"))
  }
  ConvertFrom_SQL_WithVerticalTab()
  {
    Assert_AreEqual("a`vb", ConvertFrom_SQL("'a' || CHR(11) || 'b'"))
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
    Assert_AreEqual("a``b", ConvertFrom_PowerShell("a````b"))
  }
  ConvertFrom_PowerShell_BacktickOnly()
  {
    Assert_AreEqual("``", ConvertFrom_PowerShell("````"))
  }
  ConvertFrom_PowerShell_BacktickThenLf()
  {
    Assert_AreEqual("``" "n", ConvertFrom_PowerShell("````n"))
  }
  ConvertFrom_PowerShell_WithQuotes()
  {
    Assert_AreEqual('a"b', ConvertFrom_PowerShell('a`"b'))
  }
  ConvertFrom_PowerShell_EmptyString()
  {
    Assert_AreEqual("", ConvertFrom_PowerShell(""))
  }
  ConvertFrom_PowerShell_Concatenation()
  {
    Assert_AreEqual("ab", ConvertFrom_PowerShell('"a" + "b"'))
    Assert_AreEqual("abc", ConvertFrom_PowerShell('"a" + "b" + "c"'))
  }
  ConvertFrom_PowerShell_LineContinuation()
  {
    Assert_AreEqual("ab", ConvertFrom_PowerShell('"a" ```n + "b"'))
    Assert_AreEqual("abc", ConvertFrom_PowerShell('"a" ```n + "b" ```n + "c"'))
  }
  ConvertFrom_PowerShell_WithDollar()
  {
    Assert_AreEqual("$var", ConvertFrom_PowerShell("``$var"))
    Assert_AreEqual("$var", ConvertFrom_PowerShell("$var"))
    Assert_AreEqual("$($var)", ConvertFrom_PowerShell("$($var)"))
    Assert_AreEqual("${var}", ConvertFrom_PowerShell("${var}"))
  }
  ConvertFrom_PowerShell_WithBraces()
  {
    Assert_AreEqual("{path}", ConvertFrom_PowerShell("``{path``}"))
  }
  ConvertFrom_PowerShell_WithCr()
  {
    Assert_AreEqual("a`rb", ConvertFrom_PowerShell("a``rb"))
  }
  ConvertFrom_PowerShell_WithLf()
  {
    Assert_AreEqual("a`nb", ConvertFrom_PowerShell("a``nb"))
  }
  ConvertFrom_PowerShell_WithCrLf()
  {
    Assert_AreEqual("a`r`nb", ConvertFrom_PowerShell("a``r``nb"))
  }
  ConvertFrom_PowerShell_WithTab()
  {
    Assert_AreEqual("a`tb", ConvertFrom_PowerShell("a``tb"))
  }
  ConvertFrom_PowerShell_WithNull()
  {
    Assert_AreEqual("a" Chr(0) "b", ConvertFrom_PowerShell("a``0b"))
  }
  ConvertFrom_PowerShell_WithAlert()
  {
    Assert_AreEqual("a`ab", ConvertFrom_PowerShell("a``ab"))
  }
  ConvertFrom_PowerShell_WithBackspace()
  {
    Assert_AreEqual("a`bb", ConvertFrom_PowerShell("a``bb"))
  }
  ConvertFrom_PowerShell_WithEscape()
  {
    Assert_AreEqual("a" Chr(27) "b", ConvertFrom_PowerShell("a``eb"))
  }
  ConvertFrom_PowerShell_WithFormFeed()
  {
    Assert_AreEqual("a`fb", ConvertFrom_PowerShell("a``fb"))
  }
  ConvertFrom_PowerShell_WithVerticalTab()
  {
    Assert_AreEqual("a`vb", ConvertFrom_PowerShell("a``vb"))
  }
  ConvertFrom_PowerShell_WithUnicode()
  {
    Assert_AreEqual(Chr(0x1F44D), ConvertFrom_PowerShell("``u{1F44D}"))
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
    Assert_AreEqual('"hello"', ConvertFrom_VisualBasic('"""hello"""'))
  }
  ConvertFrom_VisualBasic_EmptyString()
  {
    Assert_AreEqual("", ConvertFrom_VisualBasic(""))
  }
  ConvertFrom_VisualBasic_Concatenation()
  {
    Assert_AreEqual("ab", ConvertFrom_VisualBasic('"a" & "b"'))
    Assert_AreEqual("abc", ConvertFrom_VisualBasic('"a" & "b" & "c"'))
  }
  ConvertFrom_VisualBasic_LineContinuation()
  {
    Assert_AreEqual("ab", ConvertFrom_VisualBasic('"a" & _`n"b"'))
    Assert_AreEqual("abc", ConvertFrom_VisualBasic('"a" & _`n"b" & _`n"c"'))
  }
  ConvertFrom_VisualBasic_WithCr()
  {
    Assert_AreEqual("a`rb", ConvertFrom_VisualBasic('"a" & vbCr & "b"'))
  }
  ConvertFrom_VisualBasic_WithLf()
  {
    Assert_AreEqual("a`nb", ConvertFrom_VisualBasic('"a" & vbLf & "b"'))
  }
  ConvertFrom_VisualBasic_WithCrLf()
  {
    Assert_AreEqual("a`r`nb", ConvertFrom_VisualBasic('"a" & vbCrLf & "b"'))
  }
  ConvertFrom_VisualBasic_WithTab()
  {
    Assert_AreEqual("a`tb", ConvertFrom_VisualBasic('"a" & vbTab & "b"'))
  }
  ConvertFrom_VisualBasic_WithBackspace()
  {
    Assert_AreEqual("a`bb", ConvertFrom_VisualBasic('"a" & vbBack & "b"'))
  }
  ConvertFrom_VisualBasic_WithFormFeed()
  {
    Assert_AreEqual("a`fb", ConvertFrom_VisualBasic('"a" & vbFormFeed & "b"'))
  }
  ConvertFrom_VisualBasic_WithVerticalTab()
  {
    Assert_AreEqual("a`vb", ConvertFrom_VisualBasic('"a" & vbVerticalTab & "b"'))
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
    Assert_AreEqual("line1`nline2`ttab`"quote`rback", ConvertFrom_VisualBasic('"line1" & vbLf & "line2" & vbTab & "tab""quote" & vbCr & "back"'))
  }
  ConvertFrom_Excel_SimpleString()
  {
    Assert_AreEqual("hello", ConvertFrom_Excel("hello"))
  }
  ConvertFrom_Excel_WithQuotes()
  {
    Assert_AreEqual('a"b', ConvertFrom_Excel('a""b'))
  }
  ConvertFrom_Excel_Concatenation()
  {
    Assert_AreEqual("ab", ConvertFrom_Excel('"a" & "b"'))
    Assert_AreEqual("abc", ConvertFrom_Excel('"a" & "b" & "c"'))
  }
  ConvertFrom_Excel_WithCr()
  {
    Assert_AreEqual("a`rb", ConvertFrom_Excel('"a" & CHAR(13) & "b"'))
  }
  ConvertFrom_Excel_WithLf()
  {
    Assert_AreEqual("a`nb", ConvertFrom_Excel('"a" & CHAR(10) & "b"'))
  }
  ConvertFrom_Excel_WithCrLf()
  {
    Assert_AreEqual("a`r`nb", ConvertFrom_Excel('"a" & CHAR(13) & CHAR(10) & "b"'))
  }
  ConvertFrom_Excel_WithTab()
  {
    Assert_AreEqual("a`tb", ConvertFrom_Excel('"a" & CHAR(9) & "b"'))
  }
  ConvertFrom_Excel_WithBackspace()
  {
    Assert_AreEqual("a`bb", ConvertFrom_Excel('"a" & CHAR(8) & "b"'))
  }
  ConvertFrom_Excel_WithFormFeed()
  {
    Assert_AreEqual("a`fb", ConvertFrom_Excel('"a" & CHAR(12) & "b"'))
  }
  ConvertFrom_Excel_WithVerticalTab()
  {
    Assert_AreEqual("a`vb", ConvertFrom_Excel('"a" & CHAR(11) & "b"'))
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
ConvertFrom_Tests()
