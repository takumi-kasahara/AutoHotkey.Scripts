#Requires AutoHotkey v2.0

/**
 * @see {@link https://support.microsoft.com/en-us/office/keyboard-shortcuts-in-word-95ef89dd-7142-4b50-afb2-f762f663ceb2}
 */
#HotIf WinActive("ahk_class OpusApp")
; #region Home (Alt -> H)
; #region Clipboard
/**
 * Paste Special.
 * @default
 * @hotkey  Ctrl + Alt + V
 */
/**
 * Paste Text Only.
 * @default
 * @hotkey  Ctrl + Shift + V
 */
/**
 * Paste Options:
 * @hotkey  無変換 + V
 * @send    Alt -> H -> V
 */
sc07B & v:: Send("!hv")
; #endregion
; #endregion
; #region View (Alt -> W)
; #region Show
/**
 * Toggle Navigation Pane.
 * @hotkey  Ctrl + Alt + N
 * @send    Alt -> W -> K
 */
^!n:: Send("!wk")
; #endregion
; #endregion
#HotIf
