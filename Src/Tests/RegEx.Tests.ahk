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

class RegEx_Tests extends Test
{
  RegEx_Http_SimpleUrl()
  {
    Assert_IsTrue(RegExMatch("https://example.com", "(*UCP)^" RegEx_Http() "$"))
  }
  RegEx_Http_WithPort()
  {
    Assert_IsTrue(RegExMatch("https://example.com:8080", "(*UCP)^" RegEx_Http() "$"))
  }
  RegEx_Http_WithPathname()
  {
    Assert_IsTrue(RegExMatch("https://example.com/path/to/file.txt", "(*UCP)^" RegEx_Http() "$"))
  }
  RegEx_Http_WithSearch()
  {
    Assert_IsTrue(RegExMatch("https://example.com/path?key=value", "(*UCP)^" RegEx_Http() "$"))
  }
  RegEx_Http_WithHash()
  {
    Assert_IsTrue(RegExMatch("https://example.com/path#section", "(*UCP)^" RegEx_Http() "$"))
  }
  RegEx_Http_FullUrl()
  {
    Assert_IsTrue(RegExMatch("https://user@example.com:8080/path/to/file.txt?key=value#section", "(*UCP)^" RegEx_Http() "$"))
  }
  RegEx_Http_HttpScheme()
  {
    Assert_IsTrue(RegExMatch("http://example.com", "(*UCP)^" RegEx_Http() "$"))
  }
  RegEx_Http_InvalidScheme()
  {
    Assert_IsFalse(RegExMatch("ftp://example.com", "(*UCP)^" RegEx_Http() "$"))
  }
  RegEx_Http_MissingScheme()
  {
    Assert_IsFalse(RegExMatch("example.com", "(*UCP)^" RegEx_Http() "$"))
  }
  RegEx_Http_NamedGroups()
  {
    Assert_IsTrue(RegExMatch("https://example.com:8080/path?query#hash", "(*UCP)^" RegEx_Http() "$", &match))
    Assert_AreEqual("https", match.protocol)
    Assert_AreEqual("example.com", match.host)
    Assert_AreEqual("8080", match.port)
    Assert_AreEqual("/path", match.pathname)
    Assert_AreEqual("query", match.search)
    Assert_AreEqual("hash", match.hash)
  }
  RegEx_Http_UnicodeHost()
  {
    Assert_IsTrue(RegExMatch("https://日本語.example.com", "(*UCP)^" RegEx_Http() "$"))
  }
  RegEx_Http_SpecialCharactersInPath()
  {
    Assert_IsTrue(RegExMatch("https://example.com/path-with_underscore~tilde.dot", "(*UCP)^" RegEx_Http() "$"))
  }
  RegEx_File_LocalFile()
  {
    Assert_IsTrue(RegExMatch("file:///C:/path/to/file.txt", "(*UCP)^" RegEx_File() "$"))
  }
  RegEx_File_NetworkShare()
  {
    Assert_IsTrue(RegExMatch("file://server/share/file.txt", "(*UCP)^" RegEx_File() "$"))
  }
  RegEx_File_NoPath()
  {
    Assert_IsTrue(RegExMatch("file:///", "(*UCP)^" RegEx_File() "$"))
  }
  RegEx_File_NamedGroups()
  {
    Assert_IsTrue(RegExMatch("file://server/share/file.txt", "(*UCP)^" RegEx_File() "$", &match))
    Assert_AreEqual("file", match.protocol)
    Assert_AreEqual("server", match.host)
    Assert_AreEqual("/share/file.txt", match.pathname)
  }
  RegEx_File_InvalidScheme()
  {
    Assert_IsFalse(RegExMatch("http://example.com", "(*UCP)^" RegEx_File() "$"))
  }
  RegEx_File_UnicodePath()
  {
    Assert_IsTrue(RegExMatch("file:///C:/日本語.txt", "(*UCP)^" RegEx_File() "$"))
  }
  RegEx_Split_NoMatch()
  {
    result := RegEx_Split("hello world", ",")
    Assert_AreEqual(1, result.Length)
    Assert_AreEqual("hello world", result[1])
  }
  RegEx_Split_SimpleDelimiter()
  {
    result := RegEx_Split("a,b,c", ",")
    Assert_AreEqual(3, result.Length)
    Assert_AreEqual("a", result[1])
    Assert_AreEqual("b", result[2])
    Assert_AreEqual("c", result[3])
  }
  RegEx_Split_EmptyRegex()
  {
    result := RegEx_Split("hello", "")
    Assert_AreEqual(1, result.Length)
    Assert_AreEqual("hello", result[1])
  }
  RegEx_Split_EmptyString()
  {
    result := RegEx_Split("", ",")
    Assert_AreEqual(1, result.Length)
    Assert_AreEqual("", result[1])
  }
  RegEx_Split_AdjacentMatches()
  {
    result := RegEx_Split("a,,b", ",")
    Assert_AreEqual(3, result.Length)
    Assert_AreEqual("a", result[1])
    Assert_AreEqual("", result[2])
    Assert_AreEqual("b", result[3])
  }
  RegEx_Split_DelimiterAtStart()
  {
    result := RegEx_Split(",a,b", ",")
    Assert_AreEqual(3, result.Length)
    Assert_AreEqual("", result[1])
    Assert_AreEqual("a", result[2])
    Assert_AreEqual("b", result[3])
  }
  RegEx_Split_DelimiterAtEnd()
  {
    result := RegEx_Split("a,b,", ",")
    Assert_AreEqual(3, result.Length)
    Assert_AreEqual("a", result[1])
    Assert_AreEqual("b", result[2])
    Assert_AreEqual("", result[3])
  }
  RegEx_Split_RegexPattern()
  {
    result := RegEx_Split("a1b2c", "\d+")
    Assert_AreEqual(3, result.Length)
    Assert_AreEqual("a", result[1])
    Assert_AreEqual("b", result[2])
    Assert_AreEqual("c", result[3])
  }
  RegEx_Split_OnlyDelimiter()
  {
    result := RegEx_Split(",", ",")
    Assert_AreEqual(2, result.Length)
    Assert_AreEqual("", result[1])
    Assert_AreEqual("", result[2])
  }
  RegEx_Split_EOL()
  {
    result := RegEx_Split("a`r`nb`nc", "(*UCP)\r?\n")
    Assert_AreEqual(3, result.Length)
    Assert_AreEqual("a", result[1])
    Assert_AreEqual("b", result[2])
    Assert_AreEqual("c", result[3])
  }
  RegEx_Split_Tab()
  {
    result := RegEx_Split("a `t b `t c", "(*UCP)\s+")
    Assert_AreEqual(3, result.Length)
    Assert_AreEqual("a", result[1])
    Assert_AreEqual("b", result[2])
    Assert_AreEqual("c", result[3])
  }
  RegEx_Split_CommaWithWhitespace()
  {
    result := RegEx_Split("a , b , c", "(*UCP)\s*,\s*")
    Assert_AreEqual(3, result.Length)
    Assert_AreEqual("a", result[1])
    Assert_AreEqual("b", result[2])
    Assert_AreEqual("c", result[3])
  }
  RegEx_Split_PeriodWithWhitespace()
  {
    result := RegEx_Split("a . b . c", "(*UCP)\s*\.\s*")
    Assert_AreEqual(3, result.Length)
    Assert_AreEqual("a", result[1])
    Assert_AreEqual("b", result[2])
    Assert_AreEqual("c", result[3])
  }
  RegEx_Split_ColonWithWhitespace()
  {
    result := RegEx_Split("a : b : c", "(*UCP)\s*:\s*")
    Assert_AreEqual(3, result.Length)
    Assert_AreEqual("a", result[1])
    Assert_AreEqual("b", result[2])
    Assert_AreEqual("c", result[3])
  }
  RegEx_Split_SemicolonWithWhitespace()
  {
    result := RegEx_Split("a `; " "b `; c", "(*UCP)\s*;\s*")
    Assert_AreEqual(3, result.Length)
    Assert_AreEqual("a", result[1])
    Assert_AreEqual("b", result[2])
    Assert_AreEqual("c", result[3])
  }
}
RegEx_Tests()
