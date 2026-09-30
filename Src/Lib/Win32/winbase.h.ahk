#Requires AutoHotkey v2.0

/**
 * @see {@link https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-globallock}
 * @param {Integer} hMem HGLOBAL
 * @returns {Integer}
 */
GlobalLock(hMem)
{
  pMem := DllCall("GlobalLock"
    , "Ptr", hMem  ; HGLOBAL hMem
    , "Ptr"        ; LPVOID
  )
  if pMem == NULL
    throw OSError()
  return pMem
}
/**
 * @see {@link https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-globalunlock}
 * @param {Integer} hMem HGLOBAL
 * @returns {Integer}
 */
GlobalUnlock(hMem)
{
  pMem := DllCall("GlobalUnlock"
    , "Ptr", hMem  ; HGLOBAL hMem
    , "Int"        ; BOOL
  )
  if pMem == NULL && A_LastError !== NO_ERROR
    throw OSError()
  return pMem
}
/**
 * @see {@link https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-globalfree}
 * @param {Integer} hMem HGLOBAL
 * @returns {Integer}
 */
GlobalFree(hMem)
{
  pMem := DllCall("GlobalFree"
    , "Ptr", hMem ; HGLOBAL hMem
    , "Ptr"       ; HGLOBAL
  )
  if pMem !== NULL
    throw OSError()
  return pMem
}
