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

class Clipboard_Tests extends Test
{
  Clipboard_SetHtml()
  {
    backup := ClipboardAll()
    try
    {
      html := Document_CreateAnchorElement("https://www.example.com", "Example")
      Clipboard_SetHtml(html)
      Assert_AreEqual(html, A_Clipboard)
    }
    finally
      A_Clipboard := backup
  }
}
Clipboard_Tests()
