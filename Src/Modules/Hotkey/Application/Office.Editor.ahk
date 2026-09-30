#Requires AutoHotkey v2.0

/**
 * @see {@link https://learn.microsoft.com/en-us/office/vba/language/reference/user-interface-help/code-window}
 */
#HotIf WinActive("ahk_class wndclass_desked_gsk") ; Visual Basic Editor
/**
 * Compile
 * @hotkey  Ctrl + Shift + B
 * @send   Alt + D -> Alt + L
 */
^+b:: Send("!d"), Send("!l")
/**
 * Edit > Redo Delete
 * @hotkey  Ctrl + Shift + Z
 * @send   Alt -> E -> R
 */
^+z:: Send("!er")
/**
 * Cut the current line to the Clipboard
 * @hotkey  Ctrl + Shift + X
 * @send    Ctrl + Y
 */
^+x:: Send("^y")
/**
 * Hide Window
 * @hotkey  Ctrl + Shift + W
 * @send    Appskey -> H -> H -> Enter
 */
^+w:: Send("{AppsKey}"), Send("hh"), Send("{Enter}")
/**
 * Go to the definition of the selected procedure
 * @hotkey  F12
 * @send    Shift + F2
 */
F12:: Send("+{F2}")
/**
 * Go back to the last position in your code
 * @hotkey  Ctrl + -
 * @send    F7 -> Ctrl + Shift + F2
 */
^vkBD:: Send("{F7}"), Send("^+{F2}")
/**
 * Clear Immediate Window
 * @hotkey  Ctrl + Shift + L
 * @send    Ctrl + G -> Ctrl + A -> Delete
 */
^+l:: Send("^g"), Send("^a"), Send("{Delete}")
; #region Bookmark
/**
 * Toggle Bookmark
 * @hotkey  Ctrl + Alt + K
 * @send    Alt -> E -> B -> T
 */
^!k:: Send("!ebt")
/**
 * Next Bookmark
 * @hotkey  Ctrl + Alt + L
 * @send    Alt -> E -> B -> N
 */
^!l:: Send("!ebn")
/**
 * Previous Bookmark
 * @hotkey  Ctrl + Alt + J
 * @send    Alt -> E -> B -> P
 */
^!j:: Send("!ebp")
; #endregion
; #region Debug
/**
 * Step Into
 * @hotkey  F11
 * @send    F8
 */
F11:: Send("{F8}")
/**
 * Step Over
 * @hotkey  F10
 * @send    Shift + F8
 */
F10:: Send("+{F8}")
/**
 * Step Out
 * @hotkey  Shift + F11
 * @send    Ctrl + Shift + F8
 */
+F11:: Send("^+{F8}")
/**
 * Run to Cursor
 * @hotkey  Ctrl + F11
 * @send    Ctrl + F8
 */
^F11:: Send("^{F8}")
/**
 * Debug Reset
 * @hotkey  Shift + F5
 * @send    Alt -> R -> R
 */
+F5:: Send("!rr")
; #endregion
#HotIf
