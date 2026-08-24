#Requires AutoHotkey v2.0
#SingleInstance Force
#Warn
#WinActivateForce
#ClipboardTimeout -1
#NoTrayIcon
#Include "..\Lib.ahk"
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
    if RegExMatch("https://example.com:8080/path?query#hash", "(*UCP)^" RegEx_Http() "$", &match)
    {
      Assert_AreEqual("https", match.protocol)
      Assert_AreEqual("example.com", match.host)
      Assert_AreEqual("8080", match.port)
      Assert_AreEqual("/path", match.pathname)
      Assert_AreEqual("query", match.search)
      Assert_AreEqual("hash", match.hash)
    }
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
    if RegExMatch("file://server/share/file.txt", "(*UCP)^" RegEx_File() "$", &match)
    {
      Assert_AreEqual("file", match.protocol)
      Assert_AreEqual("server", match.host)
      Assert_AreEqual("/share/file.txt", match.pathname)
    }
  }
  RegEx_File_InvalidScheme()
  {
    Assert_IsFalse(RegExMatch("http://example.com", "(*UCP)^" RegEx_File() "$"))
  }
  RegEx_File_UnicodePath()
  {
    Assert_IsTrue(RegExMatch("file:///C:/日本語.txt", "(*UCP)^" RegEx_File() "$"))
  }
}
RegEx_Tests()
