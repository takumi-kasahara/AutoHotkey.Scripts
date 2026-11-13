#Requires AutoHotkey v2.0

/**
 * @see {@link https://support.microsoft.com/en-us/accessibility/onenote/keyboard-shortcuts-in-onenote}
 */
/**
 * Open Sticky Notes.
 * @default
 * @hotkey  Win + Alt + S
 */
/**
 * New quick note.
 * @default
 * @hotkey  Win + Alt + N
 */
/**
 * Open OneNote.
 * @default
 * @hotkey  Win + Shift + N
 */
#HotIf WinActive("ahk_class Framework::CFrame")
; #region Home (Alt -> H)
; #region Clipboard
/**
 * Paste Options:
 * @hotkey  無変換 + V
 * @send    Alt -> H -> V
 */
sc07B & v:: Send("!hv")
; #endregion
; #endregion
; #region View (Alt -> W)
; #region Zoom
/**
 * Reset Zoom
 * @hotkey  Ctrl + Alt + 0
 * @send    Alt -> W -> 1
 */
^!0:: Send("!w1")
; #endregion
; #endregion
#HotIf
