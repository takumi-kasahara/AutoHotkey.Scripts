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

class String_Tests extends Test
{
  String_Normalize()
  {
    Assert_AreEqual("Hello, world!", String_Normalize("Hello, world!"))
    Assert_AreEqual("アイウエオ", String_Normalize("アイウエオ"))
    Assert_AreEqual("アイウエオ", String_Normalize("ｱｲｳｴｵ", "NFKC"))
  }
  String_ExtractPath_1()
  {
    for path in ["C:\Windows\explorer.exe", "\\localhost\C$\Windows\explorer.exe"]
      if FileExist(path)
      {
        Assert_AreEqual(path, String_ExtractPath(path))
        Assert_AreEqual(path, String_ExtractPath(" " path "\Dummy"))
        Assert_AreEqual(path, String_ExtractPath("- " path))
        Assert_AreEqual(path, String_ExtractPath(StrReplace(path, "\", "/")))
        Assert_AreEqual(path, String_ExtractPath(StrReplace(path, "\", "\\")))
      }
      else
        this.Log_Write(Format('"{}" not found', path))
  }
  String_ExtractPath_2()
  {
    for url in ["https://example.com", "file:///C:/Windows/explorer.exe", "mailto:postmaster@example.com"]
    {
      Assert_AreEqual("", String_ExtractPath(url))
      Assert_AreEqual("", String_ExtractPath(" " url "\Dummy"))
      Assert_AreEqual("", String_ExtractPath("- " url))
      Assert_AreEqual("", String_ExtractPath(StrReplace(url, "\", "/")))
      Assert_AreEqual("", String_ExtractPath(StrReplace(url, "\", "\\")))
    }
  }
  String_ExtractPath_3()
  {
    Assert_AreEqual("", String_ExtractPath(""))
    Assert_AreEqual("", String_ExtractPath("\"))
    Assert_AreEqual("", String_ExtractPath("\\"))
  }
  String_ExtractUrl_1()
  {
    for url in ["file:///C:/Windows/explorer.exe", "https://example.com"]
    {
      Assert_AreEqual(url, String_ExtractUrl(url))
      a := this._a(url)
      Assert_AreEqual(url, String_ExtractUrl(a))
      Assert_AreEqual(url, String_ExtractUrl("- " a))
      md := this._md(url)
      Assert_AreEqual(url, String_ExtractUrl(md))
      Assert_AreEqual(url, String_ExtractUrl("- " md))
    }
  }
  String_ExtractUrl_2()
  {
    for path in ["C:\Windows\explorer.exe", "\\localhost\C$\Windows\explorer.exe"]
    {
      Assert_AreEqual("", String_ExtractUrl(path))
      Assert_AreEqual("", String_ExtractUrl(" " path "\Dummy"))
      Assert_AreEqual("", String_ExtractUrl("- " path))
      Assert_AreEqual("", String_ExtractUrl(StrReplace(path, "\", "/")))
      Assert_AreEqual("", String_ExtractUrl(StrReplace(path, "\", "\\")))
    }
  }
  _a(url) => '<a href="' url '">title</a>'
  _md(url) => '[title](' url ')'
  String_Clean_1()
  {
    Assert_AreEqual("foo", String_Clean("foo"))
    Assert_AreEqual("foo", String_Clean("foo "))
    Assert_AreEqual("foo", String_Clean(" foo"))
    Assert_AreEqual("foo", String_Clean(" foo "))
  }
  String_Clean_2()
  {
    clean := "
    ( Join`n
      foo
        bar
          baz
    )"
    indented := "
    ( LTrim0 Join`n
      foo`t
        bar`t
          baz`t
    )"
    Assert_AreEqual(clean, String_Clean(clean))
    Assert_AreEqual(clean, String_Clean(indented))
  }
  String_Clean_3()
  {
    clean := "
    ( Join`n
      `t`tfoo
      `tbar
      baz
    )"
    indented := "
    ( LTrim0 Join`n
      `t`tfoo`t
      `tbar`t
      baz`t
    )"
    Assert_AreEqual(clean, String_Clean(clean))
    Assert_AreEqual(clean, String_Clean(indented))
  }
}
String_Tests()
