#Requires AutoHotkey v2.0

; #region ELECOM TK-FDM109TXBK
/** @see {@link https://www.elecom.co.jp/products/TK-FDM109TXBK.html} */
/**
 * @hotkey Fn + F9
 */
Browser_Home::Launch_Media
/**
 * @hotkey Fn + F10
 */
Launch_Mail::Launch_Mail
/**
 * @hotkey Fn + F11
 */
Launch_App1::Launch_App1
/**
 * @hotkey Fn + F12
 */
Browser_Favorites::Launch_App2
; #endregion
; #region CapsLock
/**
 * @hotkey [Ctrl] + CapsLock
 * @send   [Ctrl] + Shift + Tab
 */
sc03A::+Tab
+sc03A::CapsLock
; #endregion
; #region Esc
#Esc:: Window_Close()
; #endregion
; #region Disable Function Keys
#HotIf WinActive("ahk_group grpF1Disabled")
F1:: return
#HotIf
; #endregion
; #region Insert
#HotIf WinActive("ahk_group grpExplorer")
/**
 * Create Folder.
 * @hotkey Insert
 * @send   Ctrl + Shift + N
 */
Insert:: Send("^+n")
#HotIf !WinActive("ahk_group grpExplorer")
/**
 * @hotkey Insert
 * @send   Space
 */
Insert:: Send("{Space}")
/**
 * @hotkey Ctrl + Insert
 */
^Insert:: Send("^{Insert}")
/**
 * @hotkey Shift + Insert
 */
+Insert:: Send("+{Insert}")
#HotIf
; #endregion
/**
 * Toggle NumLock
 * @hotkey ScrollLock
 */
ScrollLock::
{
  static delay := Integer(Config_Get("Delay", "KEY"))
  state := GetKeyState("NumLock", "T")
  SetNumLockState(state ? "AlwaysOff" : "AlwaysOn")
  text := Format("NumLock: {}", state ? "Off" : "On")
  try
    if CaretGetPos(&x, &y)
      ToolTip(text, x, y)
    else
      ToolTip(text)
  finally
    SetTimer(() => ToolTip(), -delay)
}
#HotIf State_IsRemote()
/**
 * Disconnect Host Server.
 * @hotkey Pause
 * @see    {@link https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tsdiscon}
 */
Pause:: MsgBox("Session will be disconnected.", , 0x131) == "OK" ? Open("tsdiscon.exe") : 0
#HotIf !State_IsRemote()
/**
 * Turn Off Monitor.
 * @hotkey Pause
 * @see    https://learn.microsoft.com/en-us/windows/win32/menurc/wm-syscommand
 */
Pause::
{
  static delay := Integer(Config_Get("Delay", "KEY"))
  Sleep(delay)
  static WM_SYSCOMMAND := 0x0112
  static SC_MONITORPOWER := 0xF170
  PostMessage(WM_SYSCOMMAND, SC_MONITORPOWER, 2, , "A")
}
#HotIf
