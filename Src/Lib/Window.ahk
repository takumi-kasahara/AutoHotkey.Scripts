#Requires AutoHotkey v2.0

/**
 * @param {String} [id="A"]
 */
Window_Close(id := "A")
{
  if MsgBox(Format("Close `"{}`" ?", WinGetTitle(id)), WinGetProcessName(id), 0x131) == "OK"
    try
      WinClose(id)
    catch
      if MsgBox(Format("Kill PID={} ({} windows) ?", WinGetPID(id), WinGetList(Format("ahk_pid {}", WinGetPID(id))).Length), WinGetProcessName(id), 0x131) == "OK"
        WinKill(id)
}
/**
 * @param {String} [id="A"]
 */
Window_Maximize(id := "A")
{
  if WinGetMinMax(id) !== 1
    WinMaximize(id)
  else
    WinRestore(id)
}
/**
 * @param {String} [id="A"]
 */
Window_Minimize(id := "A")
{
  if WinGetMinMax(id) !== -1
    WinMinimize(id)
  else
    WinRestore(id)
}
/**
 * @param {String} position Center | TopLeft | TopRight | BottomLeft | BottomRight
 * @param {String} [id="A"]
 */
Window_MoveTo(position, id := "A")
{
  WinRestore(id)
  WinGetPos(, , &width, &height, id)
  Monitor_Find(id, &left, &top, &right, &bottom)
  windowLeft := left
  windowRight := right - width
  windowTop := top
  windowBottom := bottom - height
  switch position
  {
    case "Center":
      WinMove((windowRight + windowLeft) / 2, (windowBottom + windowTop) / 2, , , id)
    case "TopLeft":
      WinMove(windowLeft, windowTop, , , id)
    case "TopRight":
      WinMove(windowRight, windowTop, , , id)
    case "BottomLeft":
      WinMove(windowLeft, windowBottom, , , id)
    case "BottomRight":
      WinMove(windowRight, windowBottom, , , id)
    default:
      ValueError("Invalid:`t" position)
  }
  return
}
/**
 * @see {@link https://www.autohotkey.com/docs/v2/misc/DPIScaling.htm}
 * @param {Integer} width
 * @param {Integer} height
 * @param {String} [id="A"]
 */
Window_Resize(width, height, id := "A")
{
  /** @see {@link https://learn.microsoft.com/en-us/windows/win32/hidpi/dpi-awareness-context} */
  static DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE_V2 := -4
  /** @see {@link https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-setthreaddpiawarenesscontext} */
  DllCall("SetThreadDpiAwarenessContext"
    , "Ptr", DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE_V2 ; DPI_AWARENESS_CONTEXT dpiContext
    , "Ptr"                                             ; DPI_AWARENESS_CONTEXT
  )
  scale := Monitor_GetScale(id)
  WinMove(, , width * scale, height * scale, id)
  Window_MoveTo("Center", id)
}
/**
 * @param {String} [id="A"]
 */
Window_ResizeTo(id := "A")
{
  WinGetPos(, , &w, &h, id)
  scale := Monitor_GetScale(id)
  fixedW := Integer(w / scale)
  fixedH := Integer(h / scale)
  input := InputBox("Current:`n" fixedW "," fixedH, , , fixedW "," fixedH)
  if input.Result == "Cancel"
    return
  newW := StrSplit(input.Value, ",")[1]
  newH := StrSplit(input.Value, ",")[2]
  if !(IsNumber(newW) && IsNumber(newH))
    return
  Window_Resize(newW, newH, id)
}
