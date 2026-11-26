#Requires AutoHotkey v2.0
#SingleInstance Force
#Warn
#WinActivateForce
#ClipboardTimeout -1
#NoTrayIcon
#Include "..\Sources\Lib.ahk"
SetWorkingDir(A_ScriptDir "\..\Sources")
OnError(HandleError)
OnExit(HandleExit)

class ContextMenu_Tests extends Test
{
  TruncateName_1()
  {
    Assert_AreEqual("", ContextMenu.TruncateName(""))
    Assert_AreEqual("foo", ContextMenu.TruncateName("foo"))
  }
  TruncateName_2()
  {
    name := ""
    loop MAX_PATH
      name .= "a"
    Assert_AreEqual(MAX_PATH, StrLen(name))
    Assert_AreEqual(name, ContextMenu.TruncateName(name))
  }
  TruncateName_3()
  {
    name := ""
    loop MAX_PATH + 10
      name .= "a"
    truncated := ContextMenu.TruncateName(name)
    Assert_AreEqual(MAX_PATH, StrLen(truncated))
    Assert_AreEqual(SubStr(name, 1, MAX_PATH), truncated)
  }
  TruncateName_4()
  {
    head := "C:\Windows\explorer.exe"
    suffix := ""
    loop MAX_PATH
      suffix .= "a"
    name := head suffix
    truncated := ContextMenu.TruncateName(name)
    Assert_AreEqual(MAX_PATH, StrLen(truncated))
    Assert_AreEqual(head, SubStr(truncated, 1, StrLen(head)))
  }
}
ContextMenu_Tests()
