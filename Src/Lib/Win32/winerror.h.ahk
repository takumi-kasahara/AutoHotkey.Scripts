#Requires AutoHotkey v2.0

NO_ERROR := 0 ; 0L

FACILITY_WIN32 := 7
HRESULT_FROM_WIN32(x) => (x & 0xFFFF) | (FACILITY_WIN32 << 16) | 0x80000000
ERROR_NO_ASSOCIATION := HRESULT_FROM_WIN32(1155)

/** @see {@link https://learn.microsoft.com/en-us/windows/win32/seccrypto/common-hresult-values} */
S_OK := 0x00000000    ; ((HRESULT)0L)
S_FALSE := 0x00000001 ; ((HRESULT)1L)
