#Requires AutoHotkey v2.0

/**
 * @see {@link https://support.microsoft.com/en-us/office/use-keyboard-shortcuts-to-create-powerpoint-presentations-ebb3d20e-dcd4-444f-a38e-bb5c5ed180f4}
 * @see {@link https://support.microsoft.com/en-us/office/use-keyboard-shortcuts-to-deliver-powerpoint-presentations-1524ffce-bd2a-45f4-9a7f-f18b992b93a0}
 */
#HotIf WinActive("ahk_class PPTFrameClass")
; #region Home (Alt -> H)
; #region Clipboard
/**
 * Paste Special.
 * @default
 * @hotkey  Ctrl + Alt + V
 */
/**
 * Paste Options:
 * @hotkey  無変換 + V
 * @send    Alt -> H -> V
 */
sc07B & v:: Send("!hv")
; #endregion
; #region Paragraph
/**
 * Increase List Level
 * @hotkey  無変換 + Tab
 * @send    Alt -> H -> A -> I
 */
sc07B & Tab:: Send("!hai")
/**
 * Decrease List Level
 * @hotkey  無変換 + CapsLock
 * @send    Alt -> H -> A -> O
 */
sc07B & sc03A:: Send("!hao")
; #endregion
; #endregion
#HotIf
