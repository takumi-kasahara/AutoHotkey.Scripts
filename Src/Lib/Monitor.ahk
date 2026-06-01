#Requires AutoHotkey v2.0

/**
 * @param {String} [id]
 * @param {Integer*} [left]
 * @param {Integer*} [top]
 * @param {Integer*} [right]
 * @param {Integer*} [bottom]
 * @returns {Integer}
 */
Monitor_Find(id?, &left?, &top?, &right?, &bottom?)
{
  if IsSet(id)
    WinGetPos(&x, &y, , , id)
  else
    MouseGetPos(&x, &y)
  loop MonitorGetCount()
  {
    MonitorGet(A_Index, &left, &top, &right, &bottom)
    if !(left <= x && x <= right && top <= y && y <= bottom)
      continue
    MonitorGetWorkArea(A_Index, &left, &top, &right, &bottom)
    return A_Index
  }
}
/**
 * @param {String} [id]
 * @returns {Float}
 */
Monitor_GetScale(id?)
{
  if IsSet(id)
    WinGetPos(&x, &y, , , id)
  else
    MouseGetPos(&x, &y)

  pt := Buffer(8)
  NumPut("Int", x, "Int", y, pt)
  static MONITOR_DEFAULTTONEAREST := 0x00000002
  /** @see {@link https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-monitorfrompoint} */
  hMonitor := DllCall("MonitorFromPoint"
    , "Int64", NumGet(pt, "Int64")      ; POINT pt
    , "UInt", MONITOR_DEFAULTTONEAREST  ; DWORD dwFlags
    , "Ptr"                             ; HMONITOR
  )
  if !hMonitor
    return 1.0
  static MDT_EFFECTIVE_DPI := 0
  dpiX := 0
  dpiY := 0
  /** @see {@link https://learn.microsoft.com/en-us/windows/win32/api/shellscalingapi/nf-shellscalingapi-getdpiformonitor} */
  if DllCall("SHCore.dll\GetDpiForMonitor"
    , "Ptr", hMonitor           ; HMONITOR hmonitor
    , "Int", MDT_EFFECTIVE_DPI  ; MONITOR_DPI_TYPE dpiType
    , "UInt*", &dpiX            ; UINT *dpiX
    , "UInt*", &dpiY            ; UINT *dpiY
    , "UInt"
  ) !== S_OK
    return 1.0
  static DEFAULT_DPI := 96
  return dpiX / DEFAULT_DPI
}
