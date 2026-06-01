#Requires AutoHotkey v2.0

/**
 * @see {@link https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-openclipboard}
 * @returns {Integer}
 */
OpenClipboard()
{
  if !DllCall("OpenClipboard"
    , "Ptr", 0  ; HWND hWndNewOwner
    , "Int"     ; BOOL
  )
    throw OSError()
  return true
}
/**
 * @see {@link https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-closeclipboard}
 * @returns {Integer}
 */
CloseClipboard()
{
  if !DllCall("CloseClipboard"
    , "Int" ; BOOL
  )
    throw OSError()
  return true
}
/**
 * @see {@link https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-emptyclipboard}
 * @returns {Integer}
 */
EmptyClipboard()
{
  if !DllCall("EmptyClipboard"
    , "Int" ; BOOL
  )
    throw OSError()
  return true
}
/**
 * @see {@link https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-registerclipboardformatw}
 * @param {String} lpszFormat
 * @returns {Integer}
 */
RegisterClipboardFormat(lpszFormat)
{
  uFormat := DllCall("RegisterClipboardFormatW"
    , "WStr", lpszFormat  ; LPCWSTR lpszFormat
    , "UInt"              ; UINT
  )
  if uFormat == 0
    throw OSError()
  return uFormat
}
; #endregion
