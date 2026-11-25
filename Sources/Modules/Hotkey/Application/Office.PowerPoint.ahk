#Requires AutoHotkey v2.0

/**
 * @see {@link https://support.microsoft.com/en-us/accessibility/powerpoint/use-keyboard-shortcuts-to-create-powerpoint-presentations}
 * @see {@link https://support.microsoft.com/en-us/accessibility/powerpoint/use-keyboard-shortcuts-to-deliver-powerpoint-presentations}
 */
#HotIf WinActive("ahk_class PPTFrameClass")
; #region ComObjActive
/**
 * Copy Table
 * @hotkey  Ctrl + Alt + C
 */
^!c::
{
  app := ComObjActive("PowerPoint.Application")
  selection := app.ActiveWindow.Selection
  ppSelectionShapes := 2
  if selection.Type !== ppSelectionShapes
    return

  shape := selection.ShapeRange.Item(1)

  if shape.HasTable
  {
    tbl := shape.Table
    rows := tbl.Rows.Count
    cols := tbl.Columns.Count

    tsv := ""
    loop rows
    {
      r := A_Index
      rowText := ""
      loop cols
      {
        c := A_Index
        cell := tbl.Cell(r, c)
        text := cell.Shape.TextFrame.TextRange.Text
        text := StrReplace(text, "`r`n", " ")
        rowText .= text (c < cols ? "`t" : "")
      }
      tsv .= rowText (r < rows ? "`r`n" : "")
    }
    Clipboard_SetText(tsv)
    return
  }
  if shape.HasTextFrame && shape.TextFrame.HasText
  {
    text := shape.TextFrame.TextRange.Text
    text := StrReplace(text, "`r`n", "`n")
    Clipboard_SetText(text)
    return
  }
}
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
; #region Review (Alt -> R)
; #region Comments
/**
 * New Comment
 * @default
 * @hotkey  Ctrl + Alt + M
 */
; #endregion
; #endregion
; #region View (Alt -> W)
; #region Zoom
/**
 * Fit to Window
 * @hotkey  Ctrl + Alt + 0
 * @send    Alt -> W -> F
 */
^!0:: Send("!wf")
; #endregion
; #endregion
#HotIf
