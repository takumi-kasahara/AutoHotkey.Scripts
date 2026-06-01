#Requires AutoHotkey v2.0

/**
 * @see {@link https://learn.microsoft.com/en-us/windows/win32/api/processenv/nf-processenv-getcommandlinew}
 * @returns {String}
 */
GetCommandLine() => DllCall("GetCommandLineW"
  , "WStr"  ; LPTSTR
)
