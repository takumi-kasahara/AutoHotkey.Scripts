#Requires AutoHotkey v2.0

INVALID_HANDLE_VALUE := -1  ; ((HANDLE)(LONG_PTR)-1)

/**
 * @see {@link https://learn.microsoft.com/en-us/windows/win32/api/handleapi/nf-handleapi-closehandle}
 * @param {Integer} hObject HANDLE
 */
CloseHandle(hObject)
{
  if !DllCall("kernel32.dll\CloseHandle"
    , "Ptr", hObject  ; HANDLE  hObject
    , "Int"           ; BOOL
  )
    throw OSError()
  return true
}
