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
  _a_1(url) => '<a href="' url '">title</a>'
  _a_2(url) => "<a href='" url "'>title</a>"
  _md_1(url) => "[title](" url ")"
  _md_2(url) => "[title](<" url ">)"
  String_Normalize()
  {
    Assert_AreEqual("Hello, world!", String_Normalize("Hello, world!"))
    Assert_AreEqual("アイウエオ", String_Normalize("アイウエオ"))
    Assert_AreEqual("アイウエオ", String_Normalize("ｱｲｳｴｵ", "NFKC"))
  }
  String_ExtractPath_1()
  {
    Assert_AreEqual("", String_ExtractPath(""))
    Assert_AreEqual("", String_ExtractPath("\"))
    Assert_AreEqual("", String_ExtractPath("\\"))
    for path in ["C:\Windows\explorer.exe", "\\localhost\C$\Windows\explorer.exe"]
    {
      Assert_AreEqual(path, String_ExtractPath(path))
      Assert_AreEqual(path, String_ExtractPath("- " path))
      Assert_AreEqual(path, String_ExtractPath(StrReplace(path, "\", "/")))
      Assert_AreEqual(path, String_ExtractPath(StrReplace(path, "\", "\\")))
    }
  }
  String_ExtractPath_2()
  {
    for url in ["https://example.com", "file:///C:/Windows/explorer.exe", "mailto:postmaster@example.com"]
      Assert_AreEqual("", String_ExtractPath(url))
  }
  String_ExtractPath_3()
  {
    for path in ["C:\Windows\explorer.exe", "\\localhost\C$\Windows\explorer.exe"]
    {
      Assert_AreEqual(path, String_ExtractPath('- "' path '"'))
      Assert_AreEqual(path, String_ExtractPath("- '" path "'"))
      Assert_AreEqual(path, String_ExtractPath("- (" path ")"))
      Assert_AreEqual(path, String_ExtractPath("- [" path "]"))
      Assert_AreEqual(path, String_ExtractPath("- {" path "}"))
      Assert_AreEqual(path, String_ExtractPath("- <" path ">"))
    }
  }
  String_ExtractPath_4()
  {
    for path in ["C:\Windows\explorer.exe", "\\localhost\C$\Windows\explorer.exe"]
    {
      Assert_AreEqual(path, String_ExtractPath(path '"'))
      Assert_AreEqual(path "'", String_ExtractPath(path "'"))
      Assert_AreEqual(path "(", String_ExtractPath(path "("))
      Assert_AreEqual(path ")", String_ExtractPath(path ")"))
      Assert_AreEqual(path "[", String_ExtractPath(path "["))
      Assert_AreEqual(path "]", String_ExtractPath(path "]"))
      Assert_AreEqual(path "{", String_ExtractPath(path "{"))
      Assert_AreEqual(path "}", String_ExtractPath(path "}"))
      Assert_AreEqual(path, String_ExtractPath(path ">"))
    }
  }
  String_ExtractPath_5()
  {
    for path in ["C:\Windows\explorer.exe", "\\localhost\C$\Windows\explorer.exe"]
    {
      Assert_AreEqual(path, String_ExtractPath("- " path '"'))
      Assert_AreEqual(path "'", String_ExtractPath("- " path "'"))
      Assert_AreEqual(path "(", String_ExtractPath("- " path "("))
      Assert_AreEqual(path ")", String_ExtractPath("- " path ")"))
      Assert_AreEqual(path "[", String_ExtractPath("- " path "["))
      Assert_AreEqual(path "]", String_ExtractPath("- " path "]"))
      Assert_AreEqual(path "{", String_ExtractPath("- " path "{"))
      Assert_AreEqual(path "}", String_ExtractPath("- " path "}"))
      Assert_AreEqual(path, String_ExtractPath("- " path "<"))
      Assert_AreEqual(path, String_ExtractPath("- " path ">"))
    }
  }
  String_ExtractUrl_1()
  {
    for url in ["file:///C:/Windows/explorer.exe", "https://example.com"]
    {
      Assert_AreEqual(url, String_ExtractUrl(url))
      Assert_AreEqual(url, String_ExtractUrl(this._a_1(url)))
      Assert_AreEqual(url, String_ExtractUrl(this._a_2(url)))
      Assert_AreEqual(url, String_ExtractUrl(this._md_1(url)))
      Assert_AreEqual(url, String_ExtractUrl(this._md_2(url)))
    }
  }
  String_ExtractUrl_2()
  {
    for path in ["C:\Windows\explorer.exe", "\\localhost\C$\Windows\explorer.exe"]
    {
      Assert_AreEqual("", String_ExtractUrl(path))
      Assert_AreEqual("", String_ExtractUrl(StrReplace(path, "\", "/")))
      Assert_AreEqual("", String_ExtractUrl(StrReplace(path, "\", "\\")))
    }
  }
  String_ExtractUrl_3()
  {
    for url in ["file:///C:/Windows/explorer.exe", "https://example.com"]
    {
      Assert_AreEqual(url, String_ExtractUrl('- "' url '"'))
      Assert_AreEqual(url, String_ExtractUrl("- '" url "'"))
      Assert_AreEqual(url, String_ExtractUrl("- (" url ")"))
      Assert_AreEqual(url, String_ExtractUrl("- [" url "]"))
      Assert_AreEqual(url, String_ExtractUrl("- {" url "}"))
      Assert_AreEqual(url, String_ExtractUrl("- <" url ">"))
    }
  }
  String_ExtractUrl_4()
  {
    for url in ["file:///C:/Windows/explorer.exe", "https://example.com"]
    {
      Assert_AreEqual(url '"', String_ExtractUrl(url '"'))
      Assert_AreEqual(url "'", String_ExtractUrl(url "'"))
      Assert_AreEqual(url "(", String_ExtractUrl(url "("))
      Assert_AreEqual(url ")", String_ExtractUrl(url ")"))
      Assert_AreEqual(url "[", String_ExtractUrl(url "["))
      Assert_AreEqual(url "]", String_ExtractUrl(url "]"))
      Assert_AreEqual(url "{", String_ExtractUrl(url "{"))
      Assert_AreEqual(url "}", String_ExtractUrl(url "}"))
      Assert_AreEqual(url ">", String_ExtractUrl(url ">"))
      Assert_AreEqual(url "<", String_ExtractUrl(url "<"))
    }
  }
  String_ExtractUrl_5()
  {
    for url in ["file:///C:/Windows/explorer.exe", "https://example.com"]
    {
      Assert_AreEqual(url '"', String_ExtractUrl("- " url '"'))
      Assert_AreEqual(url "'", String_ExtractUrl("- " url "'"))
      Assert_AreEqual(url "(", String_ExtractUrl("- " url "("))
      Assert_AreEqual(url ")", String_ExtractUrl("- " url ")"))
      Assert_AreEqual(url "[", String_ExtractUrl("- " url "["))
      Assert_AreEqual(url "]", String_ExtractUrl("- " url "]"))
      Assert_AreEqual(url "{", String_ExtractUrl("- " url "{"))
      Assert_AreEqual(url "}", String_ExtractUrl("- " url "}"))
      Assert_AreEqual(url "<", String_ExtractUrl("- " url "<"))
      Assert_AreEqual(url ">", String_ExtractUrl("- " url ">"))
    }
  }
  String_ExtractUrl_6()
  {
    for url in ["file:///C:/Windows/explorer.exe", "https://example.com"]
    {
      Assert_AreEqual(url '"', String_ExtractUrl(this._md_1(url '"')))
      Assert_AreEqual(url "'", String_ExtractUrl(this._md_1(url "'")))
      Assert_AreEqual(url "(", String_ExtractUrl(this._md_1(url "(")))
      Assert_AreEqual(url ")", String_ExtractUrl(this._md_1(url ")")))
      Assert_AreEqual(url "[", String_ExtractUrl(this._md_1(url "[")))
      Assert_AreEqual(url "]", String_ExtractUrl(this._md_1(url "]")))
      Assert_AreEqual(url "{", String_ExtractUrl(this._md_1(url "{")))
      Assert_AreEqual(url "}", String_ExtractUrl(this._md_1(url "}")))
      Assert_AreEqual(url "<", String_ExtractUrl(this._md_1(url "<")))
      Assert_AreEqual(url ">", String_ExtractUrl(this._md_1(url ">")))
    }
  }
  String_ExtractUrl_7()
  {
    for url in ["file:///C:/Windows/explorer.exe", "https://example.com"]
    {
      Assert_AreEqual(url '"', String_ExtractUrl(this._md_2(url '"')))
      Assert_AreEqual(url "'", String_ExtractUrl(this._md_2(url "'")))
      Assert_AreEqual(url "(", String_ExtractUrl(this._md_2(url "(")))
      Assert_AreEqual(url ")", String_ExtractUrl(this._md_2(url ")")))
      Assert_AreEqual(url "[", String_ExtractUrl(this._md_2(url "[")))
      Assert_AreEqual(url "]", String_ExtractUrl(this._md_2(url "]")))
      Assert_AreEqual(url "{", String_ExtractUrl(this._md_2(url "{")))
      Assert_AreEqual(url "}", String_ExtractUrl(this._md_2(url "}")))
      Assert_AreEqual(url "<", String_ExtractUrl(this._md_2(url "<")))
      Assert_AreEqual(url ">", String_ExtractUrl(this._md_2(url ">")))
    }
  }
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
