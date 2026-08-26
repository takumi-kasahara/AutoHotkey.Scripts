#Requires AutoHotkey v2.0
#SingleInstance Force
#Warn
#WinActivateForce
#ClipboardTimeout -1
#NoTrayIcon
#Include "..\..\Lib.ahk"
SetWorkingDir(A_ScriptDir "\..\..")
OnError(HandleError)
OnExit(HandleExit)

ContextMenu_Window().Show()

/**
 * @returns {ContextMenu}
 */
ContextMenu_Window()
{
  ctx := ContextMenu()
  ctx.Add("&1 Move to Center", () => Window_MoveTo("Center"))
  ctxMoveTo := ContextMenu()
  ctxMoveTo.Add("&1 TopLeft", () => Window_MoveTo("TopLeft"))
  ctxMoveTo.Add("&2 TopRight", () => Window_MoveTo("TopRight"))
  ctxMoveTo.Add("&3 BottomLeft", () => Window_MoveTo("BottomLeft"))
  ctxMoveTo.Add("&4 BottomRight", () => Window_MoveTo("BottomRight"))
  ctx.AddSubMenu("&2 Move to", ctxMoveTo)
  ctx.AddSeparator()
  ctxResize := ContextMenu()
  ctxResize.Add("&1 1280x960", () => Window_Resize(1280, 960))
  ctxResize.Add("&2 960x640", () => Window_Resize(960, 640))
  ctxResize.Add("&3 640x480", () => Window_Resize(640, 480))
  ctx.AddSubMenu("&3 Resize", ctxResize)
  if WinGetMinMax("A") !== 1
    ctx.Add("&4 Resize to", () => Window_ResizeTo())
  return ctx
}
