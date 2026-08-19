#Requires AutoHotkey v2.0

/**
 * @returns {Integer} 0: Off, 1: On
 */
IME_Get()
{
  try
  {
    hWnd := ControlGetFocus("A")
    if hWnd == 0
    {
      hWnd := WinExist("A")
      if hWnd == 0
        return 0
    }
    /** @see {@link https://learn.microsoft.com/en-us/windows/win32/api/imm/nf-imm-immgetdefaultimewnd} */
    hWnd := DllCall("imm32.dll\ImmGetDefaultIMEWnd"
      , "UInt", hWnd  ; HWND unnamedParam1
      , "Ptr"         ; HWND
    )
    /** @see {@link https://learn.microsoft.com/en-us/windows/win32/intl/wm-ime-control} */
    static WM_IME_CONTROL := 0x0283
    static IMC_GETOPENSTATUS := 0x0005
    static IMC_GETCONVERSIONMODE := 0x0001
    ; https://learn.microsoft.com/en-us/windows/win32/api/imm/nf-imm-immgetopenstatus
    openStatus := SendMessage(WM_IME_CONTROL, IMC_GETOPENSTATUS, 0, hWnd)
    ; https://learn.microsoft.com/en-us/windows/win32/api/imm/nf-imm-immgetconversionstatus
    conversionMode := SendMessage(WM_IME_CONTROL, IMC_GETCONVERSIONMODE, 0, hWnd)
    return openStatus && conversionMode !== 0
  }
  catch
    return 0
}
/**
 * @see {@link https://learn.microsoft.com/en-us/windows/win32/winmsg/wm-inputlangchangerequest}
 * @param {Integer} state 0: Off, 1: On
 */
IME_Set(state)
{
  static delay := Integer(Config_Get("Delay", "KEY"))
  static WM_INPUTLANGCHANGEREQUEST := 0x0050
  hWnd := ControlGetFocus("A")
  if hWnd == 0
  {
    hWnd := WinExist("A")
    if hWnd == 0
      return 0
  }
  if state
  {
    static localeId_ja := 0x4110411
    PostMessage(WM_INPUTLANGCHANGEREQUEST, 0, localeId_ja, , hWnd)
  }
  else
  {
    static localeId_en := 0x4110409
    PostMessage(WM_INPUTLANGCHANGEREQUEST, 0, localeId_en, , hWnd)
  }
  Sleep(delay)
  if IME_Get() !== state
    Send("{sc029}")
  text := Format("IME: {}", state ? "On" : "Off")
  try
    if CaretGetPos(&x, &y)
      ToolTip(text, x, y)
    else
      ToolTip(text)
  finally
    SetTimer(() => ToolTip(), -delay)
}
