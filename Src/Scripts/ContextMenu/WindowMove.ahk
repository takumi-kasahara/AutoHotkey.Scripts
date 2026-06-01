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

ContextMenu_WindowMove().Show()

/**
 * @returns {ContextMenu}
 */
ContextMenu_WindowMove()
{
  ctx := ContextMenu()
  ctx.Add("&1 Move to Center", () => Window_MoveTo("Center"))
  ctx.AddSubMenu("&2 Move to", ContextMenu_WindowMoveTo())
  ctx.AddSeparator()
  ctx.Add("&3 Resize 1280x960", () => Window_Resize(1280, 960))
  ctx.Add("&4 Resize 960x640", () => Window_Resize(960, 640))
  ctx.Add("&5 Resize 640x480", () => Window_Resize(640, 480))
  if WinGetMinMax("A") !== 1
    ctx.Add("&6 Resize to", () => Window_ResizeTo())
  return ctx
}
/**
 * @returns {ContextMenu}
 */
ContextMenu_WindowMoveTo()
{
  ctx := ContextMenu()
  ctx.Add("&1 Move to TopLeft", () => Window_MoveTo("TopLeft"))
  ctx.Add("&2 Move to TopRight", () => Window_MoveTo("TopRight"))
  ctx.Add("&3 Move to BottomLeft", () => Window_MoveTo("BottomLeft"))
  ctx.Add("&4 Move to BottomRight", () => Window_MoveTo("BottomRight"))
  return ctx
}
