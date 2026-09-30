#Requires AutoHotkey v2.0

/**
 * @see {@link https://support.microsoft.com/en-us/office/keyboard-shortcuts-in-excel-1798d9d5-842a-42b8-9c99-9b7213f0040f}
 */
#HotIf WinActive("ahk_class XLMAIN")
; #region Disabled
; Ctrl + F11: Insert Macro Sheet
^F11:: return
; F11: Insert Graph Sheet
F11:: return
; #endregion
; #region Default
/**
 * Open the Selection pane
 * @default
 * @hotkey  Alt + F10
 */
/**
 * Switch Next Sheet
 * @default
 * @hotkey  Ctrl + Tab
 */
/**
 * Switch Previous Sheet
 * @hotkey  Ctrl + CapsLock
 * @send    Ctrl + Shift + Tab
 */
^sc03A:: Send("^+{Tab}")
/**
 * Zoom In/Out
 * @default
 * @hotkey  Ctrl + [Shift] + Alt + -
 */
/**
 * Save As
 * @hotkey  Ctrl + Alt + S
 * @send    F12
 */
^!s:: Send("{F12}")
; #endregion
; #region File (Alt -> F)
/**
 * Create a PDF/XPS Document
 * @hotkey  Ctrl + Alt + E
 * @send    Alt -> F -> E -> A
 */
^!e:: Send("!fea")
; #endregion
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
/**
 * Copy as Picture
 * @hotkey  無変換 + F
 * @send    Alt -> H -> C -> P
 */
sc07B & f:: Send("!hcp")
; #endregion
; #region Font
/**
 * Borders
 * @hotkey  無変換 + B
 * @send    Alt -> H -> B
 */
sc07B & b:: Send("!hb")
/**
 * Increase Font Size
 * @hotkey  Ctrl + Alt + ;
 * @send    Alt -> H -> F -> G
 */
^!vkBB:: Send("!hfg")
/**
 * Decrease Font Size
 * @hotkey  Ctrl + Shift + Alt + ;
 * @send    Alt -> H -> F -> K
 */
^+!vkBB:: Send("!hfk")
/**
 * Fill Color
 * @hotkey  Ctrl + Alt + C
 * @send    Alt -> H -> H
 */
^!c:: Send("!hh")
; #endregion
; #region Alignment
/**
 * Increase Indent
 * @hotkey  無変換 + Tab
 * @send    Alt -> H -> 6
 */
sc07B & Tab:: Send("!h6")
/**
 * Decrease Indent
 * @hotkey  無変換 + CapsLock
 * @send    Alt -> H -> 5
 */
sc07B & sc03A:: Send("!h5")
/**
 * Merge Cells
 * @hotkey  無変換 + M
 * @send    Alt -> H -> M
 */
sc07B & m:: Send("!hm")
/**
 * Unmerge Cells
 * @hotkey  無変換 + U
 * @send    Alt -> H -> M -> U
 */
sc07B & u:: Send("!hmu")
; #endregion
; #region Cells
/**
 * Insert Sheet Rows
 * @hotkey  無変換 + R
 * @send    Alt -> H -> I -> 2 -> R
 */
sc07B & r:: Send("!hi2r")
/**
 * Insert Sheet Columns
 * @hotkey  無変換 + C
 * @send    Alt -> H -> I -> 2 -> L
 */
sc07B & c:: Send("!hi2c")
/**
 * Delete Cells
 * @hotkey  無変換 + X
 * @send    Alt -> H -> D -> D
 */
sc07B & x:: Send("!hdd")
/**
 * Format -> Rename Sheet
 * @hotkey  Ctrl + Shift + Alt + R
 * @send    Alt -> H -> O -> R
 */
^+!r:: Send("!hor")
/**
 * Format -> Move or Copy Sheet
 * @hotkey  Ctrl + Shift + Alt + M
 * @send    Alt -> H -> O -> M -> R
 */
^+!m:: Send("!homr")
; #endregion
; #region Editing
/**
 * Clear
 * @hotkey  Shift + Delete
 * @send    Alt -> H -> E
 */
+Delete:: Send("!he")
/**
 * Find & Select -> Select Objects
 * @hotkey  Ctrl + Alt + O
 * @send    Alt -> H -> F -> D -> O
 */
^!o:: Send("!hfdo")
/**
 * Sort & Filter -> Custom Sort
 * @hotkey  Shift + Alt + S
 * @send    Alt -> H -> S -> U
 */
+!s:: Send("!hsu")
/**
 * Sort & Filter -> Clear Sort
 * @hotkey  Ctrl + Shift + Alt + S
 * @send    Alt -> H -> S -> C
 */
^+!s:: Send("!hsc")
/**
 * Sort & Filter -> Reapply Filter
 * @hotkey  Ctrl + Alt + L
 * @send    Alt -> H -> S -> Y
 */
^!l:: Send("!hsy")
/**
 * Sort & Filter -> Clear Filter
 * @hotkey  Ctrl + Shift + Alt + L
 * @send    Alt -> H -> S -> C
 */
^+!l:: Send("!hsc")
; #endregion
; #endregion
; #region Insert (Alt -> N)
; #region Illustrations
/**
 * Insert Picture From File
 * @hotkey  無変換 + G
 * @send    Alt -> N -> P -> O -> D
 */
sc07B & g:: Send("!npod")
/**
 * Take a Screenshot.
 * @hotkey  Alt + PrintScreen
 * @send    Alt -> N -> S -> C
 */
Alt & PrintScreen:: Send("!nsc")
; #endregion
; #endregion
; #region Data (Alt -> A)
; #region Outline
/**
 * Show Detail
 * @hotkey  Ctrl + Alt + J
 * @send    Alt -> A -> J
 */
^!j:: Send("!aj")
/**
 * Hide Detail
 * @hotkey  Ctrl + Alt + H
 * @send    Alt -> A -> H
 */
^!h:: Send("!ah")
; #endregion
; #endregion
; #region Review (Alt -> R)
; #region Comments
/**
 * New Comment
 * @default
 * @hotkey  Ctrl + Alt + M
 */
/**
 * Show Comments
 * @hotkey  Ctrl + Alt + K
 * @send    Alt -> R -> H -> 1
 */
^!k:: Send("!rh1")
; #endregion
; #endregion
; #region View (Alt -> W)
; #region Dark Mode
/**
 * Switch Modes
 * @hotkey  Ctrl + Alt + I
 * @send    Alt -> W -> M -> 1
 */
^!i:: Send("!wm1")
; #endregion
; #region Show
/**
 * Navigation Pane
 * @hotkey  Ctrl + Alt + N
 * @send    Alt -> W -> K
 */
^!n:: Send("!wk")
; #endregion
; #region Zoom
/**
 * Reset Zoom
 * @hotkey  Ctrl + Alt + 0
 * @send    Alt -> W -> J
 */
^!0:: Send("!wj")
; #endregion
; #region Window
/**
 * Freeze Panes
 * @hotkey  Ctrl + Alt + F
 * @send    Alt -> W -> F -> F
 */
^!f:: Send("!wff")
; #endregion
; #endregion
#HotIf
