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

ContextMenu_WindowSelect().Show()

/**
 * @returns {ContextMenu}
 */
ContextMenu_WindowSelect()
{
  ctx := ContextMenu()
  windowList := Stream(WinGetList(, , "Program Manager"))
  .Map(hWnd => Format("ahk_id {}", hWnd))
  .Filter(id => WinGetTitle(id) !== "")
  .ToMap((hWnd, id) => Format("{}`t{}", WinGetProcessName(id), WinGetMinMax(id)), id => id)
  for key in Array_Sort(Map_Keys(windowList))
  {
    id := windowList.Get(key)
    label := WinGetID(id) == WinGetID("A") ? "*" : (StrLen(A_Index) == 1 ? "&" : "") A_Index
    switch WinGetMinMax(id)
    {
      case -1: state := "Minimized"
      case 1: state := "Maximized"
      default: state := ""
    }
    ctx.Add(Format("{:-3}{}`t{}", label, WinGetProcessName(id), state), (x => WinActivate(x)).Bind(id), WinGetProcessPath(id))
  }
  return ctx
}
